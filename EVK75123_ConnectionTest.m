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

[status, deviceHandle] = BTAopen(configStruct);

status

BTAclose(deviceHandle);
fprintf('Program Terminated !\n');

close all;