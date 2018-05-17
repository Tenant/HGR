clc; clear;
folder = fullfile('./');
movieFullFileName = fullfile(folder, 'VID_20180416_175927.mp4');
frames = VideoReader(movieFullFileName);

im_precious=read(frames,2);
im_next_to_precious=read(frames,1);
figure
for ii=3:35
    im=read(frames, ii);
    mask=imDiff(im_next_to_precious, im_precious,im, 8);
    img=mark(im,mask);
    imshow(img);
    drawnow;
    im_next_to_precious=im_precious;
    im_precious=im;
end