clear;
labelNum = 9;
itrain = 6;

for label = 1 : labelNum
    fprintf('%d\n',label);
    expData = constructDataset(itrain,label);
    videoModel = trainHyperplane(expData);
    filename   =   strcat('videoModel',   num2str(label),   '.mat');
    save(filename,    'videoModel');
end
fprintf('finished\n');