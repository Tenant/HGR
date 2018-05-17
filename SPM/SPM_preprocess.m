function []=SPM_preprocess()
    %
    % function data=SPM_preprocess()
    %
    % ���ļ����ж�ȡͼ�񣬲���ÿ�����ص�洢Ϊ[R, G, B, label]��ʽ��������
    % ����label==1��ʾ������Ϊ���ɫ����labelȥ����ֵ��ʾΪ�����ɫ����
    % ������ΪN*4�Ķ�ά���飬�洢��.mat�ļ���
    
    pathName = uigetdir('*.*','Please select a folder:');
    pathName=strcat(pathName,'\');
    files=dir(strcat(pathName, '*.bmp'));
    num=length(files);
    
    data_free = 10000; %��̬�����ڴ��ʱ��ÿ������������ռ��С  
    data_list = zeros(data_free,4); 
    data_pos = 0; %���ڼ�data_list�е�Ԫ�صĸ���
    
    for ii=1:num
        maskfile=strcat(pathName, files(ii).name);
        RGBfile=[maskfile(1: strfind(maskfile, '.')), 'jpg'];
        fprintf('%s (%d/%d)\n',RGBfile, ii, num); % ��ʾ���ڴ����ͼ��
        mask=imread(maskfile);
        RGB=imread(RGBfile);
        M=size(mask,1);
        N=size(mask,2);
        for x=1:M
            for y=1:N
                % ���data_listʣ��ռ�
                 if (data_pos+10>data_free)  
                    data_free = data_free + 100000;  
                    data_list((data_pos +1):data_free,:) = 0;  
                 end
                 
                 % ׷�Ӽ�¼
                 data_list(data_pos+1,:)=[RGB(x,y,1), RGB(x,y,2), RGB(x,y,3), mask(x,y)==1];
                 data_pos=data_pos+1;
            end
        end

    end
    data=data_list(1:data_pos,:);
    save Untitled data;
end