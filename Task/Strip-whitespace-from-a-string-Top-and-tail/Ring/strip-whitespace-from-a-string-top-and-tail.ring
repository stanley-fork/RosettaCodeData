cText = "   Welcome to the Ring Programming Language   "

see "Original: |" + cText + "|" + nl
see "LTrim:    |" + ltrim(cText) + "|" + nl
see "RTrim:    |" + rtrim(cText) + "|" + nl
see "Trim:     |" + trim(cText) + "|" + nl

func ltrim cStr
    while len(cStr) > 0 and left(cStr,1) = " "
        cStr = substr(cStr,2)
    end
    return cStr

func rtrim cStr
    while len(cStr) > 0 and right(cStr,1) = " "
        cStr = left(cStr,len(cStr)-1)
    end
    return cStr
