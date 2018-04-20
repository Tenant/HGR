function [im_out, bgd, T]=bgdSub_Intensity(im_in, bgd0, a, T0)

    if ndims(bgd0)==3,% RGB is given
        bgd0 = rgb2gray(bgd0);
    end 
    
   [m, n, k]=size(im_in);
   im_out=rgb2gray(im_in);
  
   Euler=uint8(imsubtract(im_out,bgd0));
    mask=Euler>T0;
    im_out(~mask)=0;
    
    % bgd=a*bgd0+(1-a)*im_in;
    bgd=bgd0;
    bgd(~mask)=a*bgd(~mask)+(1-a)*im_in(~mask);
    
    T=T0;
    T(~mask)=uint8(a*T0(~mask))+5*(1-a)*Euler(~mask);
%     tmp=T>10;
%     T(~tmp)=10;9

end