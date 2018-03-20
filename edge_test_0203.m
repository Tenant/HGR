clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
I0=imread('palm.jpg');
I0=rgb2gray(I0);
figure(1);imhist(I0);title('ohist');
I0=imadjust(I0);
I0=255-I0;
figure(2);subplot(2,2,1);imshow(I0);title('original');
%I=imbinarize(I); 
I=double(I0);
I_edge=edge(I,'Sobel',9);%��Ե����ȡ
figure(2);subplot(2,2,2);imshow(I_edge);title('edge');
%Ihist=imhist(I);
%figure(1);subplot(2,2,3);imshow(Ihist);title('hist');

[m,n]=size(I);%ͼ��ߴ�
I_zeros=zeros(m,n);%�½�һ�����ڼ�¼��Ե��Ҷ�ֵ�ľ���
for i=1:m
    for j=1:n
        if 1 == I_edge(i,j)
            I_zeros(i,j)=I0(i,j);
        end
    end
end
%I_zeros1=gray2rgb(I_zeros);%����¼�Ҷ�ֵ�ľ���ת��Ϊrgb
figure(2);subplot(2,2,3);imshow(I_zeros);title('edge_points');
%I_zeros=uint8(I_zeros);
%I_zeroshist=imhist(I_zeros);
figure(3);
%subplot(2,2,4);

I_zeros=uint8(I_zeros);
no_zeros=[];%��ȡ��һ�������еķ������ص�Ҷ�ֵ������ͳ����ʵ�ĻҶ�ֵƵ�����ֵ
nz_xy=[];%��¼�������ص������
k=1;%��Ե���ص�ĸ���
%k=uint8(k);
for i=1:m
    for j=1:n
        if 0 ~= I_zeros(i,j)
            no_zeros(k)=I0(i,j);
            k=k+1;
            nz_xy=[nz_xy;i,j];
        end
    end
end

imhist(I_zeros);title('edgePointsHist');
a = 1:255;%����no_zeros�����ݷ�Χ
b =histc(no_zeros,a);%�õ�1~255��no_zeros�г��ֵĴ���
[max_num, max_index] = max(b);%�ó�no_zeros�г��ִ�������Ԫ�س��ֵĴ���max_num
                              %�͸�Ԫ����a�е��±�
DensityValue = a(max_index);%������ִ������ĻҶ�ֵ
SeedPoints=[];%�������ڴ洢���ִ������ĻҶ�ֵ��Ӧ���������꣬Ҳ����һ����������
num=0;%�������ص����
for i=1:m
    for j=1:n
        if DensityValue == I_zeros(i,j)
            SeedPoints=[SeedPoints;i,j];
            num=num+1;
        end
    end
end

T=0;%��ʼ���ָ���ֵ
for i=1:k-1
    T=T+abs(no_zeros(i)-DensityValue);
end
T=T/(k-1);%�õ��ָ���ֵT

Jgrow = zeros(size(I0)); % �������ķ���ֵ����¼�����������õ�������  
Isizes = size(I0);  
reg_mean = DensityValue;%��ʾ�ָ�õ������ڵ�ƽ��ֵ����ʼ��Ϊ���ӵ�ĻҶ�ֵ  
reg_size = 1;%�ָ�õ������򣬳�ʼ��ֻ�����ӵ�һ��  
neg_free = 10000; %��̬�����ڴ��ʱ��ÿ������������ռ��С  
neg_list = zeros(neg_free,3);  %���������б�����Ԥ�ȷ������ڴ�������������ص������ֵ�ͻҶ�ֵ�Ŀռ䣬����
index = 1;%��ʼ�����б�ָ��
  
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

 
pgrow=num%ջָ��
while num>0
     %�ж�seed�����Ƿ�Ϊ�գ������Ϊ�գ�ȡ������������Ϊ��ǰ���ӵ��������Ĳ���
     x=SeedPoints(pgrow,1);%ѡȡ�������ؿ�ʼ����
     y=SeedPoints(pgrow,2);
     num=num-1 %�������ص����-1
     for j=1:4  
         xn = x + neigb(j,1);  
         yn = y + neigb(j,2);  
         %������������Ƿ񳬹���ͼ��ı߽�  
         ins = (xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(1));  
         %�������������ͼ���ڲ���������δ�ָ�ã���ô������ӵ������б���  
         if( ins && Jgrow(xn,yn)==0)  
             neg_pos = neg_pos+1;  
             neg_list(neg_pos,:) =[ xn, yn, I(xn,yn)];%�洢��Ӧ��ĻҶ�ֵ  
             Jgrow(xn,yn) = 1;%��ע���������ص��Ѿ������ʹ� ������ζ�ţ����ڷָ�������  
         end  
     end  
 

    %�жϸú�ѡ���ص��Ƿ�����������׼��
    if (abs(I0(x,y)-DensityValue)<=T)
        %�����㣬������ӵ���ѡ���������У���ʾ�÷���ɼ�������
        reg_size = reg_size + 1;  
        num=num+1
        pgrow=pgrow+1;
        SeedPoints(pgrow,1)=x;
        SeedPoints(pgrow,2)=y;
        Jgrow(x,y)=2;%��־�����ص��Ѿ��Ƿָ�õ����ص�  
        
    %����������µľ�ֵ  
    %reg_mean = (reg_mean * reg_size +neg_list(index,3))/(reg_size + 1);  
   %���������ڴ���ʲ����������µ��ڴ�ռ�  

    %���ɵ����ӵ���Ϊ�Ѿ��ָ�õ��������ص�  
    
   % x = neg_list(index,1);  
   % y = neg_list(index,2);  
    index=index+1;
        if (neg_pos+10>neg_free)  
        neg_free = neg_free + 100000;  
        neg_list((neg_pos +1):neg_free,:) = 0;  
        end  
%     pause(0.0005);%��̬����  
%     if(J(x,y)==2)  
%     plot(x,y,'r.');  
%     end  
    else
%��������ָ���ֵ���������µ����ӵ�Ӵ����������������б����Ƴ�  
    neg_list(index,:) = neg_list(neg_pos,:);  
    neg_pos = neg_pos -1;  
    pgrow=pgrow-1;
    num=num-1
    end  
end
   
 Jgrow = (Jgrow==2);%����֮ǰ���ָ�õ����ص���Ϊ2  
 hold off;  
 subplot(2,2,2),imshow(Jgrow);  
 Jgrow = bwmorph(Jgrow,'dilate');%����ն�  
 se = strel('disk',5);
 Jgrow = imdilate(Jgrow,se);
 subplot(2,2,3),imshow(Jgrow);  
 subplot(2,2,4),imshow(I+Jgrow);  
