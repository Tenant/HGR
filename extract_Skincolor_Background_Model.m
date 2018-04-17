function mask=extract_Skincolor_Background_Model(im_bgd, SPM, threshold_SPM)
    % 
    % function mask=extract_Skincolor_Background_Model(im_bgd, SPM, threshold)
    %
    % Input: im_bgd- The determined background image in the Background
    %          Substraction.
    %          SPM: Skin-color Probability Map
    %          threshold_SPM: the threshold to determine the skincolor-like region
    % Output: mask for the skincolor background
    
    ps_mask=SPM_test_main(im_bgd, SPM, threshold_SPM);
    
    

end