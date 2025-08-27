close all
clear all
clc

set(0, 'DefaultLineLineWidth', 2);


%% Data Process
% indoor 
T_in = readtable('C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\MSP\MC2\Indoor\gnss_log_20250818_115817 Indoor(Marina South Pier)', 'VariableNamingRule','preserve');
%T_in = readtable('C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\MSP\MC1\Indoor\gnss_log_20250815_161453 Indoor (MSP)', 'VariableNamingRule','preserve');
%T_in = readtable('C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\SITCanteen\gnss_log_20250812_152144 Indoor(Canteen)', 'VariableNamingRule','preserve');
T_in = T_in(~isnan(T_in.SNR), :);
T_in = T_in(:, {'Timestamp', 'PRN','SNR', 'Elevation', 'Azimuth'});
T_in.Environment = repmat("Indoor", height(T_in), 1);

% % outdoor 
T_out = readtable('C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\MSP\MC2\Outdoor\gnss_log_20250818_121001 Outdoor(MSP).csv', 'VariableNamingRule','preserve');
%T_out = readtable('C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\MSP\MC1\Outdoor\gnss_log_20250815_161456 Outdoor(Marina South Pier)', 'VariableNamingRule','preserve');
%T_out = readtable('C:\Users\A103764\OneDrive - Singapore Institute Of Technology\Vignesh_OneDrive\GnssResults\SITCanteen\gnss_log_20250812_153255 Outdoor(Canteen)', 'VariableNamingRule','preserve');
T_out = T_out(~isnan(T_out.SNR), :);
T_out = T_out(:, {'Timestamp', 'PRN','SNR', 'Elevation', 'Azimuth'});
T_out.Environment = repmat("Outdoor", height(T_out), 1);

T = [T_in; T_out];

allPRNs = unique([T_in.PRN; T_out.PRN]);
T.PRN = categorical(T.PRN, allPRNs);
T.Environment = categorical(T.Environment, ["Indoor","Outdoor"]);


% % Box plots
% PRN_num = double(T.PRN);       
% grp = double(T.Environment);    
% pos = PRN_num + (grp-1.5)*0.2; % -0.1 (Indoor), +0.1 (Outdoor)
% 
% figure('Name','Indoor vs Outdoor SNR by PRN');
% hold on
% 
% % Dummy lines for legend (must be **before boxplot**)
% h1 = plot(NaN,NaN,'r','LineWidth',2);
% h2 = plot(NaN,NaN,'b','LineWidth',2);
% 
% boxplot(T.SNR(T.Environment=="Indoor"), pos(T.Environment=="Indoor"), ...
%     'Colors','r', 'Widths',0.15, 'Positions', pos(T.Environment=="Indoor"), 'Symbol','');
% 
% boxplot(T.SNR(T.Environment=="Outdoor"), pos(T.Environment=="Outdoor"), ...
%     'Colors','b', 'Widths',0.15, 'Positions', pos(T.Environment=="Outdoor"), 'Symbol','');
% 
% xticks(1:length(allPRNs));
% xticklabels(string(allPRNs));
% xlabel('PRN');
% ylabel('SNR (dB)');
% ylim([min(T.SNR) max(T.SNR)]);
% title('Indoor vs Outdoor SNR by PRN');
% grid on
% legend([h1,h2], {'Indoor (Red)','Outdoor (Blue)'}, 'Location','Best');
% hold off

