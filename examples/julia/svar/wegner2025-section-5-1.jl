using TransmissionChannelAnalysis
using DataFrames, CSV
using CairoMakie, Makie  # for plotting

data = DataFrame(CSV.File("./data.csv"))

#-------------------------------------------------------------------------------
# GERTLER KARADI
#-------------------------------------------------------------------------------

# Selecting the required variables
data_gk = select(data, :mp1_tc, :ffr, :ygap, :infl, :lpcom)

# Defining the VAR model with a constant and linear trend
model = VAR(data_gk, 4; trend_exponents=0:1)
fit!(model)

# We are using an internal instrument (the first variable) and normalise it 
# by the contemporaneous response of `ffr`.
method = InternalInstrument(:ffr)
# Computing IRFs using the internal instrument. Normalising the response to a 
# 25bps increase in ffr. 
irf_obj = IRF(model, method, 40)
irfs = irf_obj.irfs[:, 1:1, :] * 0.25

# Defining the transmission matrix / order
transmission_order = [:mp1_tc, :ffr, :ygap, :infl, :lpcom]

# Defining the transmission channels
channel_noncontemp = not_through(model, :ffr, 0:0, transmission_order)
channel_contemp = !channel_noncontemp

# Computing transmission effects
effects_noncontemp = transmission(model, method, 1, channel_noncontemp, transmission_order, 40)
effects_contemp = transmission(model, method, 1, channel_contemp, transmission_order, 40)
# Adjusting for the shock size
effects_noncontemp .*= 0.25
effects_contemp .*= 0.25
# The effects should perfectly decompose the total effects
isapprox(irfs, effects_noncontemp + effects_contemp; atol=sqrt(eps()))

# Plotting only one outcome
teffects = [effects_contemp, effects_noncontemp]
channel_names = ["Contemporaneous", "Non-contemporaneous"]
plot_decomposition(2, irfs[:, 1:1, :], teffects, channel_names; legend=true)

# Plotting the decomposition for all outcomes in one figure
fig = Figure(;size=(1000, 300));
ax = Axis(fig[1, 1]; title="FFR")
plot_decomposition!(ax, 2, irfs[:, 1:1, :], teffects);
ax2 = Axis(fig[1, 2]; title="Inflation");
plot_decomposition!(ax2, 4, irfs[:, 1:1, :], teffects);
add_decomposition_legend!(fig[2, :], channel_names)
fig

save("./gk_both.png", fig)

#-------------------------------------------------------------------------------
# ROMER AND ROMER
#-------------------------------------------------------------------------------

# Selecting the required variables
data_rr = select(data, :rr_3, :ffr, :ygap, :infl, :lpcom)

# Defining the VAR model with a constant and linear trend
model = VAR(data_rr, 4; trend_exponents=0:1)
fit!(model)

# We are using an internal instrument (the first variable) and normalise it 
# by the contemporaneous response of `ffr`.
method = InternalInstrument(:ffr)
# Computing IRFs using the internal instrument. Normalising the response to a 
# 25bps increase in ffr. 
irf_obj = IRF(model, method, 40)
irfs = irf_obj.irfs[:, 1:1, :] * 0.25

# Defining the transmission matrix / order
transmission_order = [:rr_3, :ffr, :ygap, :infl, :lpcom]

# Defining the transmission channels
channel_noncontemp = not_through(model, :ffr, 0:0, transmission_order)
channel_contemp = through(model, :ffr, 0:0, transmission_order)

# Computing transmission effects
effects_noncontemp = transmission(model, method, 1, channel_noncontemp, transmission_order, 40)
effects_contemp = transmission(model, method, 1, channel_contemp, transmission_order, 40)
# Adjusting for the shock size
effects_noncontemp .*= 0.25
effects_contemp .*= 0.25
# The effects should perfectly decompose the total effects
isapprox(irfs, effects_noncontemp + effects_contemp; atol=sqrt(eps()))

# Plotting the decomposition
teffects = [effects_contemp, effects_noncontemp]
channel_names = ["Contemporaneous", "Non-contemporaneous"]
fig = Figure(;size=(1000, 300));
ax = Axis(fig[1, 1]; title="FFR")
plot_decomposition!(ax, 2, irfs[:, 1:1, :], teffects);
ax2 = Axis(fig[1, 2]; title="Inflation");
plot_decomposition!(ax2, 4, irfs[:, 1:1, :], teffects);
add_decomposition_legend!(fig[2, :], channel_names)
fig

save("./rr_both.png", fig)
