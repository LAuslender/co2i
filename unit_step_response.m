% Author: Luke Auslender
% Project: CO2 Incubator, Unit Step Response
% Description: Plots the output data for a unit step resonse test on a CO2 Incubator.
% This test is the most basic form of unit step response, where the input 
% voltage is either 0V or 120V (OFF or ON). No control logic is used for
% this test.

% Prompt user to select the data file
[file, path] = uigetfile('*.txt', 'Select the Output Data File');
if isequal(file, 0)
    disp('User canceled the file selection');
    return;
end

% Read the data from the text file
data = load(fullfile(path, file));  % Load the data from the selected file

% Extract time and temperature from the data
t = data(:, 1);  % Assuming the first column is time (in seconds)
temperature = data(:, 2);  % Assuming the second column is temperature

% Convert time from seconds to minutes
t_minutes = (t-10);

% Plot 1: Unit Step Response (0V to 120V at 10s, drop to 0V at 510s)
figure;
subplot(2, 1, 1);  % Create a subplot (2 rows, 1 column, first plot)
unit_step = 0 * (t < 10) + 120 * (t >= 10 & t <= 510) + 0 * (t > 510);  % Unit step: 0V to 120V at 10s, 0V at 510s
plot(t_minutes, unit_step, 'b', 'LineWidth', 2);
title('Unit Step Response');
xlabel('Time (minutes)');
ylabel('Voltage (V)');
ylim([-10, 130]);  % Set y-axis limits to fit 0V and 120V
grid on;

% Plot 2: Output Data (Temperature vs. Time)
subplot(2, 1, 2);  % Create second plot in the subplot
plot(t_minutes, temperature, 'r', 'LineWidth', 2);
hold on;

% Add dashed line for target temperature (40C)
yline(40, '--k', 'Target Temperature (40C)', 'LineWidth', 1.5);

title('Output Data: Temperature vs. Time');
xlabel('Time (minutes)');
ylabel('Temperature (°C)');
ylim([0, 75]);  % Set y-axis limits for temperature from 0 to 70C
grid on;

% Move the legend to the bottom-right
legend('Output Temperature', 'Target Temperature (40C)', 'Location', 'southeast');

% Display the plots
hold off;
