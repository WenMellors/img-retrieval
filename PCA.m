clear;
load('data.mat')

%mData = mean(data);
[COEFF SCORE latent]=princomp(data);
k = 128; %Ҫ��ά��256
data = SCORE(:, 1:k);
%[pcaData, ~] = fastPCA(data, k, mData);
%lowvec = min(pcaData);
%upvec = max(pcaData);
%data = scaling(pcaData, lowvec, upvec);
save dataPCA.mat data dataLabel