import mlreportgen.report.*
surf(peaks);
rpt = Report('peaks');
chapter = Chapter();
chapter.Title = 'reporrtGenFigure Example';
add(rpt,chapter);

fig = reporrtGenFigure();
fig.Snapshot.Caption = '3-D shaded surface plot';
fig.Snapshot.Height = '5in';

add(rpt,fig);
delete(gcf);
rptview(rpt);
%%
import mlreportgen.report.*
import mlreportgen.dom.*
rpt = Report('peaks');

figure(6)
reporrtGenFigure = Figure();
image06 = Image(getSnapshotImage(reporrtGenFigure,rpt));
image06.Width = '3in';
image06.Height = [];

figure(7)
reporrtGenFigure = Figure();
image07 = Image(getSnapshotImage(reporrtGenFigure,rpt));
image07.Width = '3in';
image07.Height = [];

figure(8)
reporrtGenFigure = Figure();
image08 = Image(getSnapshotImage(reporrtGenFigure,rpt));
image08.Width = '3in';
image08.Height = [];

figure(9)
reporrtGenFigure = Figure();
image09 = Image(getSnapshotImage(reporrtGenFigure,rpt));
image09.Width = '3in';
image09.Height = [];

t = Table({image06,image07;image08,image09;...
    'peaks(20)','peaks(40)';'peaks(60)','peaks(80)'});
add(rpt,t);
close(rpt);
rptview(rpt);