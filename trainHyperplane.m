function [videoModel] = trainHyperplane(expData)

addpath(genpath('./tool'));

nbits = 16;%  ??? 哈希码的长度
maxIter = 50;%最大迭代次数
r = 5;%距离小于5才算有效
pk = 1; %每次选出一个
%% training data for svm
    [dim ,ltrainNum] = size(expData.ltrainData);%未标注的数据特征值的维度、个数
    Xr = [expData.ltrainData' ones(ltrainNum,1)];% data : dim*num -> num*dim，之后再拼接一个 num*1的1 。这是为什么呢？
    Yr = expData.ltrainLabels;% num*1

    X = expData.itrainData';      
    Y = expData.itrainLabels;

%% hashing for ASVM
    clear param
    param.nbits = nbits;
    param.m = 4;
           
    trainNum = expData.trainNum;
    param = trainLMH(double(normr([expData.trainData' ones(trainNum,1)])),param);   %normr是按行归一化，那训练数据为什么要和1向量拼接呢？      
    [Br, ~] = compressLMH(Xr, param, 0);%得到训练集的哈希码
           
%   Learning and Learning Parameters
%             c = inf;
%             epsilon = 0;%.000001;
%             kerneloption= 1;
%             kernel='poly';
%             verbose=0;
%             [xsup,w,b,pos,t,alp]=svmclass(X,Y,c,epsilon,kernel,kerneloption,verbose);
%%
    videoModel = svmtrain(Y, X,'-t 1');
    [label, accuracy, ~] = svmpredict(Y, X, videoModel);
    xsup = full(videoModel.SVs);%SVs
    b = -videoModel.rho;%b
    %求平面w^T x + b = 0的法向量w
    alpha_SVs = videoModel.sv_coef;%实际是a_i*y_i对应,对应w?
    w = sum(diag(alpha_SVs)*xsup)';%即西瓜书公式(6.9)
   
    
%% iter
    for iter = 1:maxIter
        q = [w; b];%% 代表视频513*1
              
        [Bq, ~] = compressLMH(q', param, 1);
        dist = hammingDist(Bq, Br);
        hidx = find(dist <= r);
        len = length(hidx);% dist <= r 
      
        hidx = union(hidx, find((nbits-dist) <= r));%????
        len = length(hidx);
        if(len == 0)  
            idx = randsample(length(Yr), pk); 
            fprintf('zero hit\n');
        else     
            sub_dist = abs(q'*Xr(hidx,:)');%exhaustive 计算candidate
            [~, dx] = sort(sub_dist, 'ascend');   
            idx = hidx(dx(1:pk));               
        end
        Br(idx,:) = [];     
%将新选择的样本label并降入训练数据集，从未标记数据中删除
        X = [X; Xr(idx,1:dim)];
        Y = [Y; Yr(idx,:)];

        Xr(idx,:) = [];
        Yr(idx,:) = [];

%[xsup,w,b,pos,t,alp]=svmclass(X,Y,kernel"poly");
        videoModel = svmtrain(Y, X,'-t 1');
    	[label, accuracy, ~] = svmpredict(Y, X, videoModel);
        xsup = full(videoModel.SVs);%SVs
        b = -videoModel.rho;%b
        %求平面w^T x + b = 0的法向量w
        alpha_SVs = videoModel.sv_coef;%实际是a_i*y_i对应,对应demo_asvm w?
        w = sum(diag(alpha_SVs)*xsup)';%即西瓜书公式(6.9)
    end  
end