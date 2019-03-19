function [videoModel] = trainHyperplane(expData)

addpath(genpath('./tool'));

nbits = 16;%  ??? ��ϣ��ĳ���
maxIter = 50;%����������
r = 5;%����С��5������Ч
pk = 1; %ÿ��ѡ��һ��
%% training data for svm
    [dim ,ltrainNum] = size(expData.ltrainData);%δ��ע����������ֵ��ά�ȡ�����
    Xr = [expData.ltrainData' ones(ltrainNum,1)];% data : dim*num -> num*dim��֮����ƴ��һ�� num*1��1 ������Ϊʲô�أ�
    Yr = expData.ltrainLabels;% num*1

    X = expData.itrainData';      
    Y = expData.itrainLabels;

%% hashing for ASVM
    clear param
    param.nbits = nbits;
    param.m = 4;
           
    trainNum = expData.trainNum;
    param = trainLMH(double(normr([expData.trainData' ones(trainNum,1)])),param);   %normr�ǰ��й�һ������ѵ������ΪʲôҪ��1����ƴ���أ�      
    [Br, ~] = compressLMH(Xr, param, 0);%�õ�ѵ�����Ĺ�ϣ��
           
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
    %��ƽ��w^T x + b = 0�ķ�����w
    alpha_SVs = videoModel.sv_coef;%ʵ����a_i*y_i��Ӧ,��Ӧw?
    w = sum(diag(alpha_SVs)*xsup)';%�������鹫ʽ(6.9)
   
    
%% iter
    for iter = 1:maxIter
        q = [w; b];%% ������Ƶ513*1
              
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
            sub_dist = abs(q'*Xr(hidx,:)');%exhaustive ����candidate
            [~, dx] = sort(sub_dist, 'ascend');   
            idx = hidx(dx(1:pk));               
        end
        Br(idx,:) = [];     
%����ѡ�������label������ѵ�����ݼ�����δ���������ɾ��
        X = [X; Xr(idx,1:dim)];
        Y = [Y; Yr(idx,:)];

        Xr(idx,:) = [];
        Yr(idx,:) = [];

%[xsup,w,b,pos,t,alp]=svmclass(X,Y,kernel"poly");
        videoModel = svmtrain(Y, X,'-t 1');
    	[label, accuracy, ~] = svmpredict(Y, X, videoModel);
        xsup = full(videoModel.SVs);%SVs
        b = -videoModel.rho;%b
        %��ƽ��w^T x + b = 0�ķ�����w
        alpha_SVs = videoModel.sv_coef;%ʵ����a_i*y_i��Ӧ,��Ӧdemo_asvm w?
        w = sum(diag(alpha_SVs)*xsup)';%�������鹫ʽ(6.9)
    end  
end