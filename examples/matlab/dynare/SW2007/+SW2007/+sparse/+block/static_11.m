function [y, T] = static_11(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(1)=y(28)+params(4);
  y(2)=100*((1+params(5)/100)/T(1)-1)+y(31);
  y(3)=params(5)+y(29);
end
