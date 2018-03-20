function  eigen=eigenExtract(IM)
% input: the RGB image of hand gesture
% output: the eigenvectors of hand gesutre 2*5
    IM1=skincolorExtract(IM);
    IM2=im2bw(IM1,graythresh(IM1)); 
    IM3=createPalmMask(IM1, IM2);
    IM4=im2bw(IM3,graythresh(IM3)); % masked binary Image
    IM4 = imdilate(IM4,strel('disk',30)); %%% this parameter can be tuned
    REG=regionprops(IM4,'all');
    origin= REG(1).Centroid;
    
    IM5=IM2-IM4; % IM7: finger binary Image
    IM5=imerode(IM5,strel('disk',10)); %%% this parameter can be tuned
    IM5=imdilate(IM5,strel('disk',10)); %%% this parameter can be tuned
    IM5 = bwareaopen(IM5, 600); %%% this parameter can be tuned
    
    REG=regionprops(IM5,'all');   
    [B, L, N, A] = bwboundaries(IM5,'noholes');
    
    for k=1:length(B)
        center=REG(k). Centroid;
        x(k)=center(1);
        y(k)=center(2);
    end
    
    % plot
    figure;subplot(1,2,1);imshow(IM);
    IM60=imerode(IM4,strel('disk',10)); %%% this parameter can be tuned
    IM8=IM60+IM5;
    X=bwlabel(IM8);
    RGB=label2rgb(X, @summer, 'k');
    subplot(1,2,2);imshow(RGB+1,'InitialMagnification','fit')
    hold on
    plot(origin(1),origin(2),'*');
    for k=1:length(B)
        plot(x(k),y(k),'*');
        line([x(k), origin(1)],[y(k), origin(2)]);
    end
    
    % calulate the eigenvalues
    eigen=zeros(2,5);
    for k=1:length(B)
        eigen(1,k)=x(k)-origin(1);
        eigen(2,k)=y(k)-origin(2);
    end

end