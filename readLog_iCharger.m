clear;close all
%% Header
header = fileread('header_iCharger.txt');
header = split(header,',')';
%%
[fileName,filePath] = uigetfile('*.txt');
opts = detectImportOptions([filePath,fileName]);
%%
T = readtable([filePath,fileName],opts);
%% Fix header
T.Properties.VariableNames(6:end) = header;
T.Properties.VariableNames{3} = 'time_ms';
%% Plot
close all
str = {fileName,...
    ['Start voltage(total) = ',num2str(T.Vout(1)./1000),' V'],...
    ['Ending voltage(total) = ',num2str(T.Vout(end)./1000),' V'],...
    ['Start voltage(cell #1) = ',num2str(T.Cell1(1)./1000),' V'],...
    ['Ending voltage(cell #1) = ',num2str(T.Cell1(end)./1000),' V'],...
    ['Time to charge = ', num2str(T.time_ms(end)/1000/60),' min']};
for fig = [6:11]%,18] %numel(T.Properties.VariableNames)
    figure(fig);
    myField = T.Properties.VariableNames{fig};
    [conversionFactor, units] = unitConversion(myField);
    myPlot(fig,T,myField,conversionFactor,units,str)
end
fig=12;figure(fig);
for idxCell = 12:17
    myField = T.Properties.VariableNames{idxCell};
    [conversionFactor, units] = unitConversion(myField);
    hold all
    myPlot(fig,T,myField,conversionFactor,units,str)
    hold off
end
grid
h(fig).YLabel.String = ['Cell voltage',units];
legend(T.Properties.VariableNames{12:17})
%
fig=13;
figure(fig);
    myField = T.Properties.VariableNames{end};
    [conversionFactor, units] = unitConversion(myField);
    myPlot(fig,T,myField,conversionFactor,units,str)
%% subfunctions
function [conversionFactor, units] = unitConversion(myField)
switch myField
    case {'Vin','Vout','Cell1','Cell2','Cell3','Cell4','Cell5','Cell6'}
        conversionFactor = 1/1000;
        units = ', V';
    case 'Capacity'
        conversionFactor = 1;
        units = ' into battery, mAh';
    case 'TempInt'
        conversionFactor = 1/10;
        units = ', deg C';
    case 'Current'
        conversionFactor = 10;
        units = ', mA';
    case 'Output_Power'
        %             conversionFactor = 1/10;% NiCd
        conversionFactor = 10;% LiPo
        units = ', W';
    otherwise
        conversionFactor = 1;
        units = '';
end
end
% 
function myPlot(fig,T,myField,conversionFactor,units,str)
plot(T.time_ms./1000/60,T.(myField).*conversionFactor)
h(fig) = gca;
h(fig).XLabel.String = 'time[min]';
h(fig).YLabel.String = [myField,units];
h(fig).YLabel.Interpreter = 'none';
dim = [0.2 0.5 0.3 0.3];
annotation('textbox',dim,'String',str,'FitBoxToText','on',...
    'BackgroundColor','#FFFFFF','FaceAlpha',0.75,...
    'Interpreter','none');
grid
end