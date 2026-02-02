using Printf

test = ["I", "III", "IX", "IVI", "IIM",
        "CMMDXL", "icv", "cDxLiV", "MCMLD", "ccccccd",
        "iiiiiv", "MMXV", "MCMLXXXIV", "ivxmm", "SPQR"]
for rnum in test
    @printf("%15s → %s\n", rnum, try parseroman(rnum) catch y "not valid" end)
end
