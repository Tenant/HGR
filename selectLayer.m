function mask=selectLayer(L, mask_)
    layer=max(max(L));
    if layer>0
        for ii=1:layer
            mask__=L==ii;
            total=sum(sum(mask__));
            mask__=bitand(mask_, mask__);
            p=sum(sum(mask__));
            
            if p/total>0.2 %0.02
                mask=L==ii;
                mask=imfill(mask, 'holes');
                mask=bwareaopen(mask, 800);
                return;
            end
        end
    end
    
    mask=mask_;
    mask=imfill(mask, 'holes');
    mask=bwareaopen(mask, 800);
    mask=zeros(size(mask_));

end