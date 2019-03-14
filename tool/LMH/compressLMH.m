function [B, U] = compressLMH(X, param, iq)
%
[Nsamples Ndim] = size(X);   %Nsample 行数  X 的每一行代表一个sample，
nbits = param.nbits;      %nbits 是hash函数的个数
m = param.m;
U = ones(Nsamples,nbits);
for l = 1:m
    U = U.*(X*param.w{l});            %LSHparam.w每一列是一个hash函数（Ndim 维的向量）
end

if(iq == 1)
    U = (U<0);    %把大于一的带到1，小于一的为0   每一行是一个sample的码
else
    U = (U>0);    %把大于一的带到1，小于一的为0   每一行是一个sample的码
end
B = compactbit(U);         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb = compactbit(b)
%
% b = bits array
% cb = compacted string of bits (using words of 'word' bits)

[nSamples nbits] = size(b);
nwords = ceil(nbits/8);
cb = zeros([nSamples nwords], 'uint8');

for j = 1:nbits
    w = ceil(j/8);
    cb(:,w) = bitset(cb(:,w), mod(j-1,8)+1, b(:,j));
end  


