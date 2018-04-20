%{
Motion Detection Script
Backgroud Substraction
Reference: R. T. Collins et al.
By Gao Shuqi, 0n 2018-03-30
Test Data: bgdSub_test_data
%}
function [im_out, bgd, T]=bgdSub(im_in, bgd0, a, T0)
    [m, n, k]=size(im_in);
   Euler=zeros(m, n);
    for ii=1:m
        for jj=1:n
            tmp=(im_in(ii, jj, 1)-bgd0(ii, jj, 1))^2+(im_in(ii, jj, 2)-bgd0(ii, jj, 2))^2+(im_in(ii, jj, 3)-bgd0(ii, jj, 3))^2;
            Euler(ii, jj)=uint8(sqrt(double(tmp)));
        end
    end
    mask=Euler>T0;
    im_out=rgb2gray(im_in);
    im_out(~mask)=0;
    
    % bgd=a*bgd0+(1-a)*im_in;
    bgd=bgd0;
    R=bgd(:,:,1);
    G=bgd(:,:,2);
    B=bgd(:,:,3);
    R(~mask)=a*R(~mask)+(1-a)*im_in(~mask);
    G(~mask)=a*G(~mask)+(1-a)*im_in(~mask);
    B(~mask)=a*B(~mask)+(1-a)*im_in(~mask);
    bgd(:,:,1)=R;
    bgd(:,:,2)=G;
    bgd(:,:,3)=B;
    
    T=T0;
%     maxium=max(Euler(:));
%     BND=zeros(size(Euler))+maxium; % maxium
%     TMP=BND-Euler;
    T(~mask)=a*T0(~mask)+5*(1-a)*Euler(~mask);
    tmp=T>10;
    T(~tmp)=10;

end