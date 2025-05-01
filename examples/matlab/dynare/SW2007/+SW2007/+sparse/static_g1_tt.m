function [T_order, T] = static_g1_tt(y, x, params, T_order, T)
if T_order >= 1
    return
end
[T_order, T] = SW2007.sparse.static_resid_tt(y, x, params, T_order, T);
T_order = 1;
if size(T, 1) < 19
    T = [T; NaN(19 - size(T, 1), 1)];
end
T(18) = 1-(T(13)/(1+T(13))+1/(1+T(13)));
T(19) = 1/(1-T(13))-T(13)/(1-T(13));
end
