function [mask, IMD, BSB, SPM, testdata]=Hand_Region_Extract(img,IMD,BSB,SPM)
    % 
    % Hand Region Extract
    
    % Image Difference
    ROI_1=imDiff(IMD.frame_next_to, IMD.frame_next,img, IMD.Threshold);
    ROI_1=im2bw(ROI_1, graythresh(ROI_1));
    IMD.frame_next_to=IMD.frame_next;
    IMD.frame_next=img;
    
    % Background Substraction
    [im_out, BSB.bgd, BSB.Threshold]=bgdSub(img, BSB.bgd, BSB.learning_rate, BSB.Threshold);
    ROI_2=im2bw(im_out, graythresh(im_out));
    
    % skin-color Probability Map - Online Training
    % [SPM_on, numTable, skinPixels, nonskinPixels]=SPM_train_online(im_ROI, im_bgd, numTable, skinPixels, nonskinPixels);
    
    % Skin color classifier
    % lr=ii/FramesPerTrigger;
    % SPM=(1-lr)*SPM_off+lr*SPM_on;
    ROI_3=SPM_test_main(img, SPM.spm, SPM.Threshold);
    % P_skin=(1-lr)*P_skin_off+lr*P_skin_on;
    % P_nonskin=(1-lr)*P_nonskin_off+lr*P_nonskin_on;
    
    % Combination of Information
    [ROI_1, ROI_2, ROI_3, mask]=Region_based_Combination(ROI_1, ROI_2, ROI_3);
    
    % Region Growing Algorithm
    [x y]=find(mask==1);
    mask=Region_Growing_RGB(img, 0.09, x, y);
    
    testdata.ROI_1=ROI_1;
    testdata.ROI_2=ROI_2;
    testdata.ROI_3=ROI_3;

end