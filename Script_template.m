% Ruijie DAI
% ssyrd3@nottingham.edu.cn

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
clear
a=arduino('COM3','Uno');
for i=1:10
writeDigitalPin(a,'D4',1)
pause(0.5)
writeDigitalPin(a,'D4',0)
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
%b)
duration=600;
j=0;
time=linspace(1,duration+1,duration+1);
Voltage=zeros(1,duration+1);
Temperature=zeros(1,duration+1);
T_c=0.01;
V_0deg=0.5;
Location=input('Please enter your location','s');
current_date=datetime('now','Format','mm/dd/yyyy');
while j<=duration;
    j=j+1;
    A0_voltage = readVoltage(a, 'A0');
    Voltage(1,j)=A0_voltage;
    Temperature(1,j)=(Voltage(1,j)-V_0deg)/T_c;
    pause(1)
 end
Temperature_min=min(Temperature)
Temperature_max=max(Temperature)
Average_temperature=mean(Temperature)
%c)
plot(time,Temperature,'k-');
xlabel('Time (s)');
ylabel('Temperature (degree)');
title('Temperature variation in 10 mimutes');
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here