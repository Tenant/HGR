%% Workspace Initialization
clc; clf; close all; clear all;

%% Device Configuration
%{
FramesPerTrigger=20;
vid = videoinput('winvideo', 1, 'YUY2_320x240');
vid.ReturnedColorspace = 'rgb';
vid.FramesPerTrigger = FramesPerTrigger;
vid.TriggerFrameDelay = 5;
src.FrameRate ='30';
start(vid);
[frames, timeStamp]=getdata(vid);
%}

%% read frames from saved mat
load wave_hand_data
frames=wave_to_front_1;
FramesPerTrigger=35;
%% Region Extraction
% Background Image Difference
threshold=8; % defalut value= 8

% Background Substraction
bgd=frames(:, :, :, 1);
width=size(bgd,1);
height=size(bgd, 2);
Threshold=zeros(width, height)+10; % recommended value: 10
learning_rate=0.7; % recommended value: 0.7

% skin-color Probability Map - Offline Training
load SPM_off

% Skin-color Probability Map - Online Training
skinPixels = 0;
nonskinPixels = 0;
numTable(2, 1:32, 1:32, 1:32) = 0;
% im_ROI=
% im_bgd=

% skin-color classifier
threshold_SPM=0.8;
SPM=SPM_off;

for ii=3:FramesPerTrigger
    % Background Image Difference
    ROI_1=imDiff(frames(:, :, :, ii-2), frames(:, :, :, ii-1), frames(:, :, :, ii), threshold);
    ROI_1=im2bw(ROI_1, graythresh(ROI_1));
    
    % Background Substraction
    im_in=frames(:, :, :, ii);
    [im_out, bgd, Threshold]=bgdSub(im_in, bgd, learning_rate, Threshold);
    ROI_2=im2bw(im_out, graythresh(im_out));
    
    % skin-color Probability Map - Online Training
    % [SPM_on, numTable, skinPixels, nonskinPixels]=SPM_train_online(im_ROI, im_bgd, numTable, skinPixels, nonskinPixels);
    
    % Skin color classifier
    % lr=ii/FramesPerTrigger;
    % SPM=(1-lr)*SPM_off+lr*SPM_on;
    ROI_3=SPM_test_main(frames(:, :, :, ii), SPM, threshold_SPM);
    % P_skin=(1-lr)*P_skin_off+lr*P_skin_on;
    % P_nonskin=(1-lr)*P_nonskin_off+lr*P_nonskin_on;
    
    % Combination of Information
    
    
    % prepare for next round
    % im_ROI=
    % im_bgd=
    
    % figure
    %%{
    figure;
    subplot(1,3,1); imshow(ROI_1);
    subplot(1,3,2); imshow(ROI_2);
    subplot(1,3,3); imshow(ROI_3);
    %}
    
    
    
end

