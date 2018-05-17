% This example program was developed based on the Matlab SDK provided with
% EVK75123. It has been verified in Matlab 2016b (x64) 9.1.0.441655
% It might be possible that some functions in different versions are
% not supported. The goal of this script is to calculate the amplitude and
% distance data out of the raw sensor data and visualize these images.
% Pixel binning (spatial averaging) is also supported.
% Author : KLI           Version : v2.2
% Support? -> contact tof3d@melexis.com

% 20 files are needed (in the same folder) to run this program correctly:
% 1- binArray.m
% 2- BltTofApi.dll
% 3- BltTofApi.lib
% 4- BTAclose.mexw64
% 5- BTAfreeFrame.mexw64
% 6- BTAgetChannelData.mexw64
% 7- BTAgetFrame.mexw64
% 8- BTAgetMetaData.mexw64 *optional*
% 9- BTAinitConfig.mexw64
% 10- BTAopen.mexw64
% 11- BTAreadRegister.mexw64
% 12- BTAwriteRegister.mexw64
% 13- EVK75123_Visualizer.m (= main routine)
% 14- jpeg62.dll
% 15- libusb0.dll
% 16- opencv_world310.dll
% 17- pthreadVC2.dll
% 18- setTOFParameters_KLI.m
% 19- turbojpeg.dll
% 10- TwoComp_KLI.m

close all;clear;clc;
fprintf('Program Started !\n');

IntegrationTime = 250; % in range [0 600]
FrameRate = 25; % in range [0 60]
ModulationFrequency = 20; % in range [12 16 20 24 28 32 36 40]

%Binning = spatial averaging on the raw data.
BinH = 1; %Group of x columns
BinV = 1; %Group of x rows

AmplitudeScaleMin = 0;
AmplitudeScaleStepSize = 10;
AmplitudeScaleMax = 100;

DistanceScaleMin = 0;
DistanceScaleStepSize = 250; % 250
DistanceScaleMax = 3000; % 3000
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DO NOT CHANGE ANYTHING BELOW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if mod(240,BinV) ~= 0 || mod(320,BinH) ~= 0
    fprintf('Error: Unvalid value for binning\n');
    Errmsg = 'Error : Unvalid value for binning';
    errordlg(ErrMsg); fprintf('Program Terminated!\n'); BTAclose(deviceHandle); return;
end

[~, configStruct] = BTAinitConfig;
configStruct.udpDataIpAddr = [224, 0, 0, 1];
configStruct.udpDataIpAddrLen = 4;
configStruct.udpDataPort = 10002;
configStruct.tcpDeviceIpAddr = [192, 168, 0, 10];
configStruct.tcpDeviceIpAddrLen = 4;
configStruct.tcpControlPort = 10001;
configStruct.frameQueueMode = 1;
configStruct.frameQueueLength = 5;
configStruct.deviceType = 1;

[~, deviceHandle] = BTAopen(configStruct);

BTAwriteRegister(deviceHandle, 4, hex2dec('00C0')); %Enable RAW data mode
[~, DistOffset00] = BTAreadRegister(deviceHandle, hex2dec('00C1'));
DistOffset00 = TwoComp_KLI(DistOffset00,16);

status = setTOFParameters_KLI(deviceHandle, IntegrationTime, FrameRate, ModulationFrequency);
if status ~= 0
    fprintf('Error: setTOFParameters_KLI failed\n');
    ErrMsg = 'Error: setTOFParameters_KLI failed';
    errordlg(ErrMsg); fprintf('Program Terminated!\n'); BTAclose(deviceHandle); return;
end

figAmplitude = figure('Name','Amplitude or Confidence Image','NumberTitle','off');
set(figAmplitude, 'Position', [50, 300, 700, 500]);
clim = [AmplitudeScaleMin AmplitudeScaleMax];
imAmplitude = imagesc(round(rand(240/BinV, 320/BinH)*clim(2)),clim);
colormap(gray);
cbr = colorbar;
set(cbr,'YTick',clim(1):AmplitudeScaleStepSize:clim(2))
set(gca,'XAxisLocation','top');
set(gca,'XTick',0:ceil(320/BinH/8):320/BinH);
set(gca,'YTick',0:ceil(240/BinV/6):240/BinV);
set(gca,'TickDir','out');
axis vis3d;

