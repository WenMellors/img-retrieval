% this function will initially get the trainning sample of each video.
% no inputs no outputs. the training sampel will be saved as train_data.mat
% there are nine videos, each three videos are made by the same up.
% they are °¢¸£Thomas, Jared and Papi.
videoNum = 9;

for i = 1 : videoNum
    videoName = strcat(num2str(i), '.mp4');
    frames = getVideoFrame(videoName); % get the frames gist, then add lables
    frameLable = ones(size(frames, 1), 1) * i; % n * 1
    if (i == 1) 
        data = frames;
        dataLabel = frameLable;
    else
        data = cat(1, data, frames);
        dataLabel = cat(1, dataLabel, frameLable);
    end
    fprintf('%d finish video extract \n', i);
end

save data.mat data dataLabel
