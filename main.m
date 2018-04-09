%% Workspace Initialization
clc; clf; close all; clear all;
FramesPerTrigger=20;

%% Device Configuration
vid = videoinput('winvideo', 1, 'YUY2_320x240');
vid.ReturnedColorspace = 'rgb';
vid.FramesPerTrigger = FramesPerTrigger;
vid.TriggerFrameDelay = 5;
src.FrameRate ='30';
start(vid);
[frames, timeStamp]=getdata(vid);

%% Background Image Difference
%{
threshold=8; % defalut value= 8

for ii=3:FramesPerTrigger
    ROI=imDiff(frames(:, :, :, ii-2), frames(:, :, :, ii-1), frames(:, :, :, ii), threshold);
    ROI=im2bw(ROI, graythresh(ROI));
    figure(); imshow(ROI);
end
%}

%% Background Substraction
%%{
bgd=frames(:, :, :, 1);
width=size(bgd,1);
height=size(bgd, 2);
Threshold=zeros(width, height)+10; % recommended value: 10
learning_rate=0.7; % recommended value: 0.7

for ii=2:FramesPerTrigger
    im_in=frames(:, :, :, ii);
    [im_out, bgd, Threshold]=bgdSub(im_in, bgd, learning_rate, Threshold);
    im_out=im2bw(im_out, graythresh(im_out));
    figure(); imshow(im_out);
end
%}
%% Skin-color Probability Map - Offline Training
% SPM_train()
% SPM_test_batch()

%% Skin-color Probability Map - Online Training
skinPixels = 0;
nonskinPixels = 0;
numTable(2, 1:32, 1:32, 1:32) = 0;

for ii=1:FramesPerTrigger
    [SPM_on, numTable, skinPixels, nonskinPixels]=SPM_train_online(im_ROI, im_bgd, numTable, skinPixels, nonskinPixels);
    
end

%% Skin color classifier

%% Calculation of Morphologyy Weights
