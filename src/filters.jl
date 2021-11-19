module filters

using LinearAlgebra

include("types.jl")
include("kf.jl")
include("ekf.jl")

export prediction, correction,  Init
export KFModel, EKFModel
end # module