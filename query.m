% query 
%read a picture 
% return the most nearest video's label
%addpath(genpath('./tool'));
% Parameters for LMgist:
clear
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
picture = imread('.\source\A.jpg');
[picGist, ~] = LMgist(picture,'D:\BUAA\img-retrieval-master\source\', param);%1*512
meanDataVec = nanmean(picGist,2);%512*1
picGist = picGist - repmat(meanDataVec,1,1);
picGist = normr(picGist)*512;
clear param
param.nbits = 32;
param.m = 4;
param = trainMH([picGist' ; 1]', param);
[Bp, ~] = compressMH(double([picGist' ; 1]') , param, 0);
dist = [];
for( label =1:9)
    videoName = strcat('videoModel', num2str(label), '.mat');
    clear m
    m = load (videoName);
    w = full(m.videoModel.SVs)'*m.videoModel.sv_coef;%超平面法向量1*512
    q = [w ; -m.videoModel.rho];
    [Bq, ~] = compressMH(q', param, 1);
    dist = [dist; hammingDist(Bq, Bp)]; %求图片与每个视频超平面的距离。
end
save('pvdist.mat',    'dist');
fprintf('end\n');
