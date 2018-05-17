% 手工标注手势区域蒙版

load EVK_nearVision
num=numel(frames);


% mask=cell(1,num);
for ii=154:num
    frame_t=frames{ii};
    frame_t.ampData(frame_t.ampData<0)=0;
    img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
    img=histeq(img, 256);
    img=rot90(img, 1);
%     mask0=getRGmask(img, 0.08);
%     mask0=imfill(mask0, 'holes');
    imshow(img);
%     pause(0.5)
%     mask{ii}=mask0;
end