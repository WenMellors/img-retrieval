load heart_scale;
data = heart_scale_inst;
label = heart_scale_label;
% ��������ģ��
model = svmtrain(label, data, '-s 0 -t 2 -c 1.2 -g 2.8');

% ���ý�����ģ�Ϳ�����ѵ�������ϵķ���Ч��
[PredictLabel,accuracy] = svmpredict(label,data,model);