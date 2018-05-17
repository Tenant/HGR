function Positive_Raw_Data=getHOG2()
        files=dir('*.bmp');
        num=numel(files);
        
        Positive_Raw_Data=cell(1,num);
        
        figure
        for ii=1:num
            maskfile=files(ii).name;
            RGBfile=['E:\Document\Git\HGR\SPM_Data_Set\', maskfile(1: strfind(maskfile, '.')), 'jpg'];
            mask=imread(maskfile);
            RGB=imread(RGBfile);
            gray=rgb2gray(RGB);
            gray(mask)=0;
            gray=imresize(gray, [320 240]);
            Positive_Raw_Data{ii}=gray;
            imshow(gray);
            drawnow
        end

end
