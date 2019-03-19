clear;
load('dataPCA.mat')

mData = mean(data);
k = 128; %Òª½µÎ¬µ½256
[pcaData, ~] = fastPCA(data, k, mData);
lowvec = min(pcaData);
upvec = max(pcaData);
data = scaling(pcaData, lowvec, upvec);
save dataPCA.mat data