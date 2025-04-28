function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = SW2007.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(40, 1);
    residual(1) = (y(52)) - (params(9)*y(31)+(1-params(9))*y(38));
    residual(2) = (y(30)) - (y(31)*T(3));
    residual(3) = (y(31)) - (y(38)+y(37)-y(32));
    residual(4) = (y(32)) - (y(30)+y(19));
    residual(5) = (y(35)) - (y(55)+T(15)*(y(33)*1/T(5)+y(4)+y(64)*T(14)));
    residual(6) = (y(33)) - (y(53)*1/T(7)-y(39)+y(61)*(T(11)-(1-params(12)))/T(11)+y(62)*(1-params(12))/T(11));
    residual(7) = (y(34)) - (y(53)+y(3)*T(6)/(1+T(6))+y(63)*1/(1+T(6))+(y(37)-y(65))*T(16)-y(39)*T(7));
    residual(8) = (y(36)) - (y(54)+y(34)*(1-params(39)-T(1)*T(12)*T(13))+y(35)*T(1)*T(12)*T(13)+y(30)*(T(11)-(1-params(12)))*T(13));
    residual(9) = (y(36)) - (params(17)*(y(52)+params(9)*y(32)+(1-params(9))*y(37)));
    residual(10) = (y(38)) - (y(37)*params(22)+y(34)*T(8)-y(3)*T(9));
    residual(11) = (y(59)) - (y(19)*(1-T(12))+y(35)*T(12)+y(55)*T(5)*T(12));
    residual(12) = (y(40)) - (params(9)*y(42)+(1-params(9))*y(50)-y(52));
    residual(13) = (y(41)) - (T(3)*y(42));
    residual(14) = (y(42)) - (y(50)+y(48)-y(43));
    residual(15) = (y(43)) - (y(41)+y(20));
    residual(16) = (y(46)) - (y(55)+T(15)*(y(44)*1/T(5)+y(7)+y(69)*T(14)));
    residual(17) = (y(44)) - (y(71)-y(51)+y(53)*1/T(7)+y(66)*(T(11)-(1-params(12)))/T(11)+y(67)*(1-params(12))/T(11));
    residual(18) = (y(45)) - (y(53)+y(6)*T(6)/(1+T(6))+y(68)*1/(1+T(6))+(y(48)-y(70))*T(16)-(y(51)-y(71))*T(7));
    residual(19) = (y(47)) - (y(54)+y(45)*(1-params(39)-T(1)*T(12)*T(13))+y(46)*T(1)*T(12)*T(13)+y(41)*(T(11)-(1-params(12)))*T(13));
    residual(20) = (y(47)) - (params(17)*(y(52)+params(9)*y(43)+(1-params(9))*y(48)));
    residual(21) = (y(49)) - (y(57)+T(17)*(params(20)*y(9)+y(71)*T(14)+y(40)*T(18)));
    residual(22) = (y(50)) - (y(58)+y(10)*T(15)+y(72)*T(14)/(1+T(14))+y(9)*params(18)/(1+T(14))-y(49)*(1+params(18)*T(14))/(1+T(14))+y(71)*T(14)/(1+T(14))+(params(22)*y(48)+y(45)*T(8)-y(6)*T(9)-y(50))*T(19));
    residual(23) = (y(51)) - (y(49)*params(25)*(1-params(28))+(1-params(28))*params(27)*(y(47)-y(36))+params(26)*(y(47)-y(36)-y(8)+y(5))+params(28)*y(11)+y(56));
    residual(24) = (y(52)) - (params(29)*y(12)+x(it_, 1));
    residual(25) = (y(53)) - (params(31)*y(13)+x(it_, 2));
    residual(26) = (y(54)) - (params(32)*y(14)+x(it_, 3)+x(it_, 1)*params(2));
    residual(27) = (y(55)) - (params(34)*y(15)+x(it_, 4));
    residual(28) = (y(56)) - (params(35)*y(16)+x(it_, 5));
    residual(29) = (y(57)) - (params(36)*y(17)+y(29)-params(8)*y(2));
    residual(30) = (y(29)) - (x(it_, 6));
    residual(31) = (y(58)) - (params(37)*y(18)+y(28)-params(7)*y(1));
    residual(32) = (y(28)) - (x(it_, 7));
    residual(33) = (y(60)) - (y(20)*(1-T(12))+y(46)*T(12)+y(55)*params(11)*T(4)*T(12));
    residual(34) = (y(24)) - (params(38)+y(47)-y(8));
    residual(35) = (y(25)) - (params(38)+y(45)-y(6));
    residual(36) = (y(26)) - (params(38)+y(46)-y(7));
    residual(37) = (y(27)) - (params(38)+y(50)-y(10));
    residual(38) = (y(23)) - (params(5)+y(49));
    residual(39) = (y(22)) - (y(51)+100*((1+params(5)/100)/T(10)-1));
    residual(40) = (y(21)) - (y(48)+params(4));

end
