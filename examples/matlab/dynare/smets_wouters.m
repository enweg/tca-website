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

% TODO: need to adjust the above function so it directly has this form
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

% TODO: Should write a helper function for this
shocks = dynareCellArray2Vec(M_.exo_names);
ix_em = find(shocks == "em");
shock_size = sqrt(M_.Sigma_e(ix_em, ix_em));

% Checking for correctness by comparing to dynare output
condTrue = Q('T');
irfs = transmission(ix_em, B, Omega, condTrue, "BOmega") * shock_size;

% creating the interest rate channel
interest_channel = notThrough([1,2,3,4,7], {0:1, 0:1, 0:1, 0:1, 0:1}, order);
interest_effect = transmission(ix_em, B, Omega, interest_channel, "BOmega", order) * shock_size;

% The expectations channel says through expectations in at least one period
% and not through the others. The OR cannot be straight forward handled so 
% we use the trick of negating the statement:
% ~(x1 | x2) = ~x1 & ~x2
expectations_channel = ~notThrough(4, 0:1, order) & notThrough([1,2,3,7], {0:1, 0:1, 0:1, 0:1}, order);
expectations_effect = transmission(ix_em, B, Omega, expectations_channel, "BOmega", order) * shock_size;
% alternatively
% this does not directly work because of other simplification
% make things that should not be interpreted NaN
% TODO: things should be NaN if they should not be interpreted.
stringCondition = "(y_{4,0} | y_{4,1})";
condition = makeConditionY(stringCondition, order);
expectations_channel = condition & notThrough([1,2,3,7], {0:1, 0:1, 0:1, 0:1}, order);
expectations_effect = transmission(ix_em, B, Omega, expectations_channel, "BOmega", order) * shock_size;

% Similar problem here. The channel is technically the effect through any of 
% the output or wage variables in at least one period. We cannot directly 
% implement this, but we can again use the negation trick from above
output_wage_channel = ~notThrough([1,2,3,7], {0:1, 0:1, 0:1, 0:1}, order);
output_wage_effect = transmission(ix_em, B, Omega, output_wage_channel, "BOmega", order) * shock_size;

