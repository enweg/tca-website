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
% Defining the transmission matrix / order.
order = defineOrder(["robs", "dw", "labobs", "dc", "dinve", "dy", "pinfobs"], options_);
% Getting the systems-form used for TCA. 
[B, Omega] = makeSystemsForm(Phi0, As, Psis, order, 20);

%-------------------------------------------------------------------------------
% TESTING TOTAL EFFECT EQUALITY
%-------------------------------------------------------------------------------

% Getting total effects.
irfs = varmaIrfs(Phi0, As, Psis, 20);
% Getting the shock index.
idxShock = getShockIdx("em", M_);
% We only focus on the "em" shock. 
irfs = irfs(:, idxShock, :);
% Get original variable index for inflation
idx = getVariableIdx("pinfobs", options_);
% Comparing our IRFs to Dynare IRFs. The difference should be very small.  
vec(irfs(idx, 1, :)) - pinfobs_em

%-------------------------------------------------------------------------------
% DEFINING THE CHANNELS AND COMPUTING EFFECTS
%-------------------------------------------------------------------------------

% Obtaining the original variable index for wages. 
idxWage = getVariableIdx("dw", options_);
% Defining the output channel as the channel not going through wages in any
% period. 
channelOutput = notThrough(idxWage, 0:20, order);
% The wage channel is defined as the complement. The wage channel is thus 
% the effect going through wages in at least one period. 
channelWage = ~channelOutput;

% Obtaining the index for the monetary policy shock. 
[shockSize, shockIdx] = getShockSize(M_, "em");
% Computing the effect through the output channel. 
effectChannelOutput = transmission(shockIdx, B, Omega, channelOutput, "BOmega", order); 
% Computing the effect through the wage channel. 
effectChannelWage = transmission(shockIdx, B, Omega, channelWage, "BOmega", order);

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
[B, Omega] = makeSystemsForm(Phi0, As, Psis, order, 20);
% Defining the channel again.
idxWage = getVariableIdx("dw", options_);
channelOutputAlternative = notThrough(idxWage, 0:20, order);
channelWageAlternative = ~channelOutputAlternative;

[shockSize, shockIdx] = getShockSize(M_, "em");
effectChannelOutputAlt = transmission(shockIdx, B, Omega, channelOutputAlternative, "BOmega", order); 
effectChannelWageAlt = transmission(shockIdx, B, Omega, channelWageAlternative, "BOmega", order);

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
