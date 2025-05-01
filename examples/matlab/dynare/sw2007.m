% Clear the environment to assure a clean replication. 
clear;
clc;

% Load TCA toolbox and Dynare
addpath("~/Documents/repos/tca-matlab-toolbox/")
addpath("~/Documents/repos/tca-matlab-toolbox/models/")
addpath("~/Documents/repos/tca-matlab-toolbox/plotting/")
addpath("/Applications/Dynare/6.3-arm64/matlab/")

% Running the Smets & Wouters (2007) model using Dynare. 
cd SW2007;
dynare SW2007;
cd ..;
clc;

%-------------------------------------------------------------------------------
% TCA SETUP
%-------------------------------------------------------------------------------

% Creating the DSGE model
model = DSGE(M_, options_, oo_);

%-------------------------------------------------------------------------------
% COMPUTING IRFS
%-------------------------------------------------------------------------------

% Getting total effects
maxHorizon = 20;
irfObj = model.IRF(maxHorizon);
irfs = irfObj.getIrfArray();

%-------------------------------------------------------------------------------
% DEFINING THE CHANNELS AND COMPUTING EFFECTS
%-------------------------------------------------------------------------------

% defining the transmission matrix / order
order = {'robs', 'dw', 'labobs', 'dc', 'dinve', 'dy', 'pinfobs'};
% Defining the demand channel as the effect not through wages up to horizon 20
channelDemand = model.notThrough('dw', 0:maxHorizon, order);
% The wage channel is the complement
channelWage = ~channelDemand;

% computing the effects through the demand and wage channel for the 'em' shock
effectDemand = model.transmission('em', channelDemand, order, maxHorizon);
effectWage = model.transmission('em', channelWage, order, maxHorizon);

%-------------------------------------------------------------------------------
% PLOTTING
%-------------------------------------------------------------------------------

channelNames = ["Demand Channel", "Wage Channel"];
idxInflation = model.getVariableIdx('pinfobs');
idxShock = model.getShockIdx('em');
cellChannelEffects = {effectDemand, effectWage};
fig = plotDecomposition(idxInflation, irfs(:, idxShock, :), cellChannelEffects, channelNames);

set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'first-round.png', 'Resolution', 300);

%-------------------------------------------------------------------------------
% ALTERNATIVE ORDERING
%-------------------------------------------------------------------------------

% Switching the order of wages and output system.
order = {'robs', 'labobs', 'dc', 'dinve', 'dy', 'dw', 'pinfobs'};

% Defining the channel again.
channelDemandAlt = model.notThrough('dw', 0:maxHorizon, order);
channelWageAlt = ~channelDemandAlt;
% Computing the alternative effects
effectDemandAlt = model.transmission('em', channelDemandAlt, order, maxHorizon);
effectWageAlt = model.transmission('em', channelWageAlt, order, maxHorizon);

% Plotting
channelNames = ["Demand Channel", "Wage Channel"];
idxInflation = model.getVariableIdx("pinfobs");
idxShock = model.getShockIdx('em');
cellChannelEffectsAlt = {effectDemandAlt, effectWageAlt};
fig = plotDecomposition(idxInflation, irfs(:, idxShock, :), cellChannelEffectsAlt, channelNames);

set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'second-round.png', 'Resolution', 300);

% Comparing the decompositions.
fig = plotCompareDecompositions(...
    idxInflation, ...
    irfs(:, idxShock, :), ...
    cellChannelEffectsAlt, ...
    cellChannelEffects, ...
    channelNames, ...
    ["Ordering 2", "Ordering 1"] ...
);

set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'comparisons.png', 'Resolution', 300);
