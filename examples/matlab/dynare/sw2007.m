%-------------------------------------------------------------------------------
% BASIC ENVIRONMENT SETUP AND RUNNING DYNARE MODEL
%-------------------------------------------------------------------------------

% Clear the environment to assure a clean replication. 
clear;
clc;

% Adding Dynare to the path.
addpath("/Applications/Dynare/5.5-arm64/matlab");

% Running the Smets & Wouters (2007) model using Dynare. 
cd SW2007;
dynare SW2007;
cd ..;
clc;

%-------------------------------------------------------------------------------
% TCA SETUP
%-------------------------------------------------------------------------------

% Adding the TCA toolbox to the path.
addpath("~/Documents/repos/tca-matlab-toolbox/")
% Adding TCA Dynare functions.
addpath("~/Documents/repos/tca-matlab-toolbox/dynare")

% Getting the VARMA representation
[Phi0, As, Psis, p, q] = dynareToVarma(M_, oo_, options_);

%-------------------------------------------------------------------------------
% TESTING TOTAL EFFECT EQUALITY
%-------------------------------------------------------------------------------

% Getting total effects.
irfs = varmaIrfs(Phi0, As, Psis, 20);
% Getting the shock index.
idxShock = getShockIdx("em", M_);
% Getting the shock size of the monetary policy shock. 
shockSize = getShockSize("em", M_);
% We only focus on the "em" shock. 
% We need to multiply by the shock size. 
irfs = irfs(:, idxShock, :) * shockSize;
% Get original variable index for inflation
idx = getVariableIdx("pinfobs", options_);
% Comparing our IRFs to Dynare IRFs. The difference should be very small.  
vec(irfs(idx, 1, :)) - pinfobs_em

%-------------------------------------------------------------------------------
% DEFINING THE CHANNELS AND COMPUTING EFFECTS
%-------------------------------------------------------------------------------

% Defining the transmission matrix / order.
order = defineOrder(["robs", "dw", "labobs", "dc", "dinve", "dy", "pinfobs"], options_);
% Obtaining the original variable index for wages. 
idxWage = getVariableIdx("dw", options_);
% Defining the output channel as the channel not going through wages in any
% period. 
channelOutput = notThrough(idxWage, 0:20, order);
% The wage channel is defined as the complement. The wage channel is thus 
% the effect going through wages in at least one period. 
channelWage = ~channelOutput;

% Getting the systems-form used for TCA. 
[B, Omega] = makeSystemsForm(Phi0, As, Psis, order, 20);
% Obtaining the index for the monetary policy shock. 
idxShock = getShockIdx("em", M_);
% Computing the effect through the output channel. 
% We need to multiply by the shock size. 
effectChannelOutput = transmission(idxShock, B, Omega, channelOutput, "BOmega", order) * shockSize; 
% Computing the effect through the wage channel. 
% We need to multiply by the shock size. 
effectChannelWage = transmission(idxShock, B, Omega, channelWage, "BOmega", order) * shockSize;

%-------------------------------------------------------------------------------
% PLOTTING
%-------------------------------------------------------------------------------

addpath("~/Documents/repos/tca-matlab-toolbox/plotting/")
channelNames = ["Output Channel", "Wage Channel"];
idxInflation = getVariableIdx("pinfobs", options_);
cellChannelEffects = {effectChannelOutput, effectChannelWage};
fig = plotDecomposition(idxInflation, irfs, cellChannelEffects, channelNames);

set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'first-round.png', 'Resolution', 300);

%-------------------------------------------------------------------------------
% ALTERNATIVE ORDERING
%-------------------------------------------------------------------------------

% Switching the order of wages and output system.
order = defineOrder(["robs", "labobs", "dc", "dinve", "dy", "dw", "pinfobs"], options_);

% Defining the channel again.
idxWage = getVariableIdx("dw", options_);
channelOutputAlternative = notThrough(idxWage, 0:20, order);
channelWageAlternative = ~channelOutputAlternative;
% Computing the transmission effects.
[B, Omega] = makeSystemsForm(Phi0, As, Psis, order, 20);
idxShock = getShockIdx("em", M_);
shockSize = getShockSize("em", M_);
effectChannelOutputAlt = transmission(idxShock, B, Omega, channelOutputAlternative, "BOmega", order) * shockSize; 
effectChannelWageAlt = transmission(idxShock, B, Omega, channelWageAlternative, "BOmega", order) * shockSize;

% Plotting
channelNames = ["Output Channel", "Wage Channel"];
idxInflation = getVariableIdx("pinfobs", options_);
cellChannelEffectsAlt = {effectChannelOutputAlt, effectChannelWageAlt};
fig = plotDecomposition(idxInflation, irfs, cellChannelEffectsAlt, channelNames);

set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'second-round.png', 'Resolution', 300);

% Comparing the decompositions.
fig = plotCompareDecompositions(...
    idxInflation, ...
    irfs, ...
    cellChannelEffects, ...
    cellChannelEffectsAlt, ...
    channelNames, ...
    ["First-round", "Second-round"] ...
);

set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'comparisons.png', 'Resolution', 300);
