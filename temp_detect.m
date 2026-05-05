function temp_detect(a)
T_c=0.01;
V_0deg=0.5;
Yellow_LED='D4';
Red_LED='D2';
tic;
Time_initial=toc;
Voltage_initial = readVoltage(a, 'A0');
Temperature_initial=(Voltage_initial-V_0deg)/T_c;
while true
      pause(1);
      Time_now=toc;
      Voltage_now=readVoltage(a,'A0');
      Temperature_now=(Voltage_now-V_0deg)/T_c;
      Rate_temperature=(Temperature_now-Temperature_initial)/(Time_now-Time_initial);
      Rate_temperature_minute=Rate_temperature*60;
      Temperature_predicted=Temperature_now+Rate_temperature*300;
      sprintf('Rate of change in temperature/second:%.2f degree/s|Predicted temperature after 5 minutes:%.2f degree \n',Rate_temperature,Temperature_predicted)
      if Rate_temperature_minute>4
         writeDigitalPin(a,Red_LED,1);
         writeDigitalPin(a,Yellow_LED,0)
         writeDigitalPin(a,Green_LED,0)
      elseif Rate_temperature_minute<-4
          writeDigitalPin(a,Yellow_LED,1);
          writeDigitalPin(a,Red_LED,0)
          writeDigitalPin(a,Green_LED,0)
      else
          writeDigitalPin(a,Green_LED,1);
          writeDigitalPin(a,Red_LED,0)
          writeDigitalPin(a,Yellow_LED,0)
      end
      Time_initial=Time_now;
      Temperature_initial=Temperature_now;
end
end