%{
Motion Detection Script
Image Differecing
Reference: R. T. Collins et al.
By Gao Shuqi, 0n 2018-03-30
Test Data: imDiff_test_Data_mat
%}
function mask=imDiff(im_in_1, im_in_2, im_in_3, threshold)

    if ndims(im_in_1)==3% RGB is given
         im_in_1 = rgb2gray(im_in_1);
    end 
    
    if ndims(im_in_2)==3% RGB is given
         im_in_2 = rgb2gray(im_in_2);
    end 
    
    if ndims(im_in_3)==3% RGB is given
         im_in_3 = rgb2gray(im_in_3);
    end 

    mask=(im_in_3-im_in_2)>threshold & (im_in_3-im_in_1)>threshold;
    
end

