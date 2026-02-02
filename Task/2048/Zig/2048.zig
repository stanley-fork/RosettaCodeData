// git repository at https://codeberg.org/Vulwsztyn/2048_zig
const std = @import("std");
const builtin = @import("builtin");

const Io = std.Io;
const Random = std.Random;
const fmt = std.fmt;

const mibu = @import("mibu");
const color = mibu.color;
const events = mibu.events;
const term = mibu.term;
const cursor = mibu.cursor;

// You can change these constants to modify the game behavior
const ROW_SIZE = 4; // program won't work if less than 2
const COL_SIZE = 4; // program won't work if less than 2
const TARGET_SCORE = 11; // 2^11 = 2048
const PROBABILITY_OF_FOUR_NUMERATOR = 10;
const PROBABILITY_OF_FOUR_DENOMINATOR = 100; // these 2 work in tandem to give chance of spawning a 4 instead of 2

const Dir = enum { up, down, left, right };
const Action = union(enum) {
    Move: Dir,
    Quit,
    Noop,
};

fn spawn(comptime X: usize, comptime Y: usize, matrix_p: *[X][Y]u8, rand: Random) void {
    var buffer: [X * Y]u8 = undefined;
    var zero_indices = std.ArrayListUnmanaged(u8).initBuffer(&buffer);
    for (matrix_p, 0..) |row, i| {
        for (row, 0..) |val, j| {
            if (val == 0) {
                zero_indices.appendBounded(@intCast(i * Y + j)) catch unreachable;
            }
        }
    }
    const random_index = rand.intRangeAtMost(u8, 0, @intCast(zero_indices.items.len - 1));
    const chosen = zero_indices.items[random_index];
    const row = chosen / Y;
    const col = chosen % Y;
    const value: u8 = if (rand.intRangeAtMost(u8, 0, PROBABILITY_OF_FOUR_DENOMINATOR) < PROBABILITY_OF_FOUR_NUMERATOR) 2 else 1;
    matrix_p[row][col] = value;
}

fn additives_for_previous(dir: Dir) [2]i8 {
    // assuming that for a move in a direction, we look at the values at the end
    // and check backwards
    // e.g. for up, we look at the top row and check downwards
    // so we return 1, 0 meaning one row down, same column
    switch (dir) {
        .up => {
            return .{ 1, 0 };
        },
        .down => {
            return .{ -1, 0 };
        },
        .left => {
            return .{ 0, 1 };
        },
        .right => {
            return .{ 0, -1 };
        },
    }
}
fn is_move_possible(comptime X: usize, comptime Y: usize, matrix_p: [X][Y]u8, dir: Dir) bool {
    // checks if move is possible by checking if any tile can be moved or combined
    const additives = additives_for_previous(dir);
    for (0..X) |i| {
        const i_signed: i8 = @intCast(i);
        const new_i = i_signed + additives[0];
        if (new_i < 0 or new_i >= X) continue;
        for (0..Y) |j| {
            const j_signed: i8 = @intCast(j);
            const new_j = j_signed + additives[1];
            if (new_j < 0 or new_j >= Y) continue;
            const val = matrix_p[i][j];
            const prev_val = matrix_p[@intCast(new_i)][@intCast(new_j)];
            if (val != 0 and val == prev_val) return true;
            if (val == 0 and prev_val != 0) return true;
        }
    }
    return false;
}

fn is_game_lost(comptime X: usize, comptime Y: usize, matrix_p: [X][Y]u8) bool {
    // checks if move in any direction is possible
    for (std.meta.tags(Dir)) |dir| {
        if (is_move_possible(X, Y, matrix_p, dir)) {
            return false;
        }
    }
    return true;
}

fn is_game_won(comptime X: usize, comptime Y: usize, matrix_p: [X][Y]u8) bool {
    for (matrix_p) |row| {
        for (row) |val| {
            if (val >= TARGET_SCORE) {
                return true;
            }
        }
    }
    return false;
}

