% EVK Tool for MLX75123 Connection with Host Matlab using TCP
% Reference: https://support.bluetechnix.at/wiki/BltTofApi_Matlab_SDK
%% Initialization
[status, configStruct] = BTAinitConfig;

%% Connection Parameters
configStruct.udpDataIpAddr = [224, 0, 0, 1];
configStruct.udpDataIpAddrLen = 4;
configStruct.udpDataPort = 10002;
configStruct.tcpDeviceIpAddr = [192, 168, 0, 10];
configStruct.tcpDeviceIpAddrLen = 4;
configStruct.tcpControlPort = 10001;
configStruct.frameQueueMode = 1;
configStruct.frameQueueLength = 5;

%% Frame Mode Parameter
configStruct.frameMode = 1;

% Possible frame modes:
% 1 每 Distances and amplitudes 
% 2 每 Distance, amplitudes and flags (only supported by USB based devices)
% 3 - XYZ coordinates 
% 4 每 XYZ coordinates and amplitudes 
% 5 每 Distances, amplitudes and 2D color (only supported by Ethernet based devices)
% 6 - XYZ coordinates, amplitudes and flags (only supported by USB based devices)
% 7 每 Raw Phases
% 8 每 Intensities (only supported by USB based devices)

%% Connecting
[status, deviceHandle] = BTAopen(configStruct);

%% Querying Device Information
[status, deviceType, productOrderNumber, serialNumber, firmwareVersion] = BTAgetDeviceInfo(deviceHandle);

% Output parameter:
% deviceType           - Device type
% 			 0xA9C1 每 Sentis-ToF-M100
% 			 0xB320 每 Argos 3D P320
% 			 0x9BA6 每 Argos 3D P310
% 			 0xA3C4 每 Argos 3D P100
% productOrderNumber   - Product order number of the device
% serialNumber         - Serial number of the device
% firmwareVersion      - Firmware version

%% Get Frame Rate
[status, frameRate] = BTAgetFrameRate(deviceHandle); 

%% Set Frame Rate
status = BTAsetFrameRate(deviceHandle, frameRate);

%% Set Frame Mode
status = BTAsetFrameMode(deviceHandle, frameMode);

% Input parameter:
% 
% deviceHandle         - Device handle
% frameMode            - The desired frame mode
%                         1 每 Distances and amplitudes 
%                         2 每 Distance, amplitudes and flags	(only supported by USB based devices)
%                         3 - XYZ coordinates 
%                         4 每 XYZ coordinates and amplitudes 
%                         5 每 Distances, amplitudes and 2D color (only supported by Ethernet based devices)
%                         6 - XYZ coordinates, amplitudes and flags (only supported by USB based devices)
%                         7 每 Raw Phases
%                         8 每 Intensities (only supported by USB based devices)
                        
%% Frame Retrieval
[status, frameHandle, frameCounter, timeStamp] = BTAgetFrame(deviceHandle, timeout);

% Input parameter:
% 
% deviceHandle         - Device handle
% timeout              - Timeout to wait if no frame is yet available in [ms]. If timeout = 0 the function waits endlessly for a frame.
% 
% Output parameter:
% 
% status               - Error code for error handling. Refer to BltTofApi Error Codes
% frameHandle          - Frame handle (needs to be free＊d with BTAfreeFrame)

%% Frame Cleanup
[status] = BTAfreeFrame(frameHandle);

%% Get Distances
[status, distData, integrationTime, modulationFrequency, unit] = BTAgetDistances(frameHandle);

% Output parameter:
% 
% status               - Error code for error handling. Refer to BltTofApi Error Codes
% distData             - Array which contains the distances data.
% integrationTime      - Integration time
% modulationFrequency  - Modulation frequency
% unit                 - Unit of the data.
% 			 0 每 unitless
% 			 1 每 meter
% 			 2 - centimeter
% 			 3 - millimeter

%% Get Amplitudes
[status, ampData, integrationTime, modulationFrequency, unit] = BTAgetAmplitudes(frameHandle);

% Output parameter:
% 
% status               - Error code for error handling. Refer to BltTofApi Error Codes
% ampData              - Array which contains the amplitudes data.
% integrationTime      - Integration time
% modulationFrequency  - Modulation frequency
% unit                 - Unit of the data.
% 			 0 每 unitless
% 			 1 每 meter
% 			 2 - centimeter
% 			 3 - millimeter

%% Get XYZ Coordinates
[status, xData, yData, zData, integrationTime, modulationFrequency, unit] =  BTAgetXYZcoordinates(frameHandle);

% Output parameter:
% 
% status               - Error code for error handling. Refer to BltTofApi Error Codes
% xData                - Array which contains the cartesian x coordinates.
% yData                - Array which contains the cartesian y coordinates.
% zData                - Array which contains the cartesian z coordinates.
% integrationTime      - Integration time
% modulationFrequency  - Modulation frequency
% unit                 - Unit of the data.
% 			 0 每 unitless
% 			 1 每 meter
% 			 2 - centimeter
% 			 3 - millimeter

%% Get Color Sensor Data
% NOTE: This function is supported only by Ethernet based devices.
[status, colorData2D, integrationTime, modulationFrequency, unit] = BTAget2DData(frameHandle);

% Output parameter:
% 
% status               -	  0 	Success
%  	                  -15	The given frame does not contain phase data
%                           1     The frame mode is selected correctly but the given frame doesn't contain 2D color data. 
%                                The reason for this are different frame rates of the ToF and the 2D sensor.
% -1	The given handle is not valid
% 
% colorData2D          - Array which contains the 2D color data
% integrationTime      - Integration time
% modulationFrequency  - Modulation frequency
% unit                 - Unit of the data.
% 			 0 每 unitless
% 			 1 每 meter
% 			 2 - centimeter
% 			 3 - millimeter

%% Get Intensities
% NOTE: This function is supported only by USB based devices.
[status, intensities, integrationTime, modulationFrequency, unit] = BTAgetIntensities(frameHandle);

% Output parameter:
% 
% status               -	  0 	Success
% 			  -15	The given frame does not contain phase data
% 			  -1	The given handle is not valid	
% intensities          - Array which contains intensities
% integrationTime      - Integration time
% modulationFrequency  - Modulation frequency
% unit                 - Unit of the data.
% 			 0 每 unitless
% 			 1 每 meter
% 			 2 - centimeter
% 			 3 - millimeter

%% Save current configuration
[status] = BTAwriteCurrentConfigToNvm(deviceHandle);

%% Restore default configuration
% NOTE: This function is supported only by Ethernet based devices.
[status] = BTAwriteCurrentConfigToNvm(deviceHandle);

%% Reset Device
% NOTE: This function is supported only by Ethernet based devices.
[status] = BTAsendReset(deviceHandle);

%% Disconnecting
status = BTAclose(deviceHandle);