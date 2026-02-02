const ELEMENTS = split("""
H  He  Li  Be   B   C   N   O   F  Ne  Na  Mg  Al  Si   P   S  Cl  Ar
 K  Ca  Sc  Ti   V  Cr  Mn  Fe  Co  Ni  Cu  Zn  Ga  Ge  As  Se  Br  Kr
Rb  Sr   Y  Zr  Nb  Mo  Tc  Ru  Rh  Pd  Ag  Cd  In  Sn  Sb  Te   I  Xe
Cs  Ba  La  Ce  Pr  Nd  Pm  Sm  Eu  Gd  Tb  Dy  Ho  Er  Tm  Yb  Lu  Hf
Ta   W  Re  Os  Ir  Pt  Au  Hg  Tl  Pb  Bi  Po  At  Rn  Fr  Ra  Ak  Th
Pa   U  Np  Pu  Am  Cm  Bk  Cf  Es  Fm  Md  No  Lr  Rf  Db  Sg  Bh  Hs
Mt  Ds  Rg  Cn  Nh  Fl  Mc  Lv  Ts  Og
""", r"\s+")
const LIMITS = [3:10, 11:18, 19:36, 37:54, 55:86, 87:118]

function periodic_table(n)
    (n < 1 || n > 118) && error("Atomic number is out of range.")
    n == 1 && return (1, 1)
    n == 2 && return (1, 18)
    57 <= n <= 71 && return (8, n - 53)
    89 <= n <= 103 && return (9, n - 85)
    row, limitstart, limitstop = 0, 0, 0
    for i in eachindex(LIMITS)
        if LIMITS[i].start <= n <= LIMITS[i].stop
            row, limitstart, limitstop = i + 1, LIMITS[i].start, LIMITS[i].stop
            break
        end
    end
    return (n < limitstart + 2 || row == 4 || row == 5) ?
        (row, n - limitstart + 1) : (row, n - limitstop + 18)
end


function test_periodic_table()
    for n in [1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113]
        rc = periodic_table(n)
        println("Atomic number ", lpad(n, 3), " -> ($(rc[1]), $(rc[2]))")
    end
    positions = Dict(periodic_table(n) => n for n in 1:118)
    hline = "  __________________________________________________________________________ "
    vlines = "  |                                                                        |"

    println("\n", hline, "\n", vlines)
    for row in 1:9
        print("  | ")
        row == 8 && print("*Lanthanide ")
        row == 9 && print("° Actinide  ")
        for col in 1:18
            if haskey(positions, (row, col))
                print(lpad(ELEMENTS[positions[(row, col)]], 2), col == 18 ? " " : "  ")
            elseif row < 8
                print(col == 3 && row == 6 ? " *  " : col == 3 && row == 7 ? " °  " : "    ")
            end
        end
        println("|")
        println(vlines)
    end
    println(hline)
end

test_periodic_table()
