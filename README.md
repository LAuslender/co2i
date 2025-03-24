# co2i
A repository for senior design, co2 incubator.

Tests 1-3 Reach steady state. Test 4 has useful data but did not reach steady state, as the temperature transient was quicker but had more overshoot than desired.

Testing Info:
Test 1 - 60second PWM Period, 25% temperature duty cycle, 0.007% co2 duty cycle
Test 2 - 60second PWM Period, 75%/25% split temperature. duty cycle (>10C and <10C), 0.007% co2 duty cycle.
Test 3 - 60second PWM Period, 75%/20% split temp. duty cycle (>10C), 0.005% co2 duty cycle.
Test 4 - 60second PWM Period, 100%/75%/20% split temp. duty cycle (>10C, >7.5C, and <7.5C), 0.005% co2 duty cycle.

Data Column Format 
Time Setpoint_Temperature Temperature_Reading Humidity% Setpoint_CO2 CO2_Reading
