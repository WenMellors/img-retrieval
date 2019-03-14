function expData = constructData(itrain,label)
%data:3498*512
%dataLabel:3498*1
load 'data.mat';
rand('state',sum(100*clock));

labelNum = 9;
data = data';
[dim,dataNum] = size(data);
trainNum = length(dataLabel);
expData.labelNum = labelNum;
%% data normalization

meanDataVec = nanmean(data,2);%512*1
data = data - repmat(meanDataVec,1,dataNum);
data = normc(data)*dim;

%% Data randomization
perm = randperm(trainNum);
trainIdx = perm([1:trainNum]);
trainData = data(:,trainIdx);
trainLabels = dataLabel(trainIdx);

%% data for ASVM
inumClass = itrain;
%%%% 因为目前一共9个视频，共三组，每组3个
inegIdx = [];
lnegIdx = [];
for i = 1:labelNum
    if(i ~= label)
        if(label <= 3)
            if ( i> 3)
                negIdx = find(dataLabel == i);
                inegIdx = [inegIdx; negIdx(1)];
                lnegIdx = [lnegIdx; negIdx(2:end)];
            end
        end
        if(label > 3 && label <=6)
            if ( i<= 3 || i >6)
                negIdx = find(dataLabel ~= i);
                inegIdx = [inegIdx; negIdx(1)];
                lnegIdx = [lnegIdx; negIdx(2:end)];
            end
        end
        if(label <= 9 && label >6)
            if ( i <=6)
                negIdx = find(dataLabel ~= i);
                inegIdx = [inegIdx; negIdx(1)];
                lnegIdx = [lnegIdx; negIdx(2:end)];
            end
        end
             
    else
       posIdx = find(dataLabel == label);
       iposIdx = posIdx(1:inumClass);
       lposIdx = posIdx(inumClass+1:end);
    end
end

expData.itrainData = trainData(:, [iposIdx ; inegIdx]);
expData.itrainLabels = [ones(inumClass,1) ; -ones(inumClass,1)];

expData.ltrainData = trainData(:,[lposIdx; lnegIdx]);
expData.ltrainLabels = [ones(length(lposIdx),1) ; - ones(length(lnegIdx),1)];
expData.trainTrueLabels =  trainLabels([lposIdx;lnegIdx],:);

%% data for hash 
trainNum = 1000;
expData.trainNum = trainNum;
expData.trainData = trainData(:,1:trainNum);