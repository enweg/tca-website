function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(72)=params(29)*y(32)+x(1);
  y(73)=params(31)*y(33)+x(2);
  y(74)=params(32)*y(34)+x(3)+x(1)*params(2);
  y(75)=params(34)*y(35)+x(4);
  y(76)=params(35)*y(36)+x(5);
  y(49)=x(6);
  y(48)=x(7);
  y(77)=params(36)*y(37)+y(49)-params(8)*y(9);
  y(78)=params(37)*y(38)+y(48)-params(7)*y(8);
end
