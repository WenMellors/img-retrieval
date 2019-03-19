clear;
load('dataPCA.mat')

mData = mean(data);
k = 128; %Ҫ��ά��256
[pcaData, ~] = fastPCA(data, k, mData);
lowvec = min(pcaData);
upvec = max(pcaData);
data = scaling(pcaData, lowvec, upvec);
save dataPCA.mat data