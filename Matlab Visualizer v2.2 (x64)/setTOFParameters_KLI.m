% Author: kli@melexis.com
% Version : 2.0_19/06/2017
% - added support for ModulationFrequency
% - added protection of parameters out of limit
% For use with MATLAB VERSION 2016b

function output = setTOFParameters_KLI(deviceHandle, newTint, newFPS, newFMOD)
    FMOD_Array = 12:4:40; %List of possible modulation frequencies
    if ((newTint < 0) || (newTint > 600) || (newFPS < 1) || (newFPS > 60) || (sum(find(FMOD_Array==newFMOD)) == 0))
       fprintf('SetTOFParameters_KLI : Failed! (value out of range)\n');
       output = -1; return;
    end

    % Find active FrameTable
    [~, ADC_DELAY_FT] = BTAreadRegister(deviceHandle, hex2dec('1010')); %READ ADC_DELAY_FT
    ADC_DELAY_FT = dec2bin(ADC_DELAY_FT,16);
    ActiveFT = ADC_DELAY_FT(16);
    
    % Set the register maps for the FrameTable(s)
    if ActiveFT == '0'
        Addr_Act_Start = '1012'; Addr_Act_End = '1092'; %FrameTable 1
        Addr_Que_Start = '1094'; Addr_Que_End = '1114'; %FrameTable 2
        NewFT = '1';
    else
        Addr_Act_Start = '1094'; Addr_Act_End = '1114'; %FrameTable 2
        Addr_Que_Start = '1012'; Addr_Que_End = '1092'; %FrameTable 1
        NewFT = '0';
    end
    
    % Read active FrameTable content
    Counter = 1; FT_Array = NaN(65,2);
    for REG = hex2dec(Addr_Act_Start):2:hex2dec(Addr_Act_End)
        [~, VAL] = BTAreadRegister(deviceHandle, REG);
        FT_Array(Counter,1) = REG; FT_Array(Counter,2) = VAL;
        Counter = Counter + 1;
    end
       
    % Set modulation frequency
    [~, TOFCC_CLK] = BTAreadRegister(deviceHandle, hex2dec('00FB'));
    TOFCC_CLK = TOFCC_CLK /100; %TOFCC_CLK in MHz
    Tx_RDIV = TOFCC_CLK/8 - 3;
    Tx_NDIV = newFMOD / (TOFCC_CLK/2/(Tx_RDIV+3)) - 3;
    Tx_MODE = dec2bin(FT_Array(4,2),16);
    Tx_MODE(5:7) = dec2bin(Tx_RDIV,3);
    Tx_MODE(8:10) = dec2bin(Tx_NDIV,3);
    FT_Array(4,2) = bin2dec(Tx_MODE);
    FMOD = TOFCC_CLK/2/(Tx_RDIV+3)*(Tx_NDIV+3); %FMOD in MHz
       
    % Get active # phases per frame
    NoPhases = bitand(FT_Array(1,2),7) + 1;
    
    % Calculate active ADC readout time (per phase)
    SIZE = dec2hex(FT_Array(9,2),4);
    ROI_SIZE_X = hex2dec(SIZE(3:4))*16;
    ROI_SIZE_Y = hex2dec(SIZE(1:2));
    Treadout = 1 / (TOFCC_CLK/2) * ROI_SIZE_X/2 * ROI_SIZE_Y; %ADC readout time in us
    
    % Calculate new Tx_IDLETIME
    FrameIdle = (1/newFPS)*10^3 - NoPhases * (newTint + Treadout) / 10^3; %FrameIdleTime in ms
    FrameIdle = dec2hex(round(FrameIdle*10^3) * FMOD, 8); % FrameIdle = dec2hex(round(FrameIdle*10^3,0) * FMOD, 8);
    Tx_IDLETIME0 = hex2dec(FrameIdle(5:8));
    Tx_IDLETIME1 = hex2dec(FrameIdle(1:4));
   
    % Calculate new Tx_Py_INT0 and Tx_Py_INT1 register values
    newTint = dec2hex(newTint/(1/FMOD),8);
    Tx_Py_INT0 = hex2dec(newTint(5:8));
    Tx_Py_INT1 = hex2dec(newTint(1:4));
    
    % Set new FrameTable registers
    FT_Array(2,2) = Tx_IDLETIME0;
    FT_Array(3,2) = Tx_IDLETIME1;
    FT_Array(11,2) = Tx_Py_INT0; FT_Array(18,2) = Tx_Py_INT0; FT_Array(25,2) = Tx_Py_INT0; FT_Array(32,2) = Tx_Py_INT0;
    FT_Array(39,2) = Tx_Py_INT0; FT_Array(46,2) = Tx_Py_INT0; FT_Array(53,2) = Tx_Py_INT0; FT_Array(60,2) = Tx_Py_INT0;
    FT_Array(12,2) = Tx_Py_INT1; FT_Array(19,2) = Tx_Py_INT1; FT_Array(26,2) = Tx_Py_INT1; FT_Array(33,2) = Tx_Py_INT1;
    FT_Array(40,2) = Tx_Py_INT1; FT_Array(47,2) = Tx_Py_INT1; FT_Array(54,2) = Tx_Py_INT1; FT_Array(61,2) = Tx_Py_INT1;
       
    %Write NON active Frametable first to avoid data corruption
    Counter = 1;
    for REG = hex2dec(Addr_Que_Start):2:hex2dec(Addr_Que_End)
        status = BTAwriteRegister(deviceHandle, REG, FT_Array(Counter,2));
        if status ~= 0
            output = status; fprintf('Error: setTOFParameters_KLI : Write FrameTable\n'); return;
        end
        Counter = Counter + 1;
    end

    %Change active FrameTable
    ADC_DELAY_FT(16) = NewFT;
    BTAwriteRegister(deviceHandle, hex2dec('1010'), bin2dec(ADC_DELAY_FT));
    
    %Write NON active FrameTable for FrameTable consistency
    Counter = 1;
    for REG = hex2dec(Addr_Act_Start):2:hex2dec(Addr_Act_End)
        status = BTAwriteRegister(deviceHandle, REG, FT_Array(Counter,2));
        if status ~= 0
            output = status; fprintf('Error: setTOFParameters_KLI : Write FrameTable\n'); return;
        end
        Counter = Counter + 1;
    end
    
    output = status;
end