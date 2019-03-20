% query 
%read a picture 
% return the most nearest video's label
addpath(genpath('./tool'));
% Parameters for LMgist:
clear
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
picture = imread('D:\BUAA\img-retrieval-master\source\A.jpg');
[picGist, ~] = LMgist(picture,'D:\BUAA\img-retrieval-master\source\', param);%1*512
picGist = normr(picGist);
%clear param
%param.nbits = nbits;
%param.m = 4;

dist = [];
for( label =1:9)
    videoName = strcat('videoModel', num2str(label), '.mat');
    clear m
    m = load (videoName);
    w = full(m.videoModel.SVs)'*m.videoModel.sv_coef;%超平面法向量1*512
    %q = [w ; -m.videoModel.rho];
    %[Bq, ~] = compressMH(double(q'), )
    dist = [dist; picGist*w - m.videoModel.rho]; %求图片与每个视频超平面的距离。
end
save('pvdist.mat',    'dist');
fprintf('end\n');
