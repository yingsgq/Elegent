% Linuo Jiang
% ssylj3@nottingham.edu.cn

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

disp("these two softwares have been download")

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Initialize Arduino
a = arduino('COM9', 'Uno');

% Configuration parameters
duration = 600;           % 10 minutes in seconds
samplingInterval = 1;     % Sampling interval: 1 second
numSamples = duration / samplingInterval;

% Initialize time vector and data arrays
time = (0:numSamples-1) * samplingInterval; % Time array
voltageValues = zeros(1, numSamples);
temperatureValues = zeros(1, numSamples);

% Temperature sensor parameters (MCP9700A)
V0 = 0.5;     % Voltage at 0°C (V)
Tc = 0.01;    % Temperature coefficient (V/°C)

% Data acquisition
for i = 1:numSamples
    voltage = readVoltage(a, 'A0'); % Assuming the temperature sensor is connected to A0
    temperature = (voltage - V0) / Tc;
    voltageValues(i) = voltage;
    temperatureValues(i) = temperature;
    pause(samplingInterval); % Ensure proper time interval
end

% Calculate statistics
minTemp = min(temperatureValues);
maxTemp = max(temperatureValues);
avgTemp = mean(temperatureValues);

% Plot temperature curve
figure;
plot(time, temperatureValues);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Cabin Temperature Variation');
grid on;

% ==== Generate formatted table string (A4 half-width, 42 chars) ====
tableWidth = 42; % Fixed total width: 42 characters
tableStr = '';

% Header (merge date and location)
headerLine = sprintf('%-42s', ['Data logging initiated - ', datestr(now, 'mm/dd/yyyy'), ' Location - Nottingham']);
tableStr = [tableStr, headerLine, newline, newline]; % Blank line after header

% Log data every 60 seconds (1 minute interval)
for i = 1:60:numSamples
    minute = floor((i-1)/60); % Minute starts from 0
    temp = temperatureValues(i);
    
    % Minute line: left-align label, right-align value
    minuteLine = sprintf('%-20s%23.2f ', 'Minute', minute);
    tableStr = [tableStr, minuteLine, newline];
    
    % Temperature line: left-align label, right-align value
    tempLine = sprintf('%-20s%18.2f C', 'Temperature', temp);
    tableStr = [tableStr, tempLine, newline, newline]; % Blank line after each group
end

% Statistics lines (aligned output)
statMax = sprintf('%-20s%20.2f C', 'Max temp', maxTemp);
statMin = sprintf('%-20s%20.2f C', 'Min temp', minTemp);
statAvg = sprintf('%-20s%17.2f C', 'Average temp', avgTemp);

% Termination line
endLine = sprintf('%-42s', 'Data logging terminated');

% Append statistics and termination line
tableStr = [tableStr, statMax, newline, statMin, newline, statAvg, newline, newline, endLine];

% Output to console
disp(tableStr);

% Write to log file
fileID = fopen('cabin_temperature.txt', 'w');
fprintf(fileID, '%s', tableStr);
fclose(fileID);


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

a = arduino('COM9', 'Uno');
sensorPin = 'A0';
greenLED = 'D4';
yellowLED = 'D3';
redLED = 'D2';

temp_monitor(a, sensorPin, greenLED, yellowLED, redLED);



%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

a = arduino('COM9', 'Uno');
sensorPin = 'A0';
greenLED = 'D4';
yellowLED = 'D3';
redLED = 'D2';

temp_prediction(a, sensorPin, greenLED, yellowLED, redLED);



%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% This project highlighted both the challenges and rewards of integrating hardware-software systems. Initializing stable MATLAB-Arduino communication required meticulous troubleshooting of port configurations and dependency management. In Task 1, resolving plotting errors caused by mismatched array dimensions (time vs. temperature data) necessitated rigorous validation of sampling logic. Task 2 introduced timing complexities: maintaining concurrent LED blinking intervals (0.25–0.5s) while ensuring 1s sampling intervals risked loop delays, demanding precise synchronization. Task 3's temperature prediction faced noise-induced instability in derivative calculations, which was mitigated through moving average filtering. Additionally, formatting the A4-compliant output table required iterative refinement of sprintf parameters to achieve column alignment.  
%  
% The system’s strengths lie in its modular architecture, which isolated monitoring, prediction, and logging functionalities, enhancing code maintainability. Git version control provided robust progress tracking and error recovery. Real-time plotting via drawnow enabled immediate visualization of thermal trends, while hardware-software integration (e.g., sensor-driven LED alerts) demonstrated end-to-end functionality. However, limitations persist: the design assumes ideal sensor behavior, ignoring thermal drift or electrical noise. The linear prediction model in Task 3 oversimplifies environmental dynamics, and software-based LED timing lacks hardware-level precision, causing minor flicker during rapid state transitions.  
%  
% Future improvements should prioritize hardware timers for millisecond-accurate LED control and advanced prediction models (e.g., LSTM networks) to address nonlinear thermal behaviors. Implementing error-handling routines for sensor disconnections and outlier detection would bolster reliability. Expanding the system with IoT-enabled multi-sensor networks and a GUI for dynamic threshold adjustments could bridge the gap between prototype and industrial application. This project not only reinforced MATLAB/Arduino technical skills but also underscored the iterative nature of embedded systems development—where patience, modularity, and incremental testing are paramount.  

 