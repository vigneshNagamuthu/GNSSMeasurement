close all 
clear all 
clc 
set(0, 'DefaultLineLineWidth', 2);


%----------------------- Indoor ---------------------------------%

indoorfilename = 'C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\MSP\MC2\Indoor\gnss_log_20250818_115817 Indoor(Marina South Pier)';
T = readtable(indoorfilename, 'VariableNamingRule', 'preserve');

% Convert timestamp
T.Timestamp = datetime(T.Timestamp, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

% Remove rows with missing SNR
T = T(~isnan(T.SNR), :);

% Get unique PRNs
prns = unique(T.PRN);
n = length(prns);

% Layout for subplots
cols = 3;
rows = ceil(n / cols);

% Create figure
figure('Name', 'SNR Over Time - Each PRN');

for i = 1:n
    prn = prns(i);
    idx = T.PRN == prn;

    subplot(rows, cols, i);
    plot(T.Timestamp(idx), T.SNR(idx), 'b-', 'LineWidth', 1.2);
    title(['PRN ' num2str(prn)]);
    xlabel('Time');
    ylabel('SNR (dB)');
    grid on;
end

figure('Name', 'Indoor SNR Boxplot');
allSNR = T.SNR;
allPRNs = T.PRN;

boxplot(allSNR, allPRNs, 'LabelOrientation', 'inline');
xlabel('PRN');
ylabel('SNR (dB)');
title('Indoor SNR Distribution by Satellite PRN');
grid on;


%------------------------ Outdoor -------------------------------------%
outdoorfilename = 'C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\MSP\MC2\Outdoor\gnss_log_20250818_121001 Outdoor(MSP).csv';
T = readtable(outdoorfilename, 'VariableNamingRule', 'preserve');

% Convert timestamp
T.Timestamp = datetime(T.Timestamp, 'InputFormat', 'yyyy-MM-dd HH:mm:ss');

% Remove rows with missing SNR
T = T(~isnan(T.SNR), :);

% Get unique PRNs
prns = unique(T.PRN);
n = length(prns);

% Layout for subplots
cols = 3;
rows = ceil(n / cols);

% Create figure
figure('Name', 'SNR Over Time - Each PRN');

for i = 1:n
    prn = prns(i);
    idx = T.PRN == prn;

    subplot(rows, cols, i);
    plot(T.Timestamp(idx), T.SNR(idx), 'b-', 'LineWidth', 1.2);
    title(['PRN ' num2str(prn)]);
    xlabel('Time');
    ylabel('SNR (dB)');
    grid on;
end

figure('Name', 'Outdoor SNR Boxplot');
allSNR = T.SNR;
allPRNs = T.PRN;

boxplot(allSNR, allPRNs, 'LabelOrientation', 'inline');
xlabel('PRN');
ylabel('SNR (dB)');
title('Outdoor SNR Distribution by Satellite PRN');
grid on;


% ------------------------------------------------------------------- % 



