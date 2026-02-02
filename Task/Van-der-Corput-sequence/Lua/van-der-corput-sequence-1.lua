function vdc(n, base)
    local digits = {}
    while n ~= 0 do
        local m = math.floor(n / base)
        table.insert(digits, n - m * base)
        n = m
    end
    m = 0
    for p, d in pairs(digits) do
        m = m + math.pow(base, -p) * d
    end
    return m
end
for b = 2, 5 do
    io.write( "base ", b, ":  " )
    for n = 0, 9 do
        local m = vdc(n, b)
        io.write(string.format("%0.4f  ", m))
    end
    print()
end
