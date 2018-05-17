% SPM online training function≤‚ ‘Ω≈±æ

skinPixels = 0;
nonskinPixels = 0;
numTable(2, 1:32, 1:32, 1:32) = 0;
files=dir('*.bmp');

for ii=1:length(files)
    maskfile=files(ii).name;
    RGBfile=[maskfile(1: strfind(maskfile, '.')), 'jpg'];
    mask=imread(maskfile);
    RGB=imread(RGBfile);
    im_ROI=RGB;
    im_ROI(:, :, 4)=~mask;
    im_bgd=RGB;
    im_bgd(:, :, 4)=mask;
    [SPM_on, numTable, skinPixels, nonskinPixels]=SPM_train_online(im_ROI, im_bgd, numTable, skinPixels, nonskinPixels);
    ii
end

save SPM_on SPM_on