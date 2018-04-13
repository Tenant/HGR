% Preprocessing for Neutral Network Training
files=dir('*.bmp');
H=zeros(length(files), 784);

for k=1:length(files)
    maskfile=files(k).name;
    mask=imread(maskfile);
    
    [m n]=size(mask);
    dm=floor(m/28);
    dn=floor(n/28);
    
    for ii=1:28
        for jj=1:28
            sum=0;
            for x=(ii-1)*dm+1:ii*dm
                for y=(jj-1)*dn+1:jj*dn
                    sum=sum+mask(x, y);
                end
            end
            
            H(k, (ii-1)*28+jj)=(sum/(dm*dn)>0.5);
        end
    end

end