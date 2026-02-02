function lis(arr::Vector{T}) where T
    isempty(arr) && return copy(arr)
    allsequences = Vector{Vector{T}}(undef, length(arr))
    allsequences[begin] = [arr[begin]]

    for i in firstindex(arr)+1:lastindex(arr)
        nextseq = T[]
        for j in firstindex(arr):i
            if arr[j] < arr[i] && length(allsequences[j]) ≥ length(nextseq)
                nextseq = allsequences[j]
            end
        end
        allsequences[i] = push!(nextseq, arr[i])
    end
    _, idx = findmax(length, allsequences)
    return allsequences[idx]
end

@show lis([3, 2, 6, 4, 5, 1])
@show lis([0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15])
