function []=watershed_3D_plot(img)

    L=watershed_3D(img);
    Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');%转化为伪彩色图像
    figure; 
    imshow(img), 
    hold on 
    himage = imshow(Lrgb);%在原图上显示伪彩色图像 
    set(himage, 'AlphaData', 0.3); 
    title('Lrgb superimposed transparently on original image')
end