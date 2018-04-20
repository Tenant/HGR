function [im_diff_filt, im_sub_filt, im_spm_filt] = Region_based_Combination (im_diff, im_sub, im_spm)
    %
    % function [mask] = Region_based_Combination (im_diff, im_sub, im_spm)
    %
    % Input: 
    % Output: mask(., .)==1 when the region corresponds to handgesture.
    
    % 获取图像尺寸
    Height=size(im_diff,1);
    Width=size(im_diff,2);
     im_diff_filt=zeros(Height, Width);
     im_sub_filt=zeros(Height,Width);
     im_spm_filt=zeros(Height, Width);
    
    % 设置滑动窗口大小
    window=5;
    threshold=window*window/2;
    
    top=ceil((window+1)/2);
    bottom=Height-floor((window-1)/2);
    left=ceil((window+1)/2);
    right=Width-floor((window-1)/2);
    
    for ii=top:bottom
        for jj=left:right
            sum_diff=0;
            sum_sub=0;
            sum_spm=0;
            for k1=(ii-top+1):(ii-top+window)
                for k2=(jj-left+1):(jj-left+window)
                    if(im_diff(k1,k2)) 
                        sum_diff=sum_diff+1;
                    end
                    if(im_sub(k1,k2))
                        sum_sub=sum_sub+1;
                    end
                    if(im_spm(k1,k2))
                        sum_spm=sum_spm+1;
                    end
                end
            end
            if(sum_diff>threshold)
                im_diff_filt(ii,jj)=1;
            end
            if(sum_sub>threshold)
                im_sub_filt(ii,jj)=1;
            end
            if(sum_spm>threshold)
                im_spm_filt(ii,jj)=1;
            end
            
        end
    end
   
    % 将double型变量转换为Boolean型
    im_diff_filt=im_diff_filt==1;
    im_sub_filt=im_sub_filt==1;
    im_spm_filt=im_spm_filt==1;
    
    [left, right, top, bottom]=findBorder(im_diff_filt);
    im_sub_crop=zeros(size(im_sub_filt));
    im_spm_crop=zeros(size(im_spm_filt));
    im_sub_crop(left:right, top:bottom)=im_sub_filt(left:right, top:bottom);
    im_spm_crop(left:right, top:bottom)=im_spm_filt(left:right, top:bottom);
    
    


end