figDistance = figure('Name','Distance Image','NumberTitle','off');
set(figDistance, 'Position', [850, 300, 700, 500]);
clim = [DistanceScaleMin DistanceScaleMax];
imDistance = imagesc(round(rand(240/BinV, 320/BinH)*clim(2)),clim);
colormap(hsv);
cbr = colorbar;
set(cbr,'YTick',clim(1):DistanceScaleStepSize:clim(2))
set(gca,'XAxisLocation','top');
set(gca,'XTick',0:ceil(320/BinH/8):320/BinH);
set(gca,'YTick',0:ceil(240/BinV/6):240/BinV);
set(gca,'TickDir','out');
axis vis3d;

figCount = numel(findobj(0,'type','figure'));
isRunning = figCount;
while(isRunning == figCount)
    [status, frameHandle,  frameCounter, timeStamp] = BTAgetFrame(deviceHandle, 500);
    if status == 0
        [~, phase0, ~, ~, ~, ~] = BTAgetChannelData(frameHandle, 0);
%         This section gets the MetaData, MLX75023 Test Rows or MLX75123 ADC Test Line data for the first phase(but only if enabled in registers!)
%         [status, MetaData1, ~] = BTAgetMetadata(frameHandle, 0, hex2dec('A720B906'));
%         if (status == 0); MetaData1 = typecast(uint8(MetaData1),'uint16'); MetaData1 = bitshift(MetaData1,-4); end
%         [status, MetaData2, ~] = BTAgetMetadata(frameHandle, 0, hex2dec('A720B907')); 
%         if (status == 0); MetaData2 = typecast(uint8(MetaData2),'uint16'); MetaData2 = bitshift(MetaData2,-4); end
%         [status, MLXTestRows, ~] = BTAgetMetadata(frameHandle, 0, hex2dec('A720B908'));
%         if (status == 0); MLXTestRows = typecast(uint8(MLXTestRows),'uint16'); MLXTestRows = bitshift(MLXTestRows,-4); MLXTestRows = reshape(MLXTestRows,320,8)'; end
%         [status, ADCTestLine, ~] = BTAgetMetadata(frameHandle, 0, hex2dec('A720B909'));
%         if (status == 0); ADCTestLine = typecast(uint8(ADCTestLine),'uint16'); ADCTestLine = bitshift(ADCTestLine,-4); end
        [~, phase180, ~, ~, ~, ~] = BTAgetChannelData(frameHandle, 1);
        [~, phase90, ~, ~, ~, ~] = BTAgetChannelData(frameHandle, 2);
        [~, phase270, channelID, integrationTime, modulationFrequency, unit] = BTAgetChannelData(frameHandle, 3);         
        BTAfreeFrame(frameHandle);
    end
    
    p0 = TwoComp_KLI(phase0,16);
    p180 = TwoComp_KLI(phase180,16);
    p90 = TwoComp_KLI(phase90,16);
    p270 = TwoComp_KLI(phase270,16);
        
    p0 = binArray(p0, BinV, BinH);
    p180 = binArray(p180, BinV, BinH);
    p90 = binArray(p90, BinV, BinH);
    p270 = binArray(p270, BinV, BinH);
       
    I = p0 - p180;
    Q = p90 - p270;
    
    ampData = sqrt(I.^2 + Q.^2);
    Phase = atan2(Q, I);
    coef_rad = (0.5*299792458/modulationFrequency)*1000 / (2*pi); % 1deg = 20.81mm @20 MHz
    distData = Phase * coef_rad + DistOffset00;  

    set(imAmplitude,'CData',ampData);
    set(imDistance,'CData',distData);
    
    pause(0.01);
    isRunning = numel(findobj(0,'type','figure'));
end

BTAwriteRegister(deviceHandle, 4, hex2dec('0000')); %Enable DistAmp mode
BTAclose(deviceHandle);
fprintf('Program Terminated !\n');
close all;