fn last_positions(comptime X: usize, comptime Y: usize, dir: Dir, gpa: std.mem.Allocator) std.ArrayList([2]u8) {
    // see comment in additives_for_previous
    // e.g. for move up we start at the top row and go downwards
    // this function returns the list positions in the top row (for that scenario)
    var list: std.ArrayList([2]u8) = .empty;
    switch (dir) {
        .up => {
            for (0..Y) |i| {
                list.append(gpa, .{ 0, @intCast(i) }) catch unreachable;
            }
        },
        .down => {
            for (0..Y) |i| {
                list.append(gpa, .{ X - 1, @intCast(i) }) catch unreachable;
            }
        },
        .left => {
            for (0..X) |i| {
                list.append(gpa, .{ @intCast(i), 0 }) catch unreachable;
            }
        },
        .right => {
            for (0..X) |i| {
                list.append(gpa, .{ @intCast(i), X - 1 }) catch unreachable;
            }
        },
    }
    return list;
}

fn move_matrix(comptime X: usize, comptime Y: usize, matrix_p: *[X][Y]u8, dir: Dir) void {
    const gpa = std.heap.page_allocator;
    const additives = additives_for_previous(dir);
    var postions = last_positions(X, Y, dir, gpa);
    defer postions.deinit(gpa);
    std.debug.print("\n", .{});
    for (postions.items) |pos| {
        var target_row: i8 = @intCast(pos[0]);
        var target_col: i8 = @intCast(pos[1]);
        var target_val: u8 = matrix_p[pos[0]][pos[1]];
        var current_row: i8 = target_row;
        var current_col: i8 = target_col;
        while (true) {
            current_row += additives[0];
            current_col += additives[1];
            const went_out_of_bounds = current_row < 0 or current_row >= (X) or
                current_col < 0 or current_col >= (Y);
            if (went_out_of_bounds) {
                break;
            }
            const current_val: u8 = matrix_p[@intCast(current_row)][@intCast(current_col)];
            if (current_val == 0) {
                // nothing to do,
                continue;
            }
            if (target_val != 0 and target_val != current_val) {
                // cannot combine, move target forward
                // e.g 0 0 2 4 (for was target, now 2 becomes target)
                matrix_p[@intCast(current_row)][@intCast(current_col)] = 0;
                target_row = (target_row) + (additives[0]);
                target_col = (target_col) + (additives[1]);
                matrix_p[@intCast(target_row)][@intCast(target_col)] = current_val;
                target_val = matrix_p[@intCast(target_row)][@intCast(target_col)];
                continue;
            }
            if (target_val == 0) {
                // move current to target
                // e.g 0 0 2 0 -> 0 0 0 2 (2 remains target, since we want 0 2 2 0 to become 0 0 0 4)
                matrix_p[@intCast(target_row)][@intCast(target_col)] = current_val;
                target_val = current_val;
            } else {
                // combine
                // e.g 0 0 2 2 -> 0 0 0 4 (with rightmost zero becoming target, since the movements are not greedy)
                matrix_p[@intCast(target_row)][@intCast(target_col)] = target_val + 1;
                target_val = 0;
                target_row = target_row + (additives[0]);
                target_col = target_col + (additives[1]);
            }
            // both in case of move and combine we clear current
            matrix_p[@intCast(current_row)][@intCast(current_col)] = 0;
        }
    }
}

fn print(comptime X: usize, comptime Y: usize, matrix_p: [X][Y]u8, stdout: *Io.Writer) !void {
    for (matrix_p, 0..) |row, i| {
        try cursor.goTo(stdout, 1, 2 + i);
        var buf: [100]u8 = undefined;
        const all_together_slice = buf[0..];
        for (row) |val| {
            const value = if (val != 0) std.math.pow(u16, 2, @intCast(val)) else 0;
            const value_as_str = if (val > 0) try fmt.bufPrint(all_together_slice, "{d}", .{value}) else "_";

            try color.fg256(stdout, if (val > 1) @enumFromInt(val) else color.Color.white); // sets colour based on value
            try stdout.print("{s:>5} ", .{value_as_str}); // prints with padding
        }
        try stdout.print("\x1b[K\n", .{});
    }
}

