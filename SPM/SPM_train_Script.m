% SPMѵ���ű�

%% Ԥ����
% ���ļ����ж�ȡͼ�񣬲���ÿ�����ص�洢Ϊ[R, G, B, label]��ʽ��������
% ����label==1��ʾ������Ϊ���ɫ����labelȥ����ֵ��ʾΪ�����ɫ����
% ������ΪN*4�Ķ�ά���飬�洢��.mat�ļ���


%% ���Ȼ���Skin_NonSkin.matѵ��SPM
% load Skin_NonSkin
% spm_matrix=SPM_train_dataset(Skin_NonSkin);
% save spm_matrix spm_matrix
%% �Ա�Skin_NonSkin.mat��ѵ�������SPM_Data_Set��ѵ������
img=data(:,:,:,1);
subplot(1,2,1); imshow(img);
mask=SPM_test_main(img,spm_matrix, 0.02);
dsp=mark(img, mask);
subplot(1,2,2); imshow(dsp);