# throw(ErrorException("Oppps! No methods defined in src/Compute.jl. What should you do here?"))

function decode(s::AbstractVector{<:Integer})
    return (s .+ 1) ./ 2
end


function recover(model::MyClassicalHopfieldNetworkModel, 
        s0::Vector{Int32},
        true_image_energy::Float32; 
        maxiterations::Int64,
        patience::Int64, 
        miniterations_before_convergence::Union{Int,Nothing}=nothing)

    W = model.W
    b = model.b
    N = length(s0)
    state = copy(s0)
    
    frames = Dict{Int64, Vector{Int32}}()
    energydict = Dict{Int64, Float32}()
    history = Vector{Vector{Int32}}()
    
    if miniterations_before_convergence === nothing
        miniterations_before_convergence = patience
    end
    
    converged = false
    t = 1
    
    while !converged && t <= maxiterations
        old_state = copy(state)
        
        i = rand(1:N)
        h = sum(W[i,j] * state[j] for j in 1:N) - b[i]
        state[i] = h >= 0 ? 1 : -1
        
        frames[t] = copy(state)
        energydict[t] = -0.5f0 * sum(state[i]*W[i,j]*state[j] for i in 1:N, j in 1:N) - sum(b .* state)
        
        push!(history, copy(state))
        if length(history) > patience
            popfirst!(history)
        end
        
        if t >= miniterations_before_convergence && length(history) == patience
            all_same = all(x -> x == state, history)
            if all_same
                println("State stability at iteration $t")
                converged = true
            end
        end
        
        if true_image_energy != 0.0 && energydict[t] <= true_image_energy
            println("True minimum energy at iteration $t")
            converged = true
        end
        
        t += 1
    end
    
    if !converged
        println("Maximum iterations")
    end
    
    return frames, energydict
end