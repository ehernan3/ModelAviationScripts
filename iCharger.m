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
    end
end

