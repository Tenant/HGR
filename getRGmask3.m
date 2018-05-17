function [mask]=getRGmask3(I, threshold,x, y, distImg)
    %
    I = im2double(I); %ͼ��Ҷ�ֵ��һ����[0,1]֮��  
    gausFilter = fspecial('gaussian',[5 5],0.5);  
    I = imfilter(I,gausFilter,'replicate');  
 
    J = zeros(size(I)); % �������ķ���ֵ����¼�����������õ�������  
    Isizes = size(I);  
    reg_mean = I(x,y);
    dist_mean=distImg(x,y);
    reg_size = 1; 
    neg_free = 10000;   
    neg_list = zeros(neg_free,4);  
    neg_pos = 0;%���ڼ�¼neg_list�еĴ����������ص�ĸ���  
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
% ����ʹ�����½��ƽⷨ�滻��������
% [index, ~]=find(abs(neg_list(1:neg_pos,3)-reg_mean)<threshold, 1);
% if numel(index)==0
%     break
% end
% pixdist=abs(neg_list(index,3)-reg_mean);
        % �жϸ����ص����ֵ�Ƿ���������
        if abs(neg_list(index, 4)-dist_mean)>50 % #### �趨���ֵ�����ķ�Χ precious=150��100
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
        
        %����������µľ�ֵ  
        reg_mean = (reg_mean * reg_size +neg_list(index,3))/(reg_size + 1);  
        dist_mean = (dist_mean * reg_size +neg_list(index,4))/(reg_size + 1); 
        reg_size = reg_size + 1;  
        %���ɵ����ӵ���Ϊ�Ѿ��ָ�õ��������ص�  
        J(x,y)=2;%��־�����ص��Ѿ��Ƿָ�õ����ص�  
        x = neg_list(index,1);  
        y = neg_list(index,2);  
        %���µ����ӵ�Ӵ����������������б����Ƴ�
      if neg_pos~=0
            neg_list(index,:) = neg_list(neg_pos,:);  
            neg_pos = neg_pos -1; 
      else
            break;
       end
     end  

     J = (J==2);%����֮ǰ���ָ�õ����ص���Ϊ2  
     mask = bwmorph(J,'dilate');%����ն�
     
end