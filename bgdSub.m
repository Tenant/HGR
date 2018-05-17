function [mask, bgd, threshold]=bgdSub(img, bgd, learningrate, threshold)

   [m, n, k]=size(img);
   Euler=zeros(m, n);
   
   if k==3
        for ii=1:m
            for jj=1:n
                tmp=(img(ii, jj, 1)-bgd(ii, jj, 1))^2+(img(ii, jj, 2)-bgd(ii, jj, 2))^2+(img(ii, jj, 3)-bgd(ii, jj, 3))^2;
                Euler(ii, jj)=uint8(sqrt(double(tmp)));
            end
        end
   else
       for ii=1:m
           for jj=1:n
               tmp=max(img(ii,jj)-bgd(ii,jj),0);
               Euler(ii,jj)=uint8(sqrt(double(tmp)));
           end
       end
   end
    mask=Euler>threshold;
 
    if k==1
        bgd(~mask)=learningrate*bgd(~mask)+(1-learningrate)*img(~mask);
    else
        R=bgd(:,:,1);
        G=bgd(:,:,2);
        B=bgd(:,:,3);
        R_=img(:,:,1);
        G_=img(:,:,2);
        B_=img(:,:,3);
        R(~mask)=learningrate*R(~mask)+(1-learningrate)*R_(~mask);
        G(~mask)=learningrate*G(~mask)+(1-learningrate)*G_(~mask);
        B(~mask)=learningrate*B(~mask)+(1-learningrate)*B_(~mask);
        bgd(:,:,1)=R;
        bgd(:,:,2)=G;
        bgd(:,:,3)=B;
    end
    
    threshold(~mask)=learningrate*threshold(~mask)+5*(1-learningrate)*Euler(~mask);
    TMP=threshold>6; % ### 背景去除算法阈值下限 precious=3
    threshold(~TMP)=6;

end