# throw(ErrorException("Oppps! No methods defined in src/Types.jl. What should you do here?"))

abstract type modelsOrSomething end

mutable struct MyClassicalHopfieldNetworkModel <: modelsOrSomething

    W::Array{Float32,2}
    b::Array{Float32,1}
    energy::Dict{Int64, Float32}

    MyClassicalHopfieldNetworkModel() = new(zeros(Float32,0,0), zeros(Float32,0), Dict{Int64, Float32}());

end