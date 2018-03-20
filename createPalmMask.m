function im_out=createPalmMask(im_in_gray, im_in_bw)
    IM1 = bwdist(~im_in_bw); % Distance Transform Image
    IM2 = IM1 > 30; % Threshold the EDT image at 30 since that's how wide the fingers are
    im_out = im_in_gray; % Initialize
    im_out(~IM2) = 0; % Erase everything outside the mask. IM5: maskedImage
end