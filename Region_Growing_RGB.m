function [mask]=Region_Growing_RGB(I, threshold, x, y)
    %
    % function []=Region_Growing_GRB(img)  
    %
    % Segment based on area, Region Growing;  
    gausFilter = fspecial('gaussian',[5 5],0.5);  
    I = imfilter(I,gausFilter,'replicate');
    mask=zeros(size(I,1),size(I,2));
    mask=mask==1;
    num=length(x);
    for ii=1:num
        if(~mask(x(ii),y(ii)))
            J=Region_Growing_RGB_single_point(I,threshold,x(ii),y(ii));
            mask=bitor(mask, J);
        end
    end
     
end