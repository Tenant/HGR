% getRGMask2���Խű�
clear;clc; close
load EVK_farVision
num=numel(frames);

figure;
for ii=1:num
    frame_t=frames{ii};
    frame_t.ampData(frame_t.ampData<0)=0;
    img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
    img=histeq(img, 256); 
    L=getRGmask2(img, 0.08);
    
    imshow(img);
    Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
    hold on
    himage = imshow(Lrgb);%��ԭͼ����ʾα��ɫͼ��
    set(himage, 'AlphaData', 0.3);
    hold off
    drawnow
end