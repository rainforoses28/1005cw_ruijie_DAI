% temp_monitor provides a real-time temperature monitoring and alerting system.
function temp_monitor(a)%There passes the Arduino created in script_template (the 'a' variable) to this function
% This function continuously collects temperature data from a sensor
% connected to pin A0. It plots a live graph of the data and uses 
% LEDs to indicate the state: Green for comfort range (18-24°C), 
% blinking Yellow for cold (below 18°C), and blinking Red for hot(beyond 24°C).

%-----Initialization-----
Time_record=[];  % This is prepared for continuously recording the time in case of the previous data being overlapped in loop
Temperature_record=[];   % This is created for continuously collecting temperature data from a sensor 
T_c=0.01;  % Temperature coefficient
V_0deg=0.5; % Voltage at 0 degrees
tic;
figure;
Green_LED='D3';
Yellow_LED='D4';
Red_LED='D2';
while true
    % 1. Data Collection
    Time_test=toc;
    A0_voltage = readVoltage(a, 'A0');
    Temperature_current=(A0_voltage-V_0deg)/T_c;
    % 2. Record and Plot
    Time_record=[Time_record,Time_test];
    Temperature_record=[Temperature_record,Temperature_current];
    plot(Time_record,Temperature_record,'k-')
    xlabel('Time(seconds)');
    ylabel('Temperature(Degree)');
    title('Real-time Temperature Monitoring');
    % Dynamic Axis (Showing last 20 seconds)
    if Time_test>20
          xlim([Time_test-20,Time_test+5]);
    end
    drawnow;
    Time_test=Time_test+1;
    % 3. LED Logic (Checking the LATEST recorded temperature)
    % Comfort Range: Constant Green
    % Logic: Green is constant. No execution time is taken by blinking, 
    % so pause for a full 1s to maintain the ~1Hz sampling rate.
    if Temperature_record>=18 & Temperature_record<=24
          writeDigitalPin(a,Green_LED,1)
          writeDigitalPin(a,Red_LED,0)
          writeDigitalPin(a,Yellow_LED,0)
          pause_time=1
    % Cold: Blinking Yellow
    % Logic: Yellow blinks with 0.5s ON and 0.5s OFF. 
    % This sequence ALREADY consumes 1.0s of real-world time.
    % Therefore, no additional pause is needed to stay at ~1Hz.
    elseif Temperature_record<18
             writeDigitalPin(a,Yellow_LED,1)
             writeDigitalPin(a,Red_LED,0)
             writeDigitalPin(a,Green_LED,0)
             pause(0.5)
             writeDigitalPin(a,Yellow_LED,0)
             pause(0.5)
             pause_time=0
    % Hot: Blinking Red
    % Logic: Red blinks with 0.25s ON and 0.25s OFF (Total 0.5s).
    % To keep the total loop cycle at 1.0s, we add a 0.5s compensation 
    % pause (1.0s total cycle - 0.5s blinking duration = 0.5s).
    else
          writeDigitalPin(a,Red_LED,1)
          writeDigitalPin(a,Yellow_LED,0)
          writeDigitalPin(a,Green_LED,0)
          pause(0.25)
          writeDigitalPin(a,Red_LED,0)
          pause(0.25)
          pause_time=0.5
    end
    pause(pause_time)% Compensation pause for temporal consistency
end
end