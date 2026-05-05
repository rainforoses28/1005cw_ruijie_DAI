function temp_monitor(a)
Time_record=[];  
Temperature_record=[];  
T_c=0.01; 
V_0deg=0.5;  
tic;
figure;
Green_LED='D3';
Yellow_LED='D4';
Red_LED='D2';
while true
    Time_test=toc;
    A0_voltage = readVoltage(a, 'A0');
    Temperature_current=(A0_voltage-V_0deg)/T_c;
    Time_record=[Time_record,Time_test];
    Temperature_record=[Temperature_record,Temperature_current];
    plot(Time_record,Temperature_record,'k-')
    xlabel('Time(seconds)');
    ylabel('Temperature(Degree)');
    title('Real-time Temperature Monitoring');
    if Time_test>20
          xlim([Time_test-20,Time_test+5]);
    end
    drawnow;
    Time_test=Time_test+1;
    if Temperature_record>=18 & Temperature_record<=24
          writeDigitalPin(a,Green_LED,1)
          writeDigitalPin(a,Red_LED,0)
          writeDigitalPin(a,Yellow_LED,0)
          pause_time=1
    elseif Temperature_record<18
             writeDigitalPin(a,Yellow_LED,1)
             writeDigitalPin(a,Red_LED,0)
             writeDigitalPin(a,Green_LED,0)
             pause(0.5)
             writeDigitalPin(a,Yellow_LED,0)
             pause(0.5)
             pause_time=0
    else
          writeDigitalPin(a,Red_LED,1)
          writeDigitalPin(a,Yellow_LED,0)
          writeDigitalPin(a,Green_LED,0)
          pause(0.25)
          writeDigitalPin(a,Red_LED,0)
          pause(0.25)
          pause_time=0.5
    end
    pause(pause_time)
end
end