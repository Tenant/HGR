function [L]=watershed_3D(rgb)
    %
    % function []=watershed_3D(rgb)

    I = rgb2gray(rgb);%ת��Ϊ�Ҷ�ͼ�� 
    hy = fspecial('sobel');%sobel���� 
    hx = hy'; 
    Iy = imfilter(double(I), hy, 'replicate');%�˲���y�����Ե 
    Ix = imfilter(double(I), hx, 'replicate');%�˲���x�����Ե 
    gradmag = sqrt(Ix.^2 + Iy.^2);%���� 

    %3.�ֱ��ǰ���ͱ������б�ǣ�������ʹ����̬ѧ�ؽ�������ǰ��������б�ǣ�����ʹ�ÿ�������������֮�����ȥ��һЩ��С��Ŀ�ꡣ 
    se = strel('disk', 20);%Բ�νṹԪ�� 
    Io = imopen(I, se);%��̬ѧ������ 
    Ie = imerode(I, se);%��ͼ����и�ʴ 
    Iobr = imreconstruct(Ie, I);%��̬ѧ�ؽ� 
    Ioc = imclose(Io, se);%��̬ѧ�ز��� 
    Iobrd = imdilate(Iobr, se);%��ͼ��������� 
    Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));%��̬ѧ�ؽ� 
    Iobrcbr = imcomplement(Iobrcbr);%ͼ���� 
    fgm = imregionalmax(Iobrcbr);%�ֲ�����ֵ 
    se2 = strel(ones(5,5));%�ṹԪ�� 
    fgm2 = imclose(fgm, se2);%�ز��� 
    fgm3 = imerode(fgm2, se2);%��ʴ 
    fgm4 = bwareaopen(fgm3, 20);%������ 
    bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%ת��Ϊ��ֵͼ�� 
    %4. ���з�ˮ��任����ʾ�� 
    D = bwdist(bw);%������� 
    DL = watershed(D);%��ˮ��任 
    bgm = DL == 0;%��ȡ�ָ�߽� 
    gradmag2 = imimposemin(gradmag, bgm | fgm4);%����Сֵ 
    L = watershed(gradmag2);%��ˮ��任 

end