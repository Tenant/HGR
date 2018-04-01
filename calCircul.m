function circularity=calCircul(im_in)
% Calculate the Circularity of the im_in
% 计算输入图像的圆度
% input: BW imagge
% 输入：二值化图像
% output: Circularity
% 输出：圆度
    CC=bwconncomp(im_in);
    stats = regionprops(CC, 'all');
    allPerimeters = [stats.Perimeter];
    allAreas = [stats.Area];
    circularity = allPerimeters  .^ 2 ./ (4 * pi* allAreas);
end
