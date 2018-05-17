function [mask]=getRGmask3(I, threshold,x, y, distImg)
    %
    I = im2double(I); %图像灰度值归一化到[0,1]之间  
    gausFilter = fspecial('gaussian',[5 5],0.5);  
    I = imfilter(I,gausFilter,'replicate');  
 
    J = zeros(size(I)); % 主函数的返回值，记录区域生长所得到的区域  
    Isizes = size(I);  
    reg_mean = I(x,y);
    dist_mean=distImg(x,y);
    reg_size = 1; 
    neg_free = 10000;   
    neg_list = zeros(neg_free,4);  
    neg_pos = 0;%用于记录neg_list中的待分析的像素点的个数  
    pixdist = 0;  
    neigb = [ -1 0;  
              1  0;  
              0 -1;  
              0  1];  

     while (pixdist < threshold && reg_size < numel(I))  
         for j=1:4  
             xn = x + neigb(j,1);  
             yn = y + neigb(j,2);  
             ins = (xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(1));  
             if( ins && J(xn,yn)==0)  
                 neg_pos = neg_pos+1;  
                 neg_list(neg_pos,:) =[ xn, yn, I(xn,yn), distImg(xn,yn)];
                 J(xn,yn) = 1;
             end  
         end  
  
        if (neg_pos+10>neg_free)  
            neg_free = neg_free + 100000;  
            neg_list((neg_pos +1):neg_free,:) = 0;  
        end  

        dist = abs(neg_list(1:neg_pos,3)-reg_mean);  
        [pixdist,index] = min(dist);  
% 考虑使用如下近似解法替换上面两行
% [index, ~]=find(abs(neg_list(1:neg_pos,3)-reg_mean)<threshold, 1);
% if numel(index)==0
%     break
% end
% pixdist=abs(neg_list(index,3)-reg_mean);
        % 判断该像素点深度值是否满足条件
        if abs(neg_list(index, 4)-dist_mean)>50 % #### 设定深度值波动的范围 precious=150，100
            x = neg_list(index,1);
            y = neg_list(index,2);
            if neg_pos~=0
                neg_list(index,:) = neg_list(neg_pos,:);
                neg_pos = neg_pos -1;
            else
                break
            end
            continue
        end
        
        %计算区域的新的均值  
        reg_mean = (reg_mean * reg_size +neg_list(index,3))/(reg_size + 1);  
        dist_mean = (dist_mean * reg_size +neg_list(index,4))/(reg_size + 1); 
        reg_size = reg_size + 1;  
        %将旧的种子点标记为已经分割好的区域像素点  
        J(x,y)=2;%标志该像素点已经是分割好的像素点  
        x = neg_list(index,1);  
        y = neg_list(index,2);  
        %将新的种子点从待分析的邻域像素列表中移除
      if neg_pos~=0
            neg_list(index,:) = neg_list(neg_pos,:);  
            neg_pos = neg_pos -1; 
      else
            break;
       end
     end  

     J = (J==2);%我们之前将分割好的像素点标记为2  
     mask = bwmorph(J,'dilate');%补充空洞
     
end