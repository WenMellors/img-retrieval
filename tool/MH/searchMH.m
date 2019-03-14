function ret = searchMH(q, Db, param)

[Bq, ~] = compressMH(double(q'), param, 1);
[Bdb, ~] = compressMH(double(Db'), param, 0);

% k = param.topk;
dist = hammingDist(Bq, Bdb);

% [~, idx] = sort(dist);
% ret = idx(1:k);
ret = find(dist <= param.r);


