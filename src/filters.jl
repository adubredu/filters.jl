module filters

using LinearAlgebra

include("types.jl")
include("kf.jl")

export prediction, correction, KFModel, Init

end # module