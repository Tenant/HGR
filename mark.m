function im_out=mark(im_in, mask)
    %
    % ����maskͼ�������ͼ����������ע
    %
    Height=size(im_in,1);
    Width=size(im_in,2);
    
    im_out=im_in;
    
    for ii=1:Height
        for jj=1:Width
            if(mask(ii,jj))
                im_out(ii,jj,:)=[0,0,255];
            end
        end
    end
    
end