% Author: kli@melexis.com
% For use with NEW MATLAB VERSION 2016b
function output = TwoComp_KLI(x, numBits)
    maxN = 2^(numBits - 1);
    
    t = x > maxN;
    value(t) = x(t) - maxN*2;
    t = ~t;
    value(t) = x(t);
        
    output = reshape(value,size(x,1),size(x,2));
end