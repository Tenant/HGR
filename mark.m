function im_out=mark(im_in, mask)
    %
    % ����maskͼ�������ͼ����������ע
    %
    Height=size(im_in,1);
    Width=size(im_in,2);
    
    % ���ͼ��Ϊ�Ҷ�ͼ������ת��Ϊα��ɫͼ��
     if(size(im_in,3)==1)
        im_out(:,:,1)=im_in;
        im_out(:,:,2)=im_in;
        im_out(:,:,3)=im_in;
        im_in=im_out;
    end
    
    im_out=im_in;
    
    for ii=1:Height
        for jj=1:Width
            if(mask(ii,jj))
                im_out(ii,jj,:)=[50 205 50];
            end
        end
    end
    
end