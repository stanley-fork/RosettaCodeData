-- Lua has no built in methods to handle csv files.
-- it does have string.gmatch, which we use to global.match whatever isn't a comma

print(io.read"l" .. ",SUM")
for line in io.lines() do
   local sum = 0
   for field in line:gmatch"[^,]+" do
      sum = sum + field
   end
   print(line .. "," .. sum)
end
