 % Author: kli@melexis.com
 function [ M ] = binArray( M, p, q )
    %This function recalculates array values by binning.
    %This binning process combines a cluster of pixels
    %into a single pixel, reducing the overall number of pixels.
    
    [m,n] = size(M);

    M = sum(reshape(M,p,[]),1);
    M = reshape(M,m/p,[]).';

    M = sum(reshape(M,q,[]),1);
    M = reshape(M,n/q,[]).';

    M = M/(p*q);
end

