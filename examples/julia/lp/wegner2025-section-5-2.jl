using TransmissionChannelAnalysis
using DataFrames, CSV
using CairoMakie  # for plotting

data = DataFrame(CSV.File("./data.csv"))

# 1. Defining the model
model = LP(data, :newsy, 4, 0:20; include_constant=true)
fit!(model)

# 2. Obtaining total effects
method = Recursive()
irfs = IRF(model, method, 20)
irfs = irfs.irfs[:, 1:1, :]

# 3. Defining the transmission matrix
transmission_order = [:newsy, :gdef, :g, :y]

# 4. Defining transmission channels
anticipation_channel = not_through(model, :gdef, 0:20, transmission_order)
implementation_channel = !anticipation_channel

# 5. Computing transmission effects
anticipation_effects = transmission(model, method, 1, anticipation_channel, transmission_order, 20)
implementation_effects = transmission(model, method, 1, implementation_channel, transmission_order, 20)

# 6. Visualising the effects
teffects = [anticipation_effects, implementation_effects]
channel_names = ["Anticipation", "Implementation"]

fig = Figure(; size=(1000, 300));
ax1 = Axis(fig[1, 1]; title="GDP")
plot_decomposition!(ax1, 4, irfs, teffects)
ax2 = Axis(fig[1, 2]; title="Total Government Spending")
plot_decomposition!(ax2, 3, irfs, teffects)
ax3 = Axis(fig[1, 3]; title="Defense Spending")
plot_decomposition!(ax3, 2, irfs, teffects)
add_decomposition_legend!(fig[2, :], channel_names)

fig

save("./decomposition.png", fig)

