function im_out=skin_color_extract(im_in)
     YCBCR = rgb2ycbcr(im_in);
     Y_MIN = 0;  
     Y_MAX = 255;  
    Cb_MIN = 95;  
    Cb_MAX = 130;  
    Cr_MIN = 125;   
    Cr_MAX = 170;  
    threshold=roicolor(YCBCR(:,:,1),Y_MIN,Y_MAX)&roicolor(YCBCR(:,:,2),Cb_MIN,Cb_MAX)&roicolor(YCBCR(:,:,3),Cr_MIN,Cr_MAX);
    IM=rgb2gray(im_in);
   im_out=IM.*uint8(threshold);
end