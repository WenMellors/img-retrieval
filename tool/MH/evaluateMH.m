function evaluation_info=evaluateMH(data, param)

dbdata = data.db_data;
tstdata = data.test_data;
trndata = data.train_data;
groundtruth = data.groundtruth;

tic;
param = trainMH(double(trndata'),param);
trainT=toc;

%%% Compression Time
[B_db, U] = compressMH(double(dbdata'), param);
tic;
[B_tst, U] = compressMH(double(tstdata'), param);
compressT=toc;

evaluation_info = search(B_tst, B_db, param);
evaluation_info.trainT = trainT;
evaluation_info.compressT = compressT;