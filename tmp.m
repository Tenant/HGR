    load EVK_farVision
    num=numel(frames);
    
    figure;
    for ii=2:num
        Diff=frames{ii}.ampData-frames{ii-1}.ampData;
        imagesc(Diff, [-40 40]);
         title(['frameCounter=', num2str(ii)]);
        drawnow
        pause(0.2);
    end
    
    %% bgdSub 测试
    load EVK_farVision
    num=numel(frames);
    
    background=frames{1}.ampData;
    threshold=zeros(size(background))+3;
    
    figure;
    for ii=2:num
        [mask, background, threshold]=bgdSub(frames{ii}.ampData, background, 0.75, threshold);
        imshow(mask);
        title(['frameCounter=', num2str(ii)]);
%         imagesc(background, [0 40]);
%         imagesc(threshold, [0 20]);
        drawnow
        pause(0.2);
    end
    
  
      %%
    load EVK_farVision
    num=numel(frames);
    
    for ii=3:12
        frame_t=frames{ii};
        frame_t.ampData(frame_t.ampData<0)=0;
        img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
        img=histeq(img, 256);
        mask=getRGmask(img, 0.08);
        mask=rot90(mask,1);
        imshow(mask)
        P=regionprops(mask, 'All');
        P.Centroid
        pause(1)
    end
%% 绘制视频帧中的深度图和灰度图
load EVK_nearVision
frame_t=frames{1};

figure;
subplot(1,2,1);
imagesc(rot90(frame_t.distData,1), [0 1500]);
subplot(1,2,2);
frame_t.ampData(frame_t.ampData<0)=0;
img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
img=histeq(img, 256);
imagesc(rot90(img,1), [0 255])
%% 绘制[100 1500]范围对背景的效果
load EVK_nearVision
frame_t=frames{1};

figure
mask=bitand(frame_t.distData>100, frame_t.distData<1500);
frame_t.ampData(frame_t.ampData<0)=0;
img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
img=histeq(img, 256);
imshow(rot90(img,1))
hold on
Lrgb=label2rgb(~mask, 'jet', 'w', 'shuffle');
himage=imshow(rot90(Lrgb,1));
set(himage, 'AlphaData', 0.8);
%% 计算前32帧图像中手势区域所包含像素数
load EVK_nearVision

cnt=zeros(1,32);
masks=cell(1,32);
for ii=3:32
    frame_t=frames{ii};
    frame_t.ampData(frame_t.ampData<0)=0;
    img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
    img=histeq(img, 256);
    mask=getRGmask(img,0.08);
    masks{ii}=mask;
    imshow(mask);
    pause(1)
    cnt(ii)=sum(sum(mask));
end
%% 201805131441, 201805131442, 
% 计算config.imd.threshold
load EVK_nearVision
load EVK_nearVision_A前32帧手掌区域包含像素数

table=[4 5 6 7 8 9];
positive=zeros(6,30);
negative=zeros(6,30);
frame_ttt=frames{1};
frame_tt=frames{2};

figure
for ii=3:32
    frame_t=frames{ii};
    fprintf(['Frame ', num2str(ii), '\n']);
    for k=1:6
        t=table(k);
        mask=imDiff(frame_ttt.ampData, frame_tt.ampData, frame_t.ampData, t);
        template=masks{ii};
        p=sum(sum(bitand(mask,template)));
        n=sum(sum(bitand(mask,~template)));
        fprintf(['threshold=', num2str(table(k)), '    ', 'p=', num2str(p), '    ', 'cnt=', num2str(cnt(ii)), '\n']);
        positive(k,ii-2)=p/cnt(ii);
        negative(k,ii-2)=n/(320*240-cnt(ii));
    end
    imshow(mask)
    
    drawnow
    pause(1)
    frame_ttt=frame_tt;
    frame_tt=frame_t;
end
%% 201805131459
load EVK_nearVision
frame_t=frames{6}
frame_t.ampData(frame_t.ampData<0)=0;
img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
img=histeq(img, 256);
img=rot90(img,1);
subplot(1,2,1);
imshow(img);
subplot(1,2,2);
imshow(rot90(mask,3))
%% [201805131542] [201805131546] [201805131618] [201805131614] [201805131644]
% 计算config.bgs.threshold
load EVK_nearVision
load EVK_nearVision_A前32帧手掌区域包含像素数

table=[2 4 6 8 10 12];
table2=[0.5 0.55 0.6 0.65 0.7 0.75 0.8];
% positive=zeros(6,30);
% negative=zeros(6,30);
bgd=frames{2}.ampData;
a=0.75;

k=3;
t=zeros(size(bgd))+table(k);
% bgs_mask=cell(1,32);

k2=7;

figure
for ii=3:32
    frame_t=frames{ii};
    fprintf(['Frame ', num2str(ii), '\n']);
    [mask, bgd, t]=bgdSub(frame_t.ampData, bgd, table2(k2), t);
    template=masks{ii};
    imshow(mask)
%     bgs_mask{ii}=mask;
    drawnow
    p=sum(sum(bitand(mask,template)));
    n=sum(sum(bitand(mask,~template)));
    fprintf(['threshold=', num2str(table2(k2)), '    ', 'p=', num2str(p), '    ', 'cnt=', num2str(cnt(ii)), '\n']);
    positive(k2,ii-2)=p/cnt(ii);
    negative(k2,ii-2)=n/(320*240-cnt(ii));
    
