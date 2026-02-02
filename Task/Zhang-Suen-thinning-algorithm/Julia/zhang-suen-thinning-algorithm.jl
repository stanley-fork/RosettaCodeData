const rc01 = """
00000000000000000000000000000000
01111111110000000111111110000000
01110001111000001111001111000000
01110000111000001110000111000000
01110001111000001110000000000000
01111111110000001110000000000000
01110111100000001110000111000000
01110011110011101111001111011100
01110001111011100111111110011100
00000000000000000000000000000000"""
const pixels1 = map(c -> c == '1', stack([collect(line) for line in split(rc01, "\n") if !isempty(line)], dims = 1))

const rc02 = """
00000000000000000000000000000000000000000000000000000000000
01111111111111111100000000000000000001111111111111000000000
01111111111111111110000000000000001111111111111111000000000
01111111111111111111000000000000111111111111111111000000000
01111111100000111111100000000001111111111111111111000000000
00011111100000111111100000000011111110000000111111000000000
00011111100000111111100000000111111100000000000000000000000
00011111111111111111000000000111111100000000000000000000000
00011111111111111110000000000111111100000000000000000000000
00011111111111111111000000000111111100000000000000000000000
00011111100000111111100000000111111100000000000000000000000
00011111100000111111100000000111111100000000000000000000000
00011111100000111111100000000011111110000000111111000000000
01111111100000111111100000000001111111111111111111000000000
01111111100000111111101111110000111111111111111111011111100
01111111100000111111101111110000001111111111111111011111100
01111111100000111111101111110000000001111111111111011111100
00000000000000000000000000000000000000000000000000000000000"""
const pixels2 = map(c -> c == '1', stack([collect(line) for line in split(rc02, "\n") if !isempty(line)], dims = 1))

function surroundtesting(px, i, j, step)
    if px[i,j] == 0
        return false
    end
    isize, jsize = size(px)
    if i < 1 || j < 1 || i == isize || j == jsize                         # criteria 0.both
        return false
    end
    s = zeros(Int, 9)
    s[1] = s[9] = px[i-1,j]; s[2] = px[i-1,j+1]; s[3] = px[i,j+1]; s[4] = px[i+1,j+1]
    s[5] = px[i+1,j]; s[6] = px[i+1,j-1]; s[7] = px[i,j-1]; s[8] = px[i-1,j-1]
    b = sum(s[1:8])
    if b < 2 || b > 6                                                     # criteria 1.both
        return false
    end
    if sum([(s[i] == 0 && s[i+1] == 1) for i in 1:length(s)-1]) != 1      # criteria 2.both
        return false
    end
    if step == 1
        rightwhite = s[1] == 0 || s[3] == 0 || s[5] == 0                  # 1.3
        downwhite = s[3] == 0 || s[5] == 0 || s[7] == 0                   # 1.4
        return rightwhite && downwhite
    end
    upwhite = s[1] == 0 || s[3] == 0 || s[7] == 0                         # 2.3
    leftwhite = s[1] == 0 || s[5] == 0 || s[7] == 0                       # 2.4
    return upwhite && leftwhite
end


function zsthinning(mat; verbose = false)
    retmat = copy(mat)
    testmat = zeros(Int, size(mat))
    isize, jsize = size(testmat)
    needredo = true
    loops = 0
    while(needredo)
        loops += 1
        verbose && println("loop number $loops")
        needredo = false
        for n in 1:2
            for i in 1:isize, j in 1:jsize
                testmat[i,j] = surroundtesting(retmat, i, j, n) ? 1 : 0
            end
            for i in 1:isize, j in 1:jsize
                if testmat[i,j] == 1
                    retmat[i,j] = 0
                    needredo = true
                end
            end
        end
    end
    retmat
end


function asciiprint(mat)
    for i in 1:size(mat)[1]
        println(join(map(i -> i == 1 ? '#' : ' ', mat[i,:])))
    end
end

asciiprint(zsthinning(pixels1, verbose = true))
asciiprint(zsthinning(pixels2))
