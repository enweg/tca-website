function [T_order, T] = static_resid_tt(y, x, params, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 17
    T = [T; NaN(17 - size(T, 1), 1)];
end
T(1) = 1+params(38)/100;
T(2) = 1/(1+params(6)/100);
T(3) = T(2)*T(1)^(-params(13));
T(4) = T(2)^(-1)*T(1)^params(13);
T(5) = 1-(1-params(12))/T(1);
T(6) = params(17)*((1-params(9))/params(9)*(T(4)-(1-params(12)))/(params(9)^params(9)*(1-params(9))^(1-params(9))/(params(17)*(T(4)-(1-params(12)))^params(9)))^(1/(1-params(9))))^(params(9)-1);
T(7) = T(1)*T(5)*T(6);
T(8) = 1/(params(10)/(1-params(10)));
T(9) = T(1)*T(3);
T(10) = 1/(1+T(9));
T(11) = T(1)^2;
T(12) = params(11)*T(11);
T(13) = params(14)/T(1);
T(14) = (1-T(13))/(params(13)*(1+T(13)));
T(15) = (1-params(21))*(1-T(9)*params(21))/params(21)/(1+(params(17)-1)*params(3));
T(16) = T(9)/(1+T(9));
T(17) = 1/(1+(params(23)-1)*params(1))*(1-params(19))*(1-T(9)*params(19))/((1+T(9))*params(19));
end