end
%% 201805131644
% 此段代码需要在前一段代码运行后运行
hs = tight_subplot(3, 3, [0.01, -0.4], [0.01, 0.01], [0.01, 0.01]);
for ii=1:9
    axes(hs(ii));
    imshow(rot90( bgs_mask{ii*2+1}, 1));
end
%% 201805131856 201805131903
load EVK_nearVision
load EVK_nearVision_A前32帧手掌区域包含像素数

table=[0.04 0.06 0.08 0.10 0.12];

postive=zeros(5,30);
negative=zeros(5,30);

odd=cell(1,32);

figure
for ii=3:32
    frame_t=frames{ii};
    frame_t.ampData(frame_t.ampData<0)=0;
    img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
    img=histeq(img, 256);
    template=masks{ii};
    for k=5
        L=getRGmask4(img, table(k), template);
        mask=selectLayer(L, template);
        p=sum(sum(bitand(mask,template)));
        n=sum(sum(bitand(mask,~template)));
        fprintf(['threshold=', num2str(table(k)), '    ', 'p=', num2str(p), '    ', 'cnt=', num2str(cnt(ii)), '\n']);
        positive(k,ii-2)=p/cnt(ii);
        negative(k,ii-2)=n/(320*240-cnt(ii));
        imshow(mask);
        odd{ii}=mask;
        drawnow
        pause(0.5)
    end
    
    end

%% 2018051319
% 此段代码需要在前一段代码运行后运行
hs = tight_subplot(3, 3, [0.01, -0.4], [0.01, 0.01], [0.01, 0.01]);
for ii=24:32
    axes(hs(ii-23));
    imshow(rot90( odd{ii}, 1));
end
%%
% 计算手势区域特征向量
% load EVK_nearVision
% load EVK_nearVision_A_HOG

num=numel(frames);
P4_=zeros(num,4608);

figure
for ii=1:num
    frame_t=frames{ii};
    frame_t.ampData(frame_t.ampData<0)=0;
    img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
    img=histeq(img, 256);
    img=rot90(img,1);
%     img=Negative_Raw_Data{ii};
    img(~mask{ii})=0;
    [vector,visualization] = extractHOGFeatures(img,'CellSize',[16 16], 'BlockSize', [8 8]);
    P4_(ii,:)=vector;
    subplot(1,2,1)
    imshow(img)
    subplot(1,2,2)
    plot(visualization);
    drawnow
end
%% 201805140913
% 绘制部分图像的HOG描述子图像
load EVK_nearVison_A_HOG
hs = tight_subplot(6, 5, [0.01, -0.4], [0.01, 0.01], [0.01, 0.01]);
for ii=1:30
    axes(hs(ii));
    plot(ttt{ii})
end
%% 201805140949
% 绘制部分HOG描述子的部分训练数据
% load EVK_nearVison_A_HOG
hs = tight_subplot(6, 5, [0.01, -0.4], [0.01, 0.01], [0.01, 0.01]);
for ii=1:30
    axes(hs(ii));
    imshow(Negative_Raw_Data{ii*10})
end
%% 201805141005
% 绘制部分HOG描述子的训练数据
% load EVK_nearVison_A_HOG
hs = tight_subplot(6, 5, [0.01, -0.4], [0.01, 0.01], [0.01, 0.01]);
for ii=1:30
    axes(hs(ii));
    imshow(Positive_Raw_Data{ii})
end
%%
% 主成分分析
% load EVK_nearVison_A_HOG
% load EVK_nearVison_A_HOG_
X=[P6;N6];
[X_norm, mu, sigma] = featureNormalize(X);
[wcoeff,score,latent,~,explained] = pca(X_norm,'VariableWeights','variance');

total=zeros(1,numel(explained));
total(1)=explained(1);
for ii=2:numel(explained)
    total(ii)=total(ii-1)+explained(ii);
end
plot(total)
%%
% 绘制total曲线
figure
plot(E1.total);
hold on
plot(E2.total)
plot(E3.total)
plot(E4.total)
plot(E5.total)
plot(E6.total)
%%
% SVM learing curve
rate6=zeros(1,319);
E=E6;
figure
for n=1:319
    p=150;
    X=[E.score(1:n,1:p); E.score(321:320+n,1:p)];
    T=[E.score(n+1:320,1:p); E.score(321+n:640,1:p)];
    Y=zeros(2*n,1);
    Y(1:n)=1;
    Y=Y==1;
    M=fitcsvm(X,Y,'KernelFunction','RBF','Standardize', true,'KernelScale','auto');
    y=predict(M,T);
    plot(y, 'rx')
    drawnow
    rate6(n)=1-(sum(y(1:320-n)~=1)+sum(y(320-n+1:640-2*n)~=0))/640;
end
close
%% 压缩frames大小
load EVK_farVision
num=numel(frames);
for ii=1:num
    frames{ii}.distData=imresize(frames{ii}.distData, 0.5);
    frames{ii}.ampData=imresize(frames{ii}.ampData, 0.5);
    ii
end
