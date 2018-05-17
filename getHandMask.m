function [mask, config, imdMask, bgsMask, L]=getHandMask(frame_t, frame_tt, frame_ttt, config)

    % �˳���������ͷ100~2000mm���������ͼ������
    distMask=bitand(frame_t.distData>config.Perihelion, frame_t.distData<config.Aphelion);
    frame_t.ampData(~distMask)=0;
    
    % ����ͼ���ֵõ�������������
    imdMask=imDiff(frame_ttt.ampData, frame_tt.ampData, frame_t.ampData, config.imd.threshold);
    imdMask=medfilt2(imdMask, [9, 9]);
    
    % ���ڱ���ȥ���㷨�õ�������������
    [bgsMask, config.bgs.background, config.bgs.threshold]=bgdSub(frame_t.ampData, config.bgs.background, config.bgs.learningrate, config.bgs.threshold);
    
    
    % ֱ��ͼ���⻯������߻Ҷ�ͼ��Աȶ�
    frame_t.ampData(frame_t.ampData<0)=0;
    img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
    img=histeq(img, 256);  

    % ��ȡ�������������㷨�õ���ͼ���ɰ�
    mask_=bitor(imdMask, bgsMask);
    mask_=medfilt2(mask_, [3,3]);
    
    L=getRGmask4(img, 0.08, mask_, frame_t.distData); 
    
    % ����imdMask��bgsMask��L����ͶƱ���ϲ���Ʊ�ߵ�����
    layer=max(max(L));
    if layer>0
        total=zeros(1,layer);
        for ii=1:layer
            mask__=L==ii;
            mask__=bitand(mask_, mask__);
            total(ii)=sum(sum(mask__));
        end
        [~, index]=sort(total,'descend');
        pixel_low_threshold=0.2; % ### ��Ч�ɰ�����Ӧ��������С���ر���, precious=60, 100, 200
        mask=zeros(size(mask_));
        for k=1:layer
            label=L==index(k);
            if sum(sum(bitand(mask_,label)))<pixel_low_threshold*sum(sum(label))
                break
            end
            mask=bitor(mask,label);
        end
        %  �ж�mask�Ƿ�Ϊ������
        [row, col]=find(mask==1);
        if numel(row)<100
            mask=mask_;
            mask=imfill(mask, 'holes');
            mask=bwareaopen(mask, 20);
            return
        end
        
        % �ͼ��ն�
        mask=imfill(mask, 'holes');
        mask=bwareaopen(mask, 20);
        
        % ��ͼ����о������
        X=[row, col];
        idx=kmeans(X, 2);
        mask1=zeros(size(mask));
        for k=1:numel(idx)
            if idx(k)==1
                mask1(row(k), col(k))=1;
            end
        end
        mask2=bitxor(mask, mask1);
        p=sum(sum(bitand(mask_, mask1)));
        q=sum(sum(bitand(mask_, mask2)));
        
        if p<pixel_low_threshold*sum(sum(mask1))
            mask=mask2;
        elseif q<pixel_low_threshold*sum(sum(mask2))
            mask=mask1;
        else 
        end
        
        return
    end
    
    % ��δ������Ч�����򷵻ر���ȥ���㷨��ͼ�����㷨�Ľ��
    mask=mask_;
    mask=imfill(mask, 'holes');
    mask=bwareaopen(mask, 20);
end