%{
Motion Detection Script
Backgroud Substraction
Test Script
%}
    T=zeros(240, 320)+10;
    bgd=bgdSub_test_data(:, :, :, 1);
    a=0.7;
    for ii=1:25
        im_in=bgdSub_test_data(:, :, :, ii);
        [im_out, bgd, T]=bgdSub(im_in, bgd, a, T);
    end
    imshow(im_out)