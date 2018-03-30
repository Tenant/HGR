%{
Motion Detection Script
Image Differecing
Reference: R. T. Collins et al.
By Gao Shuqi, 0n 2018-03-30
Test Data: imDiff_test_Data_mat
%}
function im_out=imDiff(im_in_1, im_in_2, im_in_3)

    if ndims(im_in_1)==3,% RGB is given
         im_in_1 = rgb2gray(im_in_1);
    end 
    
    if ndims(im_in_2)==3,% RGB is given
         im_in_2 = rgb2gray(im_in_2);
    end 
    
    if ndims(im_in_3)==3,% RGB is given
         im_in_3 = rgb2gray(im_in_3);
    end 

    threshold=8; % defalut value= 8
    mask=(im_in_3-im_in_2)>threshold & (im_in_3-im_in_1)>threshold;
    im_out=im_in_3;
    im_out(~mask)=0;
    
end

