using Printf

function _menu(items)
    for (ind, item) in enumerate(items)
        @printf "  %2i) %s\n" ind item
    end
end

_ok(::Any,::Any) = false
function _ok(reply::AbstractString, itemcount)
    n = tryparse(Int, reply)
    return isnothing(n) || 0 ≤ n ≤ itemcount
end

"Prompt to select an item from the items"
function _selector(items, prompt::AbstractString)
    isempty(items) && return ""
    reply = -1
    itemcount = length(items)
    while !_ok(reply, itemcount)
        _menu(items)
        print(prompt)
        reply = strip(readline())
    end
    return items[parse(Int, reply)]
end

items = ["fee fie", "huff and puff", "mirror mirror", "tick tock"]
item = _selector(items, "Which is from the three pigs: ")
println("You chose: ", item)
