function ret = searchLMH(q, Db, param)

[Bq, ~] = compressLMH(double(q'), param, 1);
[Bdb, ~] = compressLMH(double(Db'), param, 0);

% k = param.topk;
dist = hammingDist(Bq, Bdb);
% [~, idx] = sort(dist);
% ret = idx(1:k);

ret = find(dist <= param.r);