fn init_matrix(comptime X: usize, comptime Y: usize, matrix_p: *[X][Y]u8) void {
    // initializes matrix to all zeros
    for (matrix_p) |*row| {
        for (row) |*val| {
            val.* = @intCast(0);
        }
    }
}

fn action_from_event(next: events.Event) Action {
    switch (next) {
        .key => |k| switch (k.code) {
            .char => |c| switch (c) {
                'c' => {
                    return .Quit;
                },
                'q' => {
                    return .Quit;
                },
                'w' => {
                    return .{ .Move = .up };
                },
                's' => {
                    return .{ .Move = .down };
                },
                'a' => {
                    return .{ .Move = .left };
                },
                'd' => {
                    return .{ .Move = .right };
                },
                'h' => {
                    return .{ .Move = .left };
                },
                'j' => {
                    return .{ .Move = .down };
                },
                'k' => {
                    return .{ .Move = .up };
                },
                'l' => {
                    return .{ .Move = .right };
                },
                else => {
                    return .Noop;
                },
            },
            .up => {
                return .{ .Move = .up };
            },
            .down => {
                return .{ .Move = .down };
            },
            .left => {
                return .{ .Move = .left };
            },
            .right => {
                return .{ .Move = .right };
            },
            else => {
                return .Noop;
            },
        },
        else => {
            return .Noop;
        },
    }
}

pub fn main() !void {
    const row_size = ROW_SIZE;
    const col_size = COL_SIZE;
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));

    var prng = Random.DefaultPrng.init(seed);
    const rand = prng.random();

    var stdout_buffer: [1024]u8 = undefined;

    const stdin = std.fs.File.stdin();
    var stdout_file = std.fs.File.stdout();
    var stdout_writer = stdout_file.writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    if (!std.posix.isatty(stdin.handle)) {
        try stdout.print("The current file descriptor is not a referring to a terminal.\n", .{});
        return;
    }

    if (builtin.os.tag == .windows) {
        try mibu.enableWindowsVTS(stdout.handle);
    }

    // Enable terminal raw mode, its very recommended when listening for events
    var raw_term = try term.enableRawMode(stdin.handle);
    defer raw_term.disableRawMode() catch {
        std.debug.print("Failed to disable raw mode\n", .{});
    };

    try term.enterAlternateScreen(stdout);
    defer term.exitAlternateScreen(stdout) catch {
        std.debug.print("Failed to exit alternate screen\n", .{});
    };

    try cursor.hide(stdout);
    defer cursor.show(stdout) catch {
        std.debug.print("Failed to show cursor\n", .{});
    };

    try cursor.goTo(stdout, 1, 1);
    try mibu.style.italic(stdout, true);

    var matrix: [row_size][col_size]u8 = undefined;

    init_matrix(row_size, col_size, &matrix);

    spawn(row_size, col_size, &matrix, rand);
    try stdout.print("move with wsad, hjkl, or arrows; quit with c or q\x1b[K\n", .{}); // prints with padding

    try print(row_size, col_size, matrix, stdout);

    try stdout.flush();

    while (true) {
        try cursor.goTo(stdout, 1, 2);
        const next = try events.next(stdin);
        const action = action_from_event(next);
        switch (action) {
            .Quit => break,
            .Noop => continue,
            .Move => |dir| {
                if (is_move_possible(row_size, col_size, matrix, dir)) {
                    move_matrix(row_size, col_size, &matrix, dir);
                    try print(row_size, col_size, matrix, stdout);
                    if (is_game_won(row_size, col_size, matrix)) {
                        try cursor.goTo(stdout, 1, row_size + 3);
                        try stdout.print("You won! Congratulations!\n", .{});
                        try stdout.flush();
                        break;
                    }
                    spawn(row_size, col_size, &matrix, rand);
                    try print(row_size, col_size, matrix, stdout);
                    if (is_game_lost(row_size, col_size, matrix)) {
                        try cursor.goTo(stdout, 1, (row_size + 3));
                        try stdout.print("Game over! No more moves possible!\n", .{});
                        try stdout.flush();
                        break;
                    }
                }
                try stdout.flush();
            },
        }
    }
}
