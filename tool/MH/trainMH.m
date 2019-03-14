function param = trainMH(X, param)
%
m=param.m;
[~, Ndim] = size(X);
nbits = param.nbits;
for l=1:m
    W = randn(Ndim, nbits);
    param.w{l} = W;
end
