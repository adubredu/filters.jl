function prediction(model::EKFModel, init::Init)
    μ̂  = model.f(init.μ, init.u)
    Σ̂  = model.F(init.μ, init.u) * 
        init.Σ * transpose(model.F(init.μ, init.u)) + 
         model.W * model.Q * transpose(model.W)

    return μ̂ , Σ̂
end


function correction(model::EKFModel, z, μ̂, Σ̂ )
    H = model.H
    R = model.R
    V = model.V
    v = z - model.h(μ̂ )
    S = H(μ̂ ) * Σ̂  * transpose(H(μ̂ )) + 
        V * R* transpose(V)

    K = Σ̂ * transpose(H(μ̂ )) * inv(S)
    μ = μ̂  + K * v  
    Σ = (I - K*H(μ̂ ))*Σ̂ *transpose(I - K*H(μ̂ )) + K*R*transpose(K)

    return μ, Σ 
end 
 