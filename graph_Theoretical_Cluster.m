function im_out=graph_Theoretical_Cluster(im_in)
    % function im_out=graph_Theoretical_Cluster(im_in)
    %
    % Input: the original RGB-colormap image
    % Output: the clustered RGB-colormap image
    
    histogram_bin_size 64;
    neighborhood_size 1;
    length=256/histogram_bin_size;
    
   m=size(im_in,1);
   n=size(im_in, 2);
   number_of_Pixels=zeros(length,length,length);
   
   quantizationTable = linspace(1,1, histogram_bin_size);
   for ii = 2 : length
        quantizationTable = [quantizationTable, linspace(ii,ii,histogram_bin_size)];
   end
    
   for ii = 1:m
        for jj = 1:n
            img(ii,jj,1) = quantizationTable(im_in(ii,jj,1)+1);
            img(ii,jj,2) = quantizationTable(im_in(ii,jj,2)+1);
            img(ii,jj,3) = quantizationTable(im_in(ii,jj,3)+1);
            number_of_Pixels(img(ii,jj,1), img(ii,jj,2), img(ii,jj,3))=number_of_Pixels(img(ii,jj,1), img(ii,jj,2), img(ii,jj,3))+1;
        end
   end
   
   for ii=1:length
       for jj=1:length
           for k=1:length
               
           end
       end
   end
   

           
   
   
end