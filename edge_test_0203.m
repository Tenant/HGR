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
I_edge=edge(I,'Sobel',9);%边缘点提取
figure(2);subplot(2,2,2);imshow(I_edge);title('edge');
%Ihist=imhist(I);
%figure(1);subplot(2,2,3);imshow(Ihist);title('hist');

[m,n]=size(I);%图像尺寸
I_zeros=zeros(m,n);%新建一个用于记录边缘点灰度值的矩阵
for i=1:m
    for j=1:n
        if 1 == I_edge(i,j)
            I_zeros(i,j)=I0(i,j);
        end
    end
end
%I_zeros1=gray2rgb(I_zeros);%将记录灰度值的矩阵转换为rgb
figure(2);subplot(2,2,3);imshow(I_zeros);title('edge_points');
%I_zeros=uint8(I_zeros);
%I_zeroshist=imhist(I_zeros);
figure(3);
%subplot(2,2,4);

I_zeros=uint8(I_zeros);
no_zeros=[];%提取上一个矩阵中的非零像素点灰度值，方便统计真实的灰度值频次最大值
nz_xy=[];%记录非零像素点的坐标
k=1;%边缘像素点的个数
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
a = 1:255;%矩阵no_zeros的数据范围
b =histc(no_zeros,a);%得到1~255在no_zeros中出现的次数
[max_num, max_index] = max(b);%得出no_zeros中出现次数最多的元素出现的次数max_num
                              %和该元素在a中的下标
DensityValue = a(max_index);%求出出现次数最多的灰度值
SeedPoints=[];%矩阵，用于存储出现次数最多的灰度值对应的像素坐标，也就是一组种子像素
num=0;%种子像素点个数
for i=1:m
    for j=1:n
        if DensityValue == I_zeros(i,j)
            SeedPoints=[SeedPoints;i,j];
            num=num+1;
        end
    end
end

T=0;%初始化分割阈值
for i=1:k-1
    T=T+abs(no_zeros(i)-DensityValue);
end
T=T/(k-1);%得到分割阈值T

Jgrow = zeros(size(I0)); % 主函数的返回值，记录区域生长所得到的区域  
Isizes = size(I0);  
reg_mean = DensityValue;%表示分割好的区域内的平均值，初始化为种子点的灰度值  
reg_size = 1;%分割得到的区域，初始化只有种子点一个  
neg_free = 10000; %动态分配内存的时候每次申请的连续空间大小  
neg_list = zeros(neg_free,3);  %定义邻域列表，并且预先分配用于储存待分析的像素点的坐标值和灰度值的空间，加速
index = 1;%初始化该列表指针
  
%如果图像比较大，需要结合neg_free来实现matlab内存的动态分配  
neg_pos = 0;%用于记录neg_list中的待分析的像素点的个数  
pixdist = 0;  
%记录最新像素点增加到分割区域后的距离测度  
%下一次待分析的四个邻域像素点和当前种子点的距离  
%如果当前坐标为（x,y）那么通过neigb我们可以得到其四个邻域像素的位置  
neigb = [ -1 0;  
          1  0;  
          0 -1;  
          0  1];  
 %开始进行区域生长，当所有待分析的邻域像素点和已经分割好的区域像素点的灰度值距离  
 %大于reg_maxdis,区域生长结束  

 
pgrow=num%栈指针
while num>0
     %判断seed数组是否为空，如果不为空，取出数组像素作为当前种子点继续下面的步骤
     x=SeedPoints(pgrow,1);%选取种子像素开始生长
     y=SeedPoints(pgrow,2);
     num=num-1 %种子像素点个数-1
     for j=1:4  
         xn = x + neigb(j,1);  
         yn = y + neigb(j,2);  
         %检查邻域像素是否超过了图像的边界  
         ins = (xn>=1)&&(yn>=1)&&(xn<=Isizes(1))&&(yn<=Isizes(1));  
         %如果邻域像素在图像内部，并且尚未分割好；那么将它添加到邻域列表中  
         if( ins && Jgrow(xn,yn)==0)  
             neg_pos = neg_pos+1;  
             neg_list(neg_pos,:) =[ xn, yn, I(xn,yn)];%存储对应点的灰度值  
             Jgrow(xn,yn) = 1;%标注该邻域像素点已经被访问过 并不意味着，他在分割区域内  
         end  
     end  
 

    %判断该候选像素点是否满足相似性准则
    if (abs(I0(x,y)-DensityValue)<=T)
        %若满足，将其添加到候选种子数组中，表示该方向可继续生长
        reg_size = reg_size + 1;  
        num=num+1
        pgrow=pgrow+1;
        SeedPoints(pgrow,1)=x;
        SeedPoints(pgrow,2)=y;
        Jgrow(x,y)=2;%标志该像素点已经是分割好的像素点  
        
    %计算区域的新的均值  
    %reg_mean = (reg_mean * reg_size +neg_list(index,3))/(reg_size + 1);  
   %如果分配的内存空问不够，申请新的内存空间  

    %将旧的种子点标记为已经分割好的区域像素点  
    
   % x = neg_list(index,1);  
   % y = neg_list(index,2);  
    index=index+1;
        if (neg_pos+10>neg_free)  
        neg_free = neg_free + 100000;  
        neg_list((neg_pos +1):neg_free,:) = 0;  
        end  
%     pause(0.0005);%动态绘制  
%     if(J(x,y)==2)  
%     plot(x,y,'r.');  
%     end  
    else
%若不满足分割阈值条件，将新的种子点从待分析的邻域像素列表中移除  
    neg_list(index,:) = neg_list(neg_pos,:);  
    neg_pos = neg_pos -1;  
    pgrow=pgrow-1;
    num=num-1
    end  
end
   
 Jgrow = (Jgrow==2);%我们之前将分割好的像素点标记为2  
 hold off;  
 subplot(2,2,2),imshow(Jgrow);  
 Jgrow = bwmorph(Jgrow,'dilate');%补充空洞  
 se = strel('disk',5);
 Jgrow = imdilate(Jgrow,se);
 subplot(2,2,3),imshow(Jgrow);  
 subplot(2,2,4),imshow(I+Jgrow);  
