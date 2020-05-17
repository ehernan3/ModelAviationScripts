%%
[fileName,filePath] = uigetfile('*cleaned.csv');
opts = detectImportOptions([filePath,fileName]);
%% Import data
T = readtable([filePath,fileName],opts);
%% Repair variable names
T.Properties.VariableNames{15} = 'RotorRPM';
for idx = 1:numel(T.Properties.VariableNames)
    T.Properties.VariableNames{idx} = regexprep(...
        T.Properties.VariableNames{idx},...
        '_',...
        '');
end
%% Remove spikes
spikes = T.ServoVoltageV>10 | T.ESCBatteryUsedMAh > 5000;
T = T(~spikes,:);
%% plot data
close all
str = {fileName,...
    ['Capacity used = ',num2str(max(T.ESCBatteryUsedMAh)),' mAh'],...
    ['Peak ESC power = ',num2str(max(T.ESCPowerOutput)),' W'],...
    ['Peak ESC current = ',num2str(max(T.ESCBatteryCurrentA)),' A'],...
    ['Lowest battery voltage = ',num2str(min(T.ESCBatteryVoltageV)),' V'],...
    ['Lowest servo voltage = ',num2str(min(T.ServoVoltageV)),' V']};
%
for fig = [4:8,10:15]
    figure(fig);
    myField = T.Properties.VariableNames{fig};
    myPlot(fig,T,myField,str)
end
%% Subfunctions
function myPlot(fig,T,myField,str)
plot(T.Time,T.(myField))
h(fig) = gca;
h(fig).XLabel.String = 'time[sec]';
% h(fig).YLabel.String = [myField,units];
h(fig).YLabel.String = [myField];
h(fig).YLabel.Interpreter = 'None';
dim = [0.2 0.5 0.3 0.3];
annotation('textbox',dim,'String',str,'FitBoxToText','on',...
    'BackgroundColor','#FFFFFF','FaceAlpha',0.75,...
    'Interpreter','none');
grid
end