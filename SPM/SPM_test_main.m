function im_out=SPM_test_main(img, SPM, threshold)
global quantizationTable;
    quantizationTable = linspace(1,1,8);
    for i = 2 : 32
        quantizationTable = [quantizationTable, linspace(i,i,8)];
    end

        [x,y] = size(img(:,:,1));
        img=medfilt_RGB(img,[4,4]);
        img = changeTo32Level(img, x, y);
        mask = detect(img, SPM, x, y,threshold);
        im_out=mask;
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

function[mask] = detect(img, SPM, x, y,threshold)
    mask=zeros(x,y);
    mask=mask==1;
    for i = 1:x
        for j = 1:y
            if SPM(img(i,j,1),img(i,j,2),img(i,j,3)) >= threshold  %The threshold. Set it higher to be more exact but may cause more miss
                mask(i,j) = 1;
            end
        end
    end
end