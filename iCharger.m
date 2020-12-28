classdef iCharger < handle
    %This class reads logs from the iCharger and plots certain statistics
    %   Detailed explanation goes here
    
    properties
        fileName         % Name of input file
        tableLog         % iCharger log as a table
        startVoltagePack % Starting voltage for the entire pack
        endingVoltagePack  % Ending voltage for the entire pack
        startVoltageCell_01 % Starting voltage for cell #1, Li only
        endingVoltageCell_01 % Ending voltage for cell #1, Li only
        timeMinutes          % Total log time, minutes
    end
    
    methods
        function obj = iCharger
            % Read the log into a table
            %   Detailed explanation goes here
            % Define the header, specific to the iCharger
            header = fileread('header_iCharger.txt');
            header = split(header,',')';
            % Choose input file
            [fileName,filePath] = uigetfile('C:\Users\ehern\Documents\Eddie_Stuff\Model Aviation\Helicopter\Chargers\Junsi X6\*.txt');
            % Set import options
            opts = detectImportOptions([filePath,fileName]);
            % Read into table
            obj.tableLog = readtable([filePath,fileName],opts);
            % Fix header
            obj.tableLog.Properties.VariableNames(6:end) = header;
            obj.tableLog.Properties.VariableNames{3} = 'time_ms';
            % Removing rows with NaN, etc
            obj.tableLog = rmmissing(obj.tableLog);
            % Set fileNale
            obj.fileName = fileName;
            % Calculate statistics
            obj.statistics;
            % Make plots
            obj.plots
        end
        function statistics(obj)
            %METHOD1 Calculate statistics from the log
            %   Detailed explanation goes here
            obj.startVoltagePack = obj.tableLog.Vout(1)./1000;
            obj.endingVoltagePack  = obj.tableLog.Vout(end)./1000;
            obj.startVoltageCell_01 = obj.tableLog.Cell1(1)./1000;
            obj.endingVoltageCell_01 = obj.tableLog.Cell1(end)./1000;
            obj.timeMinutes = obj.tableLog.time_ms(end)/1000/60;
        end
        function plots(obj)
            str = {obj.fileName,...
                ['Start voltage(total) = ',num2str(obj.startVoltagePack),' V'],...
                ['Ending voltage(total) = ',num2str(obj.endingVoltagePack),' V'],...
                ['Start voltage(cell #1) = ',num2str(obj.startVoltageCell_01),' V'],...
                ['Ending voltage(cell #1) = ',num2str(obj.endingVoltageCell_01),' V'],...
                ['Time to charge = ', num2str(obj.timeMinutes),' min']};
            % METHOD generate plots
            for fig = [6:11]
                figure(fig);
                myField = obj.tableLog.Properties.VariableNames{fig};
                [conversionFactor, units] = unitConversion(myField);
                myPlot(fig,obj.tableLog,myField,conversionFactor,units)
                dim = [0.2 0.5 0.3 0.3];
                annotation('textbox',dim,'String',str,'FitBoxToText','on',...
                    'BackgroundColor','#FFFFFF','FaceAlpha',0.75,...
                    'Interpreter','none');
            end
            fig=12;figure(fig);
            for idxCell = 12:17
                myField = obj.tableLog.Properties.VariableNames{idxCell};
                [conversionFactor, units] = unitConversion(myField);
                hold all
                myPlot(fig,obj.tableLog,myField,conversionFactor,units)
                hold off
            end
            grid
            h(fig).YLabel.String = ['Cell voltage',units];
            legend(obj.tableLog.Properties.VariableNames{12:17})
            dim = [0.2 0.5 0.3 0.3];
            annotation('textbox',dim,'String',str,'FitBoxToText','on',...
                'BackgroundColor','#FFFFFF','FaceAlpha',0.75,...
                'Interpreter','none');
            %
            fig=13;
            figure(fig);
            myField = obj.tableLog.Properties.VariableNames{end};
            [conversionFactor, units] = unitConversion(myField);
            myPlot(fig,obj.tableLog,myField,conversionFactor,units)
            dim = [0.2 0.5 0.3 0.3];
            annotation('textbox',dim,'String',str,'FitBoxToText','on',...
                'BackgroundColor','#FFFFFF','FaceAlpha',0.75,...
                'Interpreter','none');
        end
    end % End Methods
end % End classdef
% Class related functions
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
end % End switch-case
end % End unitConversion function
function myPlot(fig,T,myField,conversionFactor,units)
plot(T.time_ms./1000/60,T.(myField).*conversionFactor)
h(fig) = gca;
h(fig).XLabel.String = 'time[min]';
h(fig).YLabel.String = [myField,units];
h(fig).YLabel.Interpreter = 'none';
grid
end % End myPlot
