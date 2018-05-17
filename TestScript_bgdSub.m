%% bgdSub≤‚ ‘Ω≈±æ
clc;clear;
load wave_hand_data_1.mat
frames=body_still;
bgd=frames(:,:,:,1);
bgd=medfilt_RGB(bgd, [4,4]);
width=size(frames,1);
height=size(frames, 2);
Threshold=zeros(width, height)+10; % recommended value: 10
% learning rate tune table:
% 0.75: 
learning_rate=0.70; % recommended value: 0.7
figure
for ii=2:35
    im_in=frames(:, :, :, ii);
    im_in=medfilt_RGB(im_in,[4,4]);
    [im_out, bgd, Threshold]=bgdSub(im_in, bgd, learning_rate, Threshold);
    ROI_2=im2bw(im_out, graythresh(im_out));
    subplot(2,1,1);
    imshow(bgd);
    subplot(2,1,2);
    ROI_2=imdilate(ROI_2,strel('disk',1));
    ROI_2 = imerode(ROI_2,strel('disk',1));  
    imshow(ROI_2);
    drawnow
end