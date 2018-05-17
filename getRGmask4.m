function L=getRGmask4(img, threshold, mask, distImg)
    %
    % ��ָ����Χ������������ӵ�������������㷨
    
    L=zeros(size(img));
    label=1;
    iteration=1;
    [row, col]=find(mask==1);
    num=numel(row);
    if num==0
        return 
    end
    
    while(iteration<=20) % ### �������������㷨��������
        index=uint16(1+(num-1)*rand());
        x=row(index);
        y=col(index); 
        
        if L(x,y)==0
            mask=getRGmask3(img, threshold, x, y, distImg);
            p=sum(sum(mask));
            if p>66 % ### ����������66��������Ϊ����Ч����
                L(mask)=uint8(label);
                label=label+1;
            else
                L(mask)=255;
            end
        end
        iteration=iteration+1;
    end
    
    L(L==255)=0;
end