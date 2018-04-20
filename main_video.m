%% Workspace Initialization
clc; clf; close all; clear all;

% read frames from saved mat
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

figure;
im=cell(1,FramesPerTrigger-3+1);
for ii=3:FramesPerTrigger
    % Background Image Difference
    ROI_1=imDiff(frames(:, :, :, ii-2), frames(:, :, :, ii-1), frames(:, :, :, ii), threshold);
    ROI_1=im2bw(ROI_1, graythresh(ROI_1));
    
    % Background Substraction
    im_in=frames(:, :, :, ii);
    [im_out, bgd, Threshold]=bgdSub_Intensity(im_in, bgd, learning_rate, Threshold);
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
    [ROI_1, ROI_2, ROI_3]=Region_based_Combination(ROI_1, ROI_2, ROI_3);
    
    
    % prepare for next round
    % im_ROI=
    % im_bgd=
    
    % figure
    ROI_1=mark(im_in, ROI_1);
    ROI_2=mark(im_in,ROI_2);
    ROI_3=mark(im_in,ROI_3);
    subplot(1,3,1); imshow(ROI_1);
    subplot(1,3,2); imshow(ROI_2);
    subplot(1,3,3); imshow(ROI_3);
    drawnow
    
end
%%

