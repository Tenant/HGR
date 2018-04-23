function [mask]=Region_Growing_RGB_single_point(I, threshold, x, y)
    %
    %
    %
    J = zeros(size(I,1),size(I,2)); % �������ķ���ֵ����¼�����������õ�������  
    Isizes = size(I);  
    reg_mean = [double(I(x,y,1)), double(I(x,y,2)), double(I(x,y,3))];%��ʾ�ָ�õ������ڵ�ƽ��ֵ����ʼ��Ϊ���ӵ��RGBֵ   
    reg_size = 1;%�ָ�ĵ������򣬳�ʼ��ֻ�����ӵ�һ��  
    neg_free = 10000; %��̬�����ڴ��ʱ��ÿ������������ռ��С  
    neg_list = zeros(neg_free,5);  
    %���������б�����Ԥ�ȷ������ڴ�������������ص������ֵ��RGBֵ�Ŀռ䣬����  
    %���ͼ��Ƚϴ���Ҫ���neg_free��ʵ��matlab�ڴ�Ķ�̬����  
    neg_pos = 0;%���ڼ�¼neg_list�еĴ����������ص�ĸ���  
    pixdist = 0;  
    %��¼�������ص����ӵ��ָ������ľ�����  
    %��һ�δ��������ĸ��������ص�͵�ǰ���ӵ�ľ���  
    %�����ǰ����Ϊ��x,y����ôͨ��neigb���ǿ��Եõ����ĸ��������ص�λ��  
    neigb = [ -1 0;  
              1  0;  
              0 -1;  
              0  1];  
     %��ʼ�������������������д��������������ص���Ѿ��ָ�õ��������ص�ĻҶ�ֵ����  
     %����reg_maxdis,������������  

     while (pixdist < threshold*256 && reg_size < Isizes(1)*Isizes(2)) 
         %�����µ��������ص�neg_list��  
         for j=1:4  
             xn = x + neigb(j,1);  
             yn = y + neigb(j,2);  
             %������������Ƿ񳬹���ͼ��ı߽�  
             ins = (xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(2));  
             %�������������ͼ���ڲ���������δ�ָ�ã���ô������ӵ������б���  
             if( ins && J(xn,yn)==0)  
                 neg_pos = neg_pos+1;  
                 neg_list(neg_pos,:) =[ xn, yn, I(xn,yn,1),I(xn,yn,2),I(xn,yn,3)];%�洢��Ӧ��ĻҶ�ֵ  
                 J(xn,yn) = 1;%��ע���������ص��Ѿ������ʹ� ������ζ�ţ����ڷָ�������  
             end  
         end  
        %���������ڴ���ʲ����������µ��ڴ�ռ�  
        if (neg_pos+10>neg_free)  
            neg_free = neg_free + 100000;  
            neg_list((neg_pos +1):neg_free,:) = 0;  
        end  
        %�����д����������ص���ѡ��һ�����ص㣬�õ�ĻҶ�ֵ���Ѿ��ָ������ҶȾ�ֵ��  
        %��ľ���ֵʱ����������������С��
        if(neg_pos==0) 
            break;
        end
        dR=abs(neg_list(1:neg_pos,3)-double(reg_mean(1)));
        dG=abs(neg_list(1:neg_pos,4)-double(reg_mean(2)));
        dB=abs(neg_list(1:neg_pos,5)-double(reg_mean(3)));
        dist=sqrt(dR.*dR+dG.*dG+dB.*dB);
        [pixdist,index] = min(dist);  
        %����������µľ�ֵ
        reg_mean= (reg_mean*reg_size+neg_list(index,3:5))/(reg_size + 1);
        reg_size = reg_size + 1;  
        %���ɵ����ӵ���Ϊ�Ѿ��ָ�õ��������ص�  
        J(x,y)=2;%��־�����ص��Ѿ��Ƿָ�õ����ص�  
        x = neg_list(index,1);  
        y = neg_list(index,2);  
    %     pause(0.0005);%��̬����  
    %     if(J(x,y)==2)  
    %     plot(x,y,'r.');  
    %     end  
        %���µ����ӵ�Ӵ����������������б����Ƴ�  
        neg_list(index,:) = neg_list(neg_pos,:);  
        neg_pos = neg_pos -1;  
     end  

     J = (J==2);%����֮ǰ���ָ�õ����ص���Ϊ2  
     mask = bwmorph(J,'dilate');%����ն�  

end