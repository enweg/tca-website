clear; 
clc; 

addpath("~/Documents/repos/tca-matlab-toolbox/");
addpath("~/Documents/repos/tca-matlab-toolbox/plotting");
addpath("~/Documents/repos/tca-matlab-toolbox/models");

data = readtable("./data.csv");

% 1. Defining the model 
model = LP(data, 'newsy', 4, 0:20, 'includeConstant', true);
model.fit();

% 2. Obtaining total effects
method = Recursive()
irfObj = model.IRF(20, 'identificationMethod', method);
irfs = irfObj.getIrfArray();

model.getVariableNames()
plot(0:20, vec(irfs(2, 1, :)))  % government defense spending
plot(0:20, vec(irfs(3, 1, :)))  % total government spending
plot(0:20, vec(irfs(4, 1, :)))  % output

% 3. Defining the transmission  matrix
transmissionOrder = {'newsy', 'gdef', 'g', 'y'};
transmissionOrder = model.getVariableNames();  % because order is already correct

% 4. Defining transmission channels
anticipationChannel = model.notThrough('gdef', 0:20, transmissionOrder);
implementationChannel = ~anticipationChannel;

% 5. Computing transmission effects
anticipationEffects = model.transmission(1, anticipationChannel, transmissionOrder, 20, 'identificationMethod', method);
implementationEffects = model.transmission(1, implementationChannel, transmissionOrder, 20, 'identificationMethod', method);

% 6. Visualising
channelNames = ["Anticipation Channel", "Implementation Channel"];
cellChannelEffects = {anticipationEffects, implementationEffects};
% output
fig = plotDecomposition(4, irfs(:, 1, :), cellChannelEffects, channelNames)
set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'output.png', 'Resolution', 300);
% Total government spending
fig = plotDecomposition(3, irfs(:, 1, :), cellChannelEffects, channelNames)
set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'gov.png', 'Resolution', 300);
% Government defense spending
fig = plotDecomposition(2, irfs(:, 1, :), cellChannelEffects, channelNames)
set(fig, 'Units', 'inches', 'Position', [1 1 10 5]);
exportgraphics(fig, 'gdef.png', 'Resolution', 300);

