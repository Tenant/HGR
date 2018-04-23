function [L]=watershed_3D(rgb)
    %
    % function []=watershed_3D(rgb)

    I = rgb2gray(rgb);%转化为灰度图像 
    hy = fspecial('sobel');%sobel算子 
    hx = hy'; 
    Iy = imfilter(double(I), hy, 'replicate');%滤波求y方向边缘 
    Ix = imfilter(double(I), hx, 'replicate');%滤波求x方向边缘 
    gradmag = sqrt(Ix.^2 + Iy.^2);%求摸 

    %3.分别对前景和背景进行标记：本例中使用形态学重建技术对前景对象进行标记，首先使用开操作，开操作之后可以去掉一些很小的目标。 
    se = strel('disk', 20);%圆形结构元素 
    Io = imopen(I, se);%形态学开操作 
    Ie = imerode(I, se);%对图像进行腐蚀 
    Iobr = imreconstruct(Ie, I);%形态学重建 
    Ioc = imclose(Io, se);%形态学关操作 
    Iobrd = imdilate(Iobr, se);%对图像进行膨胀 
    Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));%形态学重建 
    Iobrcbr = imcomplement(Iobrcbr);%图像求反 
    fgm = imregionalmax(Iobrcbr);%局部极大值 
    se2 = strel(ones(5,5));%结构元素 
    fgm2 = imclose(fgm, se2);%关操作 
    fgm3 = imerode(fgm2, se2);%腐蚀 
    fgm4 = bwareaopen(fgm3, 20);%开操作 
    bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%转化为二值图像 
    %4. 进行分水岭变换并显示： 
    D = bwdist(bw);%计算距离 
    DL = watershed(D);%分水岭变换 
    bgm = DL == 0;%求取分割边界 
    gradmag2 = imimposemin(gradmag, bgm | fgm4);%置最小值 
    L = watershed(gradmag2);%分水岭变换 

end