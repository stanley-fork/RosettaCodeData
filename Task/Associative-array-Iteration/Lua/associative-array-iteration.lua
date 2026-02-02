local function f1(x) print(x) return x end

local t = { ["foo"]   = "bar"
          , ["baz"]   = 6
          , fortytwo  = 7
          , [42]      = { 1, 2, 3 }
          , [f1]      = true
          , ["zz"]    = f1
          }

for key,val in pairs(t) do
    print(string.format("%28s (%9s) -> (%9s) %s", key, type(key), type(val), val))
end
