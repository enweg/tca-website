function [T_order, T] = dynamic_resid_tt(y, x, params, steady_state, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 19
    T = [T; NaN(19 - size(T, 1), 1)];
end
T(1) = 1+params(38)/100;
T(2) = 1/(1+params(6)/100);
T(3) = 1/(params(10)/(1-params(10)));
T(4) = T(1)^2;
T(5) = params(11)*T(4);
T(6) = params(14)/T(1);
T(7) = (1-T(6))/(params(13)*(1+T(6)));
T(8) = 1/(1-T(6));
T(9) = T(6)/(1-T(6));
T(10) = T(2)*T(1)^(-params(13));
T(11) = T(2)^(-1)*T(1)^params(13);
T(12) = 1-(1-params(12))/T(1);
T(13) = params(17)*((1-params(9))/params(9)*(T(11)-(1-params(12)))/(params(9)^params(9)*(1-params(9))^(1-params(9))/(params(17)*(T(11)-(1-params(12)))^params(9)))^(1/(1-params(9))))^(params(9)-1);
T(14) = T(1)*T(10);
T(15) = 1/(1+T(14));
T(16) = (params(13)-1)*T(13)*(1-params(9))*1/params(23)/params(9)*(T(11)-(1-params(12)))/(1-params(39)-T(1)*T(12)*T(13))/(params(13)*(1+T(6)));
T(17) = 1/(1+params(20)*T(14));
T(18) = (1-params(21))*(1-params(21)*T(14))/params(21)/(1+(params(17)-1)*params(3));
T(19) = 1/(1+(params(23)-1)*params(1))*(1-params(19))*(1-params(19)*T(14))/(params(19)*(1+T(14)));
end
