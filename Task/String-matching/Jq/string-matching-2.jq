# In jq 1.4 or later:
jq -n '"abcdabcd" | indices("bc")'
[
  1,
  5
]

# In jq 1.5, the regex function match/1 can also be used:
$ jq -n '"abcdabcd" | match("bc"; "g") | .offset'
1
5
