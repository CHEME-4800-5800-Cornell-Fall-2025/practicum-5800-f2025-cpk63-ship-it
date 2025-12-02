# throw(ErrorException("Oppps! No methods defined in src/Factory.jl. What should you do here?"))

function build(modeltype::Type{MyClassicalHopfieldNetworkModel}, 
               data::NamedTuple{(:memories,), Tuple{Matrix{Int32}}})::MyClassicalHopfieldNetworkModel

    model = modeltype()
    memories = data.memories

    n, K = size(memories)

    # Hebbian weight matrix (Float32)
    W = zeros(Float32, n, n)
    for k in 1:K
        s = Float32.(memories[:, k])
        W .+= s * s'
    end
    W ./= K
    # no self-connections
    for i in 1:n
        W[i, i] = 0f0
    end

    # bias vector (zero) as Float32
    b = zeros(Float32, n)

    # energy for each stored memory: E(s) = -1/2 * s' * W * s - b' * s
    energy = Dict{Int64, Float32}()
    for k in 1:K
        s = Float32.(memories[:, k])
        E = -0.5f0 * dot(s, W * s) - dot(b, s)
        energy[k] = Float32(E)
    end

    model.W = W
    model.b = b
    model.energy = energy

    return model
end
