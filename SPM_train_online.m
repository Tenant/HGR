function [SPM_on, numTable, skinPixels, nonskinPixels]=SPM_train_online(im_ROI, im_bgd, numTable, skinPixels, nonskinPixels)
% 突破点：设计一个近似、高效的online skincolor map training算法
global quantizationTable;
    SPM_on(1:32, 1:32, 1:32) = 0;
    quantizationTable = linspace(1,1,8);
    for i = 2 : 32
        quantizationTable = [quantizationTable, linspace(i,i,8)];
    end
    % record Pixels - ROI
    colourPixels = im_ROI(:,:,4) ~= 0;
    [x,y] = size(colourPixels);
    img = changeTo32Level(im_ROI, x, y);
    skinPixels =skinPixels+ sum(sum(colourPixels));
    for j = 1:x
        for k = 1:y
            if colourPixels(j,k) ~= 0
                R = img(j,k,1);
                G = img(j,k,2);
                B = img(j,k,3);
                numTable(1, R, G, B) = numTable(1, R, G, B) + 1;
            end
        end
    end
    % record Pixels - background
    colourPixels = im_bgd(:,:,4) ~= 0;
    [x,y] = size(colourPixels);
    img = changeTo32Level(im_bgd, x, y);
    nonskinPixels =nonskinPixels+ sum(sum(colourPixels));
    for j = 1:x
        for k = 1:y
            if colourPixels(j,k) ~= 0
                R = img(j,k,1);
                G = img(j,k,2);
                B = img(j,k,3);
                numTable(2, R, G, B) = numTable(2, R, G, B) + 1;
            end
        end
    end
    
    % calcualte SPM
    Pskin = skinPixels/(skinPixels + nonskinPixels);
    Pnonskin = nonskinPixels/(skinPixels + nonskinPixels);
    for R = 1 : 32
        for G = 1 : 32
            for B = 1 : 32
                Pcskin = numTable(1, R, G, B)/skinPixels;
                Pcnonskin = numTable(2, R, G, B)/nonskinPixels;
                p1 = Pcskin*Pskin;
				p2 = Pcnonskin/Pnonskin;
				if p1~=0 && p2~=0
				    SPM_on(R, G, B) = p1 / p2;
				end
            end
        end
    end
    
end

function[img] = changeTo32Level(img, x, y)
    global quantizationTable;
    for i = 1:x
        for j = 1:y
            img(i,j,1) = quantizationTable(img(i,j,1)+1);
            img(i,j,2) = quantizationTable(img(i,j,2)+1);
            img(i,j,3) = quantizationTable(img(i,j,3)+1);
        end
    end
end