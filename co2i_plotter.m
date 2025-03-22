clc; clear; close all;

% Define filename
filename = '/Users/lauslender/Desktop/co2-prototype test 1 parsed.txt'; % Update with your actual file name

% Load data (assuming space-separated values)
data = readmatrix(filename);

% Extract columns
time = data(:,1);           % Time
actual_temp = data(:,3);    % Measured temperature
humidity = data(:,4);       % Humidity percentage
actual_co2 = data(:,6) .* 10;     % Measured CO2 (ppm)

% Define setpoints and tolerance bands
temp_setpoint = 38;
co2_setpoint = 50000;  % CO2 setpoint in ppm

temp_upper = temp_setpoint + 2;
temp_lower = temp_setpoint - 2;
co2_upper = co2_setpoint + 10000;
co2_lower = co2_setpoint - 10000;

% Temp PWM Parameters
T_tmp = 60; % Period in seconds
D_tmp = 0.25; % Duty cycle (25%)
V_high = 120; % High voltage level (V)
V_low = 0; % Low voltage level (V)
fs_tmp = 1; % Sampling frequency (Hz)
t_pwm_tmp = 0:1/fs_tmp:max(time); % Extend PWM for full data duration
pwm_signal_tmp = V_high * (mod(t_pwm_tmp, T_tmp) < D_tmp * T_tmp);

% CO2 PWM Parameters
T_co2 = 60; % Period in seconds
D_co2 = 0.007; % Duty cycle (0.7%)
fs_co2 = 1; % Sampling frequency (Hz)
t_pwm_co2 = 0:1/fs_co2:max(time); % Extend PWM for full data duration
pwm_signal_co2 = V_high * (mod(t_pwm_co2, T_co2) < D_co2 * T_co2);

% Compute DFT of PWM signals
n_tmp = length(pwm_signal_tmp);
n_co2 = length(pwm_signal_co2);
f_tmp = fs_tmp * (0:floor(n_tmp/2))/n_tmp; % Frequency vector for Temp PWM
f_co2 = fs_co2 * (0:floor(n_co2/2))/n_co2; % Frequency vector for CO2 PWM

% DFT of PWM signals
Y_tmp = fft(pwm_signal_tmp);
Y_co2 = fft(pwm_signal_co2);

% Compute magnitude of DFT (only half of the spectrum due to symmetry)
P_tmp = abs(Y_tmp(1:floor(n_tmp/2)+1));
P_co2 = abs(Y_co2(1:floor(n_co2/2)+1));

% Compute DFT of Temperature and CO2 data
fs_data = 1 / (time(2) - time(1)); % Sampling frequency based on time difference
n_temp = length(actual_temp);
n_co2_data = length(actual_co2);

% Frequency vectors
f_temp = fs_data * (0:floor(n_temp/2))/n_temp;
f_co2_data = fs_data * (0:floor(n_co2_data/2))/n_co2_data;

% DFT of Temperature and CO2 signals
Y_temp = fft(actual_temp);
Y_co2_data = fft(actual_co2);

% Magnitude of DFT (only half of the spectrum)
P_temp = abs(Y_temp(1:floor(n_temp/2)+1));
P_co2_data = abs(Y_co2_data(1:floor(n_co2_data/2)+1));

% Create a figure for normal plots (Temperature, CO2, PWM signals)
figure;
tiledlayout(5,1);

% Plot PWM signal (Temperature)
nexttile;
plot(t_pwm_tmp, pwm_signal_tmp, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Voltage (V)');
title('PWM Signal with 60s Period and 25% Duty Cycle');
axis([0 max(time) V_low-5 V_high+5]);

% Plot Temperature with Tolerance Band
nexttile;
plot(time, actual_temp, 'k', 'LineWidth', 1.5);
hold on;
yline(temp_upper, 'r--', 'LineWidth', 1.5);
yline(temp_lower, 'r--', 'LineWidth', 1.5);
yline(temp_setpoint, 'b-', 'LineWidth', 1); % Mark temp setpoint
xline(60, 'k--', 'LineWidth', 1); % Vertical line at 3720 seconds
hold off;
legend('Measured Temp', '+2°C', '-2°C', 'Temp Setpoint', 'Location', 'southeast');
xlabel('Time (s)'); ylabel('Temperature (°C)');
grid on; title('Temperature Control with Tolerance Band');

% Plot Humidity with Threshold
nexttile;
plot(time, humidity, 'k', 'LineWidth', 1.5);
yline(80, 'r--', 'LineWidth', 1); % 50% threshold line
xline(60, 'k--', 'LineWidth', 1); % Vertical line at 3720 seconds
xlabel('Time (s)'); ylabel('Humidity (%)');
grid on; title('Humidity Levels with Threshold');

% Plot PWM signal (CO2)
nexttile;
plot(t_pwm_co2, pwm_signal_co2, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('ON = 1/OFF = 0');
title('PWM Signal with 60s Period and 0.007% Duty Cycle');
axis([0 max(time) V_low-5 V_high+5]);

% Plot CO2 Levels with Tolerance Band
nexttile;
plot(time, actual_co2, 'k', 'LineWidth', 1.5);
hold on;
yline(co2_upper, 'r--', 'LineWidth', 1);
yline(co2_lower, 'r--', 'LineWidth', 1);
yline(co2_setpoint, 'b-', 'LineWidth', 1); % Mark CO2 setpoint
xline(3720, 'k--', 'LineWidth', 1); % Vertical line at 3720 seconds
hold off;
legend('Measured CO2', '+10000 ppm', '-10000 ppm', 'CO2 Setpoint', 'Location', 'southeast');
xlabel('Time (s)'); ylabel('CO2 Levels (ppm)');
grid on; title('CO2 Control with Tolerance Band');

% Create a separate figure for DFT plots
figure;
tiledlayout(4,1);

% Plot DFT of PWM signal (Temperature)
nexttile;
semilogy(f_tmp, P_tmp, 'k', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of Temperature PWM Signal');

% Plot DFT of Temperature Data
nexttile;
semilogy(f_temp, P_temp, 'k', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of Temperature Data');

% Plot DFT of PWM signal (CO2)
nexttile;
semilogy(f_co2, P_co2, 'k', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of CO2 PWM Signal');

% Plot DFT of CO2 Data
nexttile;
semilogy(f_co2_data, P_co2_data, 'k', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('DFT of CO2 Data');
