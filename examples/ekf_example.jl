using Revise
using filters
using LinearAlgebra
using Plots
using ForwardDiff

f(x,u) = [x[1]; x[2]] 
h(x) = [sqrt(sum(x[1]^2 + x[2]^2)); atan(x[1], x[2])] 
F(x, u) = ForwardDiff.jacobian(f, x)
H(x) = ForwardDiff.jacobian(h, x) 

gt_x = -5:0.1:5.1
gt_y = 1. .* sin.(gt_x) .+ 3.

N = length(gt_x)

#measurement noise
R = Diagonal([0.05, 0.01].^2)
L = cholesky(R)
z = zeros((2, N))

for i=1:N 
    noise = L.L * randn(2,1)
    z[:,i] = [sqrt(gt_x[i]^2 + gt_y[i]^2), atan(gt_x[i], gt_y[i])] .+ noise 
end

Q = 1E-3 .* I(2) 
W = I(2)
V = I(2)

model = EKFModel(f, h, F, W, H, V, Q, R)

x₀ = zeros(2,1)
x₀[1,1] = z[1,1] * sin(z[2,1])
x₀[2,1] = z[1,1] * cos(z[2,1]) 
u₀ = 0.
Σ₀ = 1. * I(2)

init = Init(x₀, u₀, Σ₀)

xs = []
push!(xs, x₀)
for i = 2:N 
    μ̂ , Σ̂  = prediction(model, init)
    μ, Σ  = correction(model, z[:,i], μ̂, Σ̂ )
    init.μ = μ
    init.Σ = Σ
    push!(xs, μ)
end

xs = transpose(hcat([[x[1], x[2]] for x in xs]...))
plot(xs[:,1], xs[:,2], label="ekf")
plot!(gt_x, gt_y, label="Ground-Truth")
plot!(z[1,:], z[2,:],label="Sensor reading")