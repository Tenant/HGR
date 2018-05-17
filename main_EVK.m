
close all; clear; clc

% 设置运行模式
mode=1; % mode=0 [video mode], mode==1 [camera mode]
visible=1;

if mode==0
    load EVK_nearVisionx5
    num=numel(frames);
    run('ParametersConfigration.m')
else
    num=inf; % ### 设置循环最多可以进行次数 precious=inf
    run('ParametersConfigration.m')
    run('EVKConfigration.m')
    [~, deviceHandle] = BTAopen(configStruct);
    status = setTOFParameters_KLI(deviceHandle, IntegrationTime, FrameRate, ModulationFrequency);  
end

figure;
figCount=numel(findobj(0, 'type', 'figure'));
isRunning=figCount;
frameCounter=1;

while(isRunning==figCount && frameCounter<num)
    if mode==0
        frame_t=frames{frameCounter};
    else
        [~, frameHandle, frame_t.frameCounter,  frame_t.timeStamp] = BTAgetFrame(deviceHandle, 500);
        [~,  frame_t.distData, ~, ~, ~] = BTAgetDistances(frameHandle);
        [~, frame_t.ampData, ~, ~, ~] = BTAgetAmplitudes(frameHandle);
        frame_t.distData=imresize(frame_t.distData, 0.5);
        frame_t.ampData=imresize(frame_t.ampData,0.5);
    end

    if frameCounter==1
        frame_ttt=frame_t;
        frameCounter=frameCounter+1;
        continue
    elseif frameCounter==2
        frame_tt=frame_t;
        config.bgs.background=frame_t.ampData;
        frameCounter=frameCounter+1;
        continue
    else
        % 计算手势区域蒙版
        [mask, config, imdMask, bgsMask, L]=getHandMask(frame_t, frame_tt, frame_ttt, config);
        frame_ttt=frame_tt;
        frame_tt=frame_t;
        
        % 显示分割结果
        if visible
            hs = tight_subplot(2, 2, [0.01, -0.4], [0.01, 0.01], [0.01, 0.01]);
            
            frame_t.ampData(frame_t.ampData<0)=0;
            img=uint8(frame_t.ampData/max(max(frame_t.ampData))*256);
            img=histeq(img, 256);
            
            axes(hs(1));  %#ok<*LAXES>
            dsp=mark(img, imdMask);
            imshow(rot90(dsp,1))
            
            axes(hs(2));
            dsp=mark(img, bgsMask);
            imshow(rot90(dsp,1))
            
            axes(hs(3));
            imshow(rot90(img,1));
            Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
            hold on
            himage = imshow(rot90(Lrgb,1));
            set(himage, 'AlphaData', 0.3);
            hold off
            
            axes(hs(4));
            dsp=mark(img, mask);
            imshow(rot90(dsp,1))
            
            title(['HandRegion #', num2str(frameCounter)]);
            drawnow
        end
        
        % 识别手势特征，给有效手势加个红边框
        
        
        % 输出运动方向
        mask=rot90(mask,1); % 测试样本缺陷纠正
        config.kf.dt=0.1;
        [direction_t, config]=estimateMove(mask, config);
        
        % 考虑运动连贯性
        if frameCounter==3
            direction_ttt=direction_t;
        elseif frameCounter==4
            direction_tt=direction_t;
        else
            if strcmp(direction_t, direction_tt) || strcmp(direction_ttt, direction_tt)
                fprintf(['# ', num2str(frameCounter),': ', direction_tt, '.\n']);
            else
                fprintf(['# ', num2str(frameCounter),': ', direction_t, '.\n']);
                direction_tt=direction_t;
            end
            direction_ttt=direction_tt;
            direction_tt=direction_t;
        end
        
        % 更新循环条件
        frameCounter=frameCounter+1;
        isRunning = numel(findobj(0,'type','figure'));
    end
end

% 退出前处理
if mode==1
    BTAclose(deviceHandle);
end
close
fprintf('Program Terminated !\n');