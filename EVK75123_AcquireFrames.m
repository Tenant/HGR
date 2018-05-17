% EVK Tool for MLX75123 Connection with Host Matlab using TCP
% Reference: https://support.bluetechnix.at/wiki/BltTofApi_Matlab_SDK

clear;
fprintf('Program Started !\n');

num=320; % set the number of frames you want to acquire
frames=cell(1,num);

IntegrationTime = 250; % in range [0 600]
FrameRate = 25; % in range [0 60]
ModulationFrequency = 20; % in range [12 16 20 24 28 32 36 40]

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

status = setTOFParameters_KLI(deviceHandle, IntegrationTime, FrameRate, ModulationFrequency);
if status ~= 0
    fprintf('Error: setTOFParameters_KLI failed\n');
    ErrMsg = 'Error: setTOFParameters_KLI failed';
    errordlg(ErrMsg); fprintf('Program Terminated!\n'); BTAclose(deviceHandle); return;
end

figure;
for ii=1:num
    [~, frameHandle, frames{ii}.frameCounter,  frames{ii}.timeStamp] = BTAgetFrame(deviceHandle, 500);
    [~,  frames{ii}.distData.data, frames{ii}.distData.integrationTime, frames{ii}.distData.modulationFrequency, frames{ii}.distData.unit] = BTAgetDistances(frameHandle);
    [~, frames{ii}.ampData.data, frames{ii}.ampData.integrationTime, frames{ii}.ampData.modulationFrequency, frames{ii}.ampData.unit] = BTAgetAmplitudes(frameHandle);
    subplot(1,2,1); imagesc(frames{ii}.distData.data, [0 700]);
    subplot(1,2,2); imagesc(frames{ii}.ampData.data, [0 700]);
    drawnow
%     pause(0.1);
end

BTAclose(deviceHandle);
fprintf('Program Terminated !\n');