% --------------------Line plots--------------------------------- %
% % Unique PRNs across both datasets
% allPRNs = unique([T_in.PRN; T_out.PRN]);
% colors = lines(length(allPRNs));
% 
% % Indoor Azimuth vs Time
% figure; hold on; grid on; box on
% legendEntries = {}; % to store PRNs actually plotted
% for i = 1:length(allPRNs)
%     prn = allPRNs(i);
%     idx = T_in.PRN == prn;
%     if any(idx)  % only plot if data exists
%         plot(T_in.Timestamp(idx), T_in.Azimuth(idx), '.', 'Color', colors(i,:), 'MarkerSize', 12)
%         legendEntries{end+1} = num2str(prn); 
%     end
% end
% xlabel('Time'); ylabel('Azimuth (degrees)')
% title('Indoor Azimuth vs Time per Satellite')
% legend(legendEntries, 'Location', 'best')
% 
% % Indoor Elevation vs Time
% figure; hold on; grid on; box on
% legendEntries = {};
% for i = 1:length(allPRNs)
%     prn = allPRNs(i);
%     idx = T_in.PRN == prn;
%     if any(idx)
%         plot(T_in.Timestamp(idx), T_in.Elevation(idx), '.', 'Color', colors(i,:), 'MarkerSize', 12)
%         legendEntries{end+1} = num2str(prn);
%     end
% end
% xlabel('Time'); ylabel('Elevation (degrees)')
% title('Indoor Elevation vs Time per Satellite')
% legend(legendEntries, 'Location', 'best')
% 
% % Outdoor Azimuth vs Time
% figure; hold on; grid on; box on
% legendEntries = {};
% for i = 1:length(allPRNs)
%     prn = allPRNs(i);
%     idx = T_out.PRN == prn;
%     if any(idx)
%         plot(T_out.Timestamp(idx), T_out.Azimuth(idx), '.', 'Color', colors(i,:), 'MarkerSize', 12)
%         legendEntries{end+1} = num2str(prn);
%     end
% end
% xlabel('Time'); ylabel('Azimuth (degrees)')
% title('Outdoor Azimuth vs Time per Satellite')
% legend(legendEntries, 'Location', 'best')
% 
% % Outdoor Elevation vs Time
% figure; hold on; grid on; box on
% legendEntries = {};
% for i = 1:length(allPRNs)
%     prn = allPRNs(i);
%     idx = T_out.PRN == prn;
%     if any(idx)
%         plot(T_out.Timestamp(idx), T_out.Elevation(idx), '.', 'Color', colors(i,:), 'MarkerSize', 12)
%         legendEntries{end+1} = num2str(prn);
%     end
% end
% xlabel('Time'); ylabel('Elevation (degrees)')
% title('Outdoor Elevation vs Time per Satellite')
% legend(legendEntries, 'Location', 'best')



% indoor analyse for all PRN
% Bin edges
azEdges = 0:10:360;   % Azimuth bins
elEdges = 0:5:90;     % Elevation bins

% Preallocate SNR grid
SNRgrid = nan(length(elEdges)-1, length(azEdges)-1);

% Compute mean SNR per bin
for i = 1:length(elEdges)-1
    for j = 1:length(azEdges)-1
        idx = T_in.Elevation >= elEdges(i) & T_in.Elevation < elEdges(i+1) & ...
              T_in.Azimuth >= azEdges(j) & T_in.Azimuth < azEdges(j+1);
        if any(idx)
            SNRgrid(i,j) = mean(T_in.SNR(idx));
        end
    end
end

% heatmap - find range of elevation and azimuth vs SNR

% indoor
allPRNs = unique(T_in.PRN);
colors = lines(length(allPRNs)); % unique color per PRN

% Loop over PRNs
for i = 1:length(allPRNs)
    prn = allPRNs(i);
    idx = T_in.PRN == prn; % filter rows for this PRN

    figure; hold on; grid on; box on
    scatter(T_in.Azimuth(idx), T_in.Elevation(idx), 50, T_in.SNR(idx), 'filled')

    xlabel('Azimuth (degrees)')
    ylabel('Elevation (degrees)')
    title(['PRN ', num2str(prn), ': SNR distribution'])
    colormap jet
    colorbar
    caxis([min(T_in.SNR), max(T_in.SNR)]) % consistent color scale across PRNs
end


% % outdoor
% allPRNs = unique(T_out.PRN);
% colors = lines(length(allPRNs)); % unique color per PRN
% 
% % Loop over PRNs
% for i = 1:length(allPRNs)
%     prn = allPRNs(i);
%     idx = T_out.PRN == prn; % filter rows for this PRN
% 
%     figure; hold on; grid on; box on
%     scatter(T_out.Azimuth(idx), T_out.Elevation(idx), 50, T_out.SNR(idx), 'filled')
% 
%     xlabel('Azimuth (degrees)')
%     ylabel('Elevation (degrees)')
%     title(['PRN ', num2str(prn), ': SNR distribution'])
%     colormap jet
%     colorbar
%     caxis([min(T_out.SNR), max(T_out.SNR)]) % consistent color scale across PRNs
% end