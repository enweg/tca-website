function [y, T, residual, g1] = static_8(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(1, 1);
  residual(1)=(y(38))-(y(38)*params(37)+y(8)-y(8)*params(7));
if nargout > 3
    g1_v = NaN(1, 1);
g1_v(1)=1-params(37);
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 1, 1);
end
end
