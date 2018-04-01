function circularity=calCircul(im_in)
% Calculate the Circularity of the im_in
% ��������ͼ���Բ��
% input: BW imagge
% ���룺��ֵ��ͼ��
% output: Circularity
% �����Բ��
    CC=bwconncomp(im_in);
    stats = regionprops(CC, 'all');
    allPerimeters = [stats.Perimeter];
    allAreas = [stats.Area];
    circularity = allPerimeters  .^ 2 ./ (4 * pi* allAreas);
end
