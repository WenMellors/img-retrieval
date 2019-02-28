load heart_scale;
data = heart_scale_inst;
label = heart_scale_label;
% 建立分类模型
model = svmtrain(label, data, '-s 0 -t 2 -c 1.2 -g 2.8');

% 利用建立的模型看其在训练集合上的分类效果
[PredictLabel,accuracy] = svmpredict(label,data,model);