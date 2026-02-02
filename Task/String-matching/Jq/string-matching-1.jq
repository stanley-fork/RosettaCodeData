# startswith/1 is boolean:
"abc" | startswith("ab")
#=> true

# index/1 returns the index or null,
# so the jq test "if index(_) then ...." can be used
# without any type conversion.

"abcd" | index( "bc")
#=> 1

# endswith/1 is also boolean:

"abc" | endswith("bc")
#=> true

# Using the regex functions available in jq 1.5:

"abc" | test( "^ab")

"abcd" | test("bc")

"abcd" | test("cd$")
