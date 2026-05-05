% temp__detect predicts future temperature and monitors rate of change.
function temp_detect(a)%There passes the Arduino created in script_template (the 'a' variable) to this function
% This function continuously calculates the temperature change rate in 
% Celsius per second and minute. It prints the current rate and the
% predicted temperature for the next 5 minutes to the screen. 
% LEDs provide alerts: Constant Red for fast rise (>4°C/min), 
% Constant Yellow for fast drop (<-4°C/min), and Green for stable.

%-----Initialization-----
T_c=0.01;  % Temperature coefficient
V_0deg=0.5;  % Voltage at 0 degrees
Green_LED='D3';
Yellow_LED='D4';
Red_LED='D2';
tic;
Time_initial=toc;
Voltage_initial = readVoltage(a, 'A0');
Temperature_initial=(Voltage_initial-V_0deg)/T_c;
while true
      pause(1);% Pause for 1s to allow a measurable change in temperature in seconds.
      Time_now=toc;
      Voltage_now=readVoltage(a,'A0');
      Temperature_now=(Voltage_now-V_0deg)/T_c;
      % Calculation of Rate (Delta T / Delta t)
      Rate_temperature=(Temperature_now-Temperature_initial)/(Time_now-Time_initial);
      Rate_temperature_minute=Rate_temperature*60;
      % Prediction: Linear projection for 5 minutes (300 seconds)
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
      % Update reference points for the next cycle to maintain continuous monitoring
      Time_initial=Time_now;
      Temperature_initial=Temperature_now;
end
end