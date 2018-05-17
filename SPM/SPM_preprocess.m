function []=SPM_preprocess()
    %
    % function data=SPM_preprocess()
    %
    % 从文件夹中读取图像，并将每个像素点存储为[R, G, B, label]形式的行向量
    % 其中label==1表示该区域为类肤色区域，label去其他值表示为非类肤色区域
    % 处理结果为N*4的二维数组，存储到.mat文件中
    
    pathName = uigetdir('*.*','Please select a folder:');
    pathName=strcat(pathName,'\');
    files=dir(strcat(pathName, '*.bmp'));
    num=length(files);
    
    data_free = 10000; %动态分配内存的时候每次申请的连续空间大小  
    data_list = zeros(data_free,4); 
    data_pos = 0; %用于记data_list中的元素的个数
    
    for ii=1:num
        maskfile=strcat(pathName, files(ii).name);
        RGBfile=[maskfile(1: strfind(maskfile, '.')), 'jpg'];
        fprintf('%s (%d/%d)\n',RGBfile, ii, num); % 显示正在处理的图像
        mask=imread(maskfile);
        RGB=imread(RGBfile);
        M=size(mask,1);
        N=size(mask,2);
        for x=1:M
            for y=1:N
                % 检测data_list剩余空间
                 if (data_pos+10>data_free)  
                    data_free = data_free + 100000;  
                    data_list((data_pos +1):data_free,:) = 0;  
                 end
                 
                 % 追加记录
                 data_list(data_pos+1,:)=[RGB(x,y,1), RGB(x,y,2), RGB(x,y,3), mask(x,y)==1];
                 data_pos=data_pos+1;
            end
        end

    end
    data=data_list(1:data_pos,:);
    save Untitled data;
end