clear; 
clc; 

addpath("~/Documents/repos/tca-matlab-toolbox/");
addpath("~/Documents/repos/tca-matlab-toolbox/plotting");
addpath("~/Documents/repos/tca-matlab-toolbox/models");

data = readtable("./data.csv");

%-------------------------------------------------------------------------------
% GERTLER KARADI
%-------------------------------------------------------------------------------

keepCols = {'mp1_tc', 'ffr', 'ygap', 'infl', 'lpcom'};
dataGK = data(:, keepCols);

% VAR using 4 lags, a constant, and a linear trend
model = VAR(dataGK, 4, 'trendExponents', 0:1);
model.fit();
% Internal instrument 
% choosing ffr to be the normalising variable
method = InternalInstrument('ffr');
% computing IRFs
irfObj = model.IRF(40, 'identificationMethod', method);
irfs = irfObj.getIrfArray();
irfs = irfs(:, 1, :) * 0.25;
% Defining transmission matrix
transmissionOrder = {'mp1_tc', 'ffr', 'ygap', 'infl', 'lpcom'};
% Defining the transmission channels
channelNonContemp = model.notThrough('ffr', 0, transmissionOrder);
channelContemp = model.through('ffr', 0', transmissionOrder);
% Transmission effects
effectsNonContemp = model.transmission(1, channelNonContemp, transmissionOrder, 40, 'identificationMethod', method);
effectsContemp = model.transmission(1, channelContemp, transmissionOrder, 40, 'identificationMethod', method);
% adjusting for shock size
effectsNonContemp = effectsNonContemp * 0.25;
effectsContemp = effectsContemp * 0.25;
% The effects should perfectly decompose the total effects
max(vec(irfs - effectsContemp - effectsNonContemp))
% Plotting the decomposition
channelNames = ["Contemporaneous", "Non-Contemporaneous"];
cellChannelEffects = {effectsContemp, effectsNonContemp};
% for ffr
fig = plotDecomposition(2, irfs, cellChannelEffects, channelNames);
set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'gk-ffr.png', 'Resolution', 300);
% for inflation
fig = plotDecomposition(4, irfs, cellChannelEffects, channelNames);
set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'gk-infl.png', 'Resolution', 300);

%-------------------------------------------------------------------------------
% ROMER AND ROMER
%-------------------------------------------------------------------------------

keepCols = {'rr_3', 'ffr', 'ygap', 'infl', 'lpcom'};
dataRR = data(:, keepCols);

% VAR using 4 lags, a constant, and a linear trend
model = VAR(dataRR, 4, 'trendExponents', 0:1);
model.fit();
% Internal instrument 
% choosing ffr to be the normalising variable
method = InternalInstrument('ffr');
% computing IRFs
irfObj = model.IRF(40, 'identificationMethod', method);
irfs = irfObj.getIrfArray();
irfs = irfs(:, 1, :) * 0.25;
% Defining transmission matrix
transmissionOrder = {'rr_3', 'ffr', 'ygap', 'infl', 'lpcom'};
% Defining the transmission channels
channelNonContemp = model.notThrough('ffr', 0, transmissionOrder);
channelContemp = model.through('ffr', 0', transmissionOrder);
% Transmission effects
effectsNonContemp = model.transmission(1, channelNonContemp, transmissionOrder, 40, 'identificationMethod', method);
effectsContemp = model.transmission(1, channelContemp, transmissionOrder, 40, 'identificationMethod', method);
% adjusting for shock size
effectsNonContemp = effectsNonContemp * 0.25;
effectsContemp = effectsContemp * 0.25;
% The effects should perfectly decompose the total effects
max(vec(irfs - effectsContemp - effectsNonContemp))
% Plotting the decomposition
channelNames = ["Contemporaneous", "Non-Contemporaneous"];
cellChannelEffects = {effectsContemp, effectsNonContemp};
% for ffr
fig = plotDecomposition(2, irfs, cellChannelEffects, channelNames);
set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'rr-ffr.png', 'Resolution', 300);
% for inflation
fig = plotDecomposition(4, irfs, cellChannelEffects, channelNames);
set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'rr-infl.png', 'Resolution', 300);

% Minor differences between the decompositions here and the ones in the paper 
% are due to how we obtain the orthogonal IRFs. In the paper we estimate 
% orthogonal IRFs using a VAR excluding the internal instrument. Here we 
% include the internal instrument. At this point we have no preference for one 
% method over the other. The differences are minor anyways. 
