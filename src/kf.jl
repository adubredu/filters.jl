
function prediction(model::KFModel, init::Init)
    μ̂  = model.A * init.μ + model.B * init.u
    Σ̂  = model.A * init.Σ * transpose(model.A) + model.Q

    return μ̂ , Σ̂
end

function correction(model::KFModel, z, μ̂, Σ̂ )
    H = model.H
    R = model.R
    v = z - model.H * μ̂
    S = model.H * Σ̂ * transpose(H) + model.R 

    K = Σ̂ * transpose(H) * inv(S)
    μ = μ̂  + K * v 
    # Σ = (I - K*H)*Σ̂
    Σ = (I - K*H)*Σ̂ *transpose(I - K*H) + K*R*transpose(K)

    return μ, Σ 
end 
 