function residual = static_resid(T, y, x, params, T_flag)
% function residual = static_resid(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = SW2007.static_resid_tt(T, y, x, params);
end
residual = zeros(40, 1);
    residual(1) = (y(32)) - (params(9)*y(11)+(1-params(9))*y(18));
    residual(2) = (y(10)) - (y(11)*T(8));
    residual(3) = (y(11)) - (y(18)+y(17)-y(12));
    residual(4) = (y(12)) - (y(10)+y(39));
    residual(5) = (y(15)) - (y(35)+T(10)*(y(13)*1/T(12)+y(15)+y(15)*T(9)));
    residual(6) = (y(13)) - (y(33)*1/T(14)-y(19)+y(11)*(T(4)-(1-params(12)))/T(4)+y(13)*(1-params(12))/T(4));
    residual(7) = (y(14)) - (y(33)+y(14)*T(13)/(1+T(13))+y(14)*1/(1+T(13))-T(14)*y(19));
    residual(8) = (y(16)) - (y(34)+(1-params(39)-T(7))*y(14)+T(7)*y(15)+(T(4)-(1-params(12)))*T(6)*y(10));
    residual(9) = (y(16)) - (params(17)*(y(32)+params(9)*y(12)+(1-params(9))*y(17)));
    residual(10) = (y(18)) - (y(17)*params(22)+y(14)*1/(1-T(13))-y(14)*T(13)/(1-T(13)));
    residual(11) = (y(39)) - (y(39)*(1-T(5))+T(5)*y(15)+y(35)*T(5)*T(12));
    residual(12) = (y(20)) - (params(9)*y(22)+(1-params(9))*y(30)-y(32));
    residual(13) = (y(21)) - (T(8)*y(22));
    residual(14) = (y(22)) - (y(30)+y(28)-y(23));
    residual(15) = (y(23)) - (y(21)+y(40));
    residual(16) = (y(26)) - (y(35)+T(10)*(1/T(12)*y(24)+y(26)+T(9)*y(26)));
    residual(17) = (y(24)) - (y(33)*1/T(14)+y(29)-y(31)+(T(4)-(1-params(12)))/T(4)*y(22)+(1-params(12))/T(4)*y(24));
    residual(18) = (y(25)) - (y(33)+T(13)/(1+T(13))*y(25)+1/(1+T(13))*y(25)-T(14)*(y(31)-y(29)));
    residual(19) = (y(27)) - (y(34)+(1-params(39)-T(7))*y(25)+T(7)*y(26)+(T(4)-(1-params(12)))*T(6)*y(21));
    residual(20) = (y(27)) - (params(17)*(y(32)+params(9)*y(23)+(1-params(9))*y(28)));
    residual(21) = (y(29)) - (y(37)+1/(1+T(9)*params(20))*(y(29)*params(20)+T(9)*y(29)+y(20)*T(15)));
    residual(22) = (y(30)) - (y(38)+T(10)*y(30)+y(30)*T(16)+y(29)*params(18)/(1+T(9))-y(29)*(1+T(9)*params(18))/(1+T(9))+y(29)*T(16)+(params(22)*y(28)+1/(1-T(13))*y(25)-T(13)/(1-T(13))*y(25)-y(30))*T(17));
    residual(23) = (y(31)) - (y(29)*params(25)*(1-params(28))+(1-params(28))*params(27)*(y(27)-y(16))+params(26)*(y(16)+y(27)-y(16)-y(27))+y(31)*params(28)+y(36));
    residual(24) = (y(32)) - (y(32)*params(29)+x(1));
    residual(25) = (y(33)) - (y(33)*params(31)+x(2));
    residual(26) = (y(34)) - (y(34)*params(32)+x(3)+x(1)*params(2));
    residual(27) = (y(35)) - (y(35)*params(34)+x(4));
    residual(28) = (y(36)) - (y(36)*params(35)+x(5));
    residual(29) = (y(37)) - (y(37)*params(36)+y(9)-y(9)*params(8));
    residual(30) = (y(9)) - (x(6));
    residual(31) = (y(38)) - (y(38)*params(37)+y(8)-y(8)*params(7));
    residual(32) = (y(8)) - (x(7));
    residual(33) = (y(40)) - ((1-T(5))*y(40)+T(5)*y(26)+y(35)*params(11)*T(5)*T(11));
    residual(34) = (y(4)) - (params(38));
    residual(35) = (y(5)) - (params(38));
    residual(36) = (y(6)) - (params(38));
    residual(37) = (y(7)) - (params(38));
    residual(38) = (y(3)) - (params(5)+y(29));
    residual(39) = (y(2)) - (100*((1+params(5)/100)/T(3)-1)+y(31));
    residual(40) = (y(1)) - (y(28)+params(4));

end
