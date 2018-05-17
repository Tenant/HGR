function spm=SPM_train_dataset(data)
    %
    % function spm_matrix=SPM_train_dataset(data)
    %
    % dataΪN*4����ÿ��Ϊһ����Ч����[]R, G,B, label]
    % ����label==1��ʾ������Ϊ���ɫ����labelȥ����ֵ��ʾΪ�����ɫ����
    % ����ʵ����
    % load Skin_NonSkin
    % spm_matrix=SPM_train_dataset(Skin_NonSkin);
    % save spm_matrix spm_matrix
    
    length=size(data,1);
    
    quantizationTable=zeros(1,256);
    for ii=1:32
        quantizationTable((ii-1)*8+1:ii*8)=linspace(ii,ii,8);
    end
    
    numTable=zeros(2,32,32,32);
    skinPixels=0;
    nonskinPixels=0;
    spm=zeros(32,32,32);
    
    for ii=1:length
        R=quantizationTable(data(ii,1)+1);
        G=quantizationTable(data(ii,2)+1);
        B=quantizationTable(data(ii,3)+1);
        
        if data(ii,4)==1 % label=1��ʾ��entryΪ��ɫ��
            numTable(1,R,G,B)=numTable(1,R,G,B)+1;
            skinPixels=skinPixels+1;
        else % label!=1��ʾ��entryΪ�Ƿ�ɫ��
            numTable(2,R,G,B)=numTable(2,R,G,B)+1;
            nonskinPixels=nonskinPixels+1;
        end
    end
    
    Pskin=skinPixels/(skinPixels+nonskinPixels);
    Pnonskin=1-Pskin;
    
    for R=1:32
        for G=1:32
            for B=1:32
                Pcskin=numTable(1,R,G,B)/skinPixels;
                Pcnonskin=numTable(2,R,G,B)/nonskinPixels;
                p1=Pcskin*Pskin;
                p2=Pcnonskin/Pnonskin;
                if p1~=0 && p2~=0
                    spm(R,G,B)=p1/p2;
                elseif p1~=0
                        spm(R,G,B)=100;
                else
                        spm(R,G,B)=0;
                end
            end
        end
    end
    
end