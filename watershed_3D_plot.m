function []=watershed_3D_plot(img)

    L=watershed_3D(img);
    Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');%ת��Ϊα��ɫͼ��
    figure; 
    imshow(img), 
    hold on 
    himage = imshow(Lrgb);%��ԭͼ����ʾα��ɫͼ�� 
    set(himage, 'AlphaData', 0.3); 
    title('Lrgb superimposed transparently on original image')
end