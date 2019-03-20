function [ frames ] = getVideoFrame( fileName )
% extract frames from the video
% filename -- which video to extract
% frames -- the gist frames getting from video
% Parameters for LMgist:
clear param 
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
% prepare for extracting
video = VideoReader(fileName);
extractRate = 1; % how many frames will be extract from 1 second.
frames = zeros(floor((floor(video.Duration)-1)/3)*extractRate, 512); % to store n*512 Gist matrix
framesId = 1;

for i = 1 : floor((floor(video.Duration)-1)/3)
    for j = 1 : extractRate
        frameId = video.FrameRate * (i - 1) * 3 + randi(floor(video.FrameRate));
        frame = read(video, frameId); % have no idea to do with readFrame
        [frameGist, ~] = LMgist(frame, '', param);
        fprintf('%d frame finish gist \n', i);
        frames(framesId, :) = frameGist;
        framesId = framesId + 1;
    end    
end

end

