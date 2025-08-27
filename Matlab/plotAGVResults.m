close all
clc
clear all

agvfile = 'C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\AGV\GNSS_data\GNSS_data.csv';
T = readtable(agvfile, 'VariableNamingRule', 'preserve');

% Convert to human-readable datetime (UTC)
timeUTC = datetime(T.timestamp, 'ConvertFrom', 'posixtime', 'TimeZone', 'UTC');

% see if there were any breaks (continuously recorded from 07 15 to 09 30)
% figure;
% plot(timeUTC, 1:numel(timeUTC), 'o-');
% xlabel('UTC Time');
% ylabel('Sample Index');
% title('Timestamp Progression');


% plot measurements
figure;
geoplot(T.latitude, T.longitude, '-o', 'LineWidth', 1.5, 'MarkerSize', 4);
title('GNSS Track (Lat vs Lon)');



% plot mean square error of lat_std and long_std to plot heatmap
T.mse = sqrt(T.latitude_std.^2 + T.longitude_std.^2);

% Scatter heatmap using geoscatter
figure;
geoscatter(T.latitude, T.longitude, 30, T.mse, 'filled');
colorbar;
colormap(jet);
title('Heatmap of Fix Uncertainty (MSE of lat\_std & long\_std)');