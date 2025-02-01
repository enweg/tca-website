clear;
clc;

addpath("/Applications/Dynare/5.5-arm64/matlab");
addpath("../../../../tca-matlab-toolbox/");
addpath("../../../../tca-matlab-toolbox/dynare");
cd Smets_Wouters_2007;
dynare Smets_Wouters_2007_45;
cd ..;
clc;

obsVar = ["dy", "dc", "dinve", "piexp", "pinfobs", "robs", "dw"];
obsVar = getObsVarIds(M_, options_, oo_, obsVar);
[p, q] = determineVarmaOrder(M_, options_, oo_, 10, obsVar);
[A0, Phis, Psis, vars] = getVarmaCoeffs(M_, options_, oo_, p, q, obsVar);

order = defineOrder({"robs", "piexp", "dw", "dc", "dinve", "dy", "pinfobs"}, vars);

% need to adjust the above function so it directly has this form
% also note that returned coeffs are structural, we work with reduced form
Phi0 = inv(A0);
Sigma = Phi0 * Phi0';
AsCellArray = cell(1, size(Phis, 3));
for ii=1:size(Phis, 3)
  AsCellArray{ii} = Phi0 * Phis(:, :, ii);
end
PsisCellArray = cell(1, size(Psis, 3));
for ii=1:size(Psis, 3)
  PsisCellArray{ii} = Phi0 * Psis(:, :, ii) * A0;
end


[B, Omega] = makeSystemsForm(Phi0, AsCellArray, PsisCellArray, Sigma, order, 1);

shocks = dynareCellArray2Vec(M_.exo_names);
ix_em = find(shocks == "em");
shock_size = sqrt(M_.Sigma_e(ix_em, ix_em));

condTrue = Q('T');
irfs = transmission(ix_em, B, Omega, condTrue, "BOmega") * shock_size;
