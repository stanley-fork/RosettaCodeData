function sumt(t, start, last) return start <= last and t[start] + sumt(t, start+1, last) or 0 end
function maxsub(ary, idx)
  local idx = idx or 1
  if not ary[idx] then return {} end
  local maxsum, last = 0, idx
  for i = idx, #ary do
    if sumt(ary, idx, i) > maxsum then maxsum, last = sumt(ary, idx, i), i end
  end
  local v = maxsub(ary, idx + 1)
  if maxsum < sumt(v, 1, #v) then return v end
  local ret, allNegative = {}, true
  for i = idx, last do
      ret[#ret+1] = ary[i]
      if ret[#ret] >= 0 then allNegative = false end
  end
  return allNegative and {} or ret
end

local function test(s)
    local msub = maxsub(s)
    print("["..table.concat(s, " ").."] -> ["..table.concat(msub, " ").."] sum: "..sumt(msub, 1, #msub))
end

-- test cases from 11l
test {-1, 2, -1}
test {-1, 2, -1, 3, -1}
test {-1, 1, 2, -5, -6}
test {-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1}

-- additional test cases
test {-1, -2, -1}
test {}
