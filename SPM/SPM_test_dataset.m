function rate=SPM_test_dataset(data, spm,threshold)
    %
    %
    
    length=size(data,1);
    quantizationTable=zeros(1,256);
    for ii=1:32
        quantizationTable((ii-1)*8+1:ii*8)=linspace(ii,ii,8);
    end
    
    matchPixels=0;
    totalPixels=0;
    
    for ii=1:length
        predict=spm(quantizationTable(data(ii,1)+1), quantizationTable(data(ii,2)+1), quantizationTable(data(ii,3)+1))>threshold;
        if predict==data(ii,4)
            matchPixels=matchPixels+1;
        end
        totalPixels=totalPixels+1;
    end
    
    rate=matchPixels/totalPixels;
end