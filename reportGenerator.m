tic
import mlreportgen.report.*
import mlreportgen.dom.*
rpt = Report('iChargerRepot');
% Title page
tp = TitlePage; 
tp.Title = 'iCharger Report';
tp.Subtitle = myObj.fileName;
tp.Author = 'Ed Hernandez'; 
add(rpt,tp); 
% TOC
add(rpt,TableOfContents); 
% Cycle through figures
h = findobj('type','figure');
for idx=1:numel(h)
    % Chapter can be reused
    ch = Chapter();
    ch.Title = h(idx).Name;
    % Chapter can be reused
    fig = Figure(h(idx).CurrentAxes);
    add(ch,fig);
    add(rpt,ch);
end
%
close(rpt);
rptview(rpt);
disp(['Generating report of ',num2str(numel(h)),' figures took ',num2str(toc),' seconds'])