function countunicode()
    count = 0
    az = ""
    AZ = ""
    for i in 0:0xffffff
        if isvalid(Char, i)
            c = Char(i)
            count += 1
            if i < 128 && isletter(c)
                if islowercase(c)
                    az *= "$c"
                elseif isuppercase(c)
                    AZ *= "$c"
                end
            end
        end
    end
    count, az, AZ
end

unicodecount, lcletters, ucletters = countunicode()

println("There are $unicodecount valid Chars and the ASCII English ones are:")
println("lowercase: $lcletters  and uppercase: $ucletters  .")
