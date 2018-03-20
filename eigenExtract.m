function  eigen=eigenExtract(IM)
% input: the RGB image of hand gesture
% output: the eigenvectors of hand gesutre 2*5
    YCBCR = rgb2ycbcr(IM);
    Y_MIN = 0;  
    Y_MAX = 255;  
    Cb_MIN = 100;  
    Cb_MAX = 130;  
    Cr_MIN = 130;   
    Cr_MAX = 170;  
    threshold=roicolor(YCBCR(:,:,1),Y_MIN,Y_MAX)&roicolor(YCBCR(:,:,2),Cb_MIN,Cb_MAX)&roicolor(YCBCR(:,:,3),Cr_MIN,Cr_MAX);
    IM1=rgb2gray(IM);
    IM1=IM1.*uint8(threshold);
    
    IM2=im2bw(IM1,graythresh(IM1)); 
%     IM2=1-IM2; % IM2: BW image of the frame
    
    IM3 = bwdist(~IM2); % IM3:Distance Transform Image
    
    % Threshold the EDT image at 110 since that's how wide the fingers are.
    IM4 = IM3 > 30; % IM4: palm mask image
    
    IM5 = IM1; % Initialize
    IM5(~IM4) = 0; % Erase everything outside the mask. IM5: maskedImage
    
    IM6=im2bw(IM5,graythresh(IM5)); % masked binary Image
    IM6 = imdilate(IM6,strel('disk',30)); %%% this parameter can be tuned
    REG=regionprops(IM6,'all');
    origin= REG(1).Centroid;
    
    IM7=IM2-IM6; % IM7: finger binary Image
    IM7=imerode(IM7,strel('disk',10)); %%% this parameter can be tuned
    IM7=imdilate(IM7,strel('disk',10)); %%% this parameter can be tuned
    IM7 = bwareaopen(IM7, 600); %%% this parameter can be tuned
    
    REG=regionprops(IM7,'all');   
    [B, L, N, A] = bwboundaries(IM7,'noholes');
    
    for k=1:length(B)
        center=REG(k). Centroid;
        x(k)=center(1);
        y(k)=center(2);
    end
    
    % plot
    figure;subplot(1,2,1);imshow(IM);
    IM60=imerode(IM6,strel('disk',10)); %%% this parameter can be tuned
    IM8=IM60+IM7;
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