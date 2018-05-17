function L=getRGmask2(img, threshold)
    %
    % 在全图像范围内随机生成种子点完成区域生长算法
    
    [m,n]=size(img);
    L=zeros(m,n);
    label=1;
    iteration=1;
    
    while(iteration<=100) % 设置迭代次数
        x=uint16(1+(m-1)*rand());
        y=uint16(1+(n-1)*rand()); 
        
        if L(x,y)==0
            mask=getRGmask3(img, threshold, x, y);
            p=sum(sum(mask));
            if p>66 % 66
                L(mask)=uint8(label);
                label=label+1;
            else
                L(mask)=255;
            end
            iteration=iteration+1;
        end
    end
    
    L(L==255)=0;
end