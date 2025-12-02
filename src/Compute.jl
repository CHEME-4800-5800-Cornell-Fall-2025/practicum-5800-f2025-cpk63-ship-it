# throw(ErrorException("Oppps! No methods defined in src/Compute.jl. What should you do here?"))

function decode(s::AbstractVector{<:Integer})
    return (s .+ 1) ./ 2
end