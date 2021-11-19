mutable struct KFModel
    A 
    B 
    H
    Q 
    R 

    function KFModel(A, B, H, Q, R)
        new(A, B, H, Q, R)
    end
end

mutable struct Init 
    μ 
    u
    Σ

    function Init(x, u, Σ)
        new(x, u, Σ)
    end
end

mutable struct EKFModel 
    f 
    h 
    F 
    W 
    H 
    V 
    Q 
    R 

    function EKFModel(f, h, F, W, H, V, Q, R)
        new(f, h, F, W, H, V, Q, R)
    end
end