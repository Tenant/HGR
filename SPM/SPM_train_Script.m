% SPM训练脚本

%% 预处理
% 从文件夹中读取图像，并将每个像素点存储为[R, G, B, label]形式的行向量
% 其中label==1表示该区域为类肤色区域，label去其他值表示为非类肤色区域
% 处理结果为N*4的二维数组，存储到.mat文件中


%% 首先基于Skin_NonSkin.mat训练SPM
% load Skin_NonSkin
% spm_matrix=SPM_train_dataset(Skin_NonSkin);
% save spm_matrix spm_matrix
%% 对比Skin_NonSkin.mat的训练结果和SPM_Data_Set的训练差异
img=data(:,:,:,1);
subplot(1,2,1); imshow(img);
mask=SPM_test_main(img,spm_matrix, 0.02);
dsp=mark(img, mask);
subplot(1,2,2); imshow(dsp);