function evaluation_info=evaluateLMH(data, param)

dbdata = data.db_data;
tstdata = data.test_data;
trndata = data.train_data;
groundtruth = data.groundtruth;

tic;
param = trainLMH(double(trndata'),param);
trainT=toc;

%%% Compression Time
[B_db, U] = compressLMH(double(dbdata'), param);
tic;
[B_tst, U] = compressLMH(double(tstdata'), param);
compressT=toc;

evaluation_info = performance(B_tst, B_db, groundtruth, param);
evaluation_info.trainT = trainT;
evaluation_info.compressT = compressT;