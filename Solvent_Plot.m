function Solvent_Plot(X1, Y1, X2, Y2)
%CREATEFIGURE(X1, Y1, X2, Y2)
%  X1:  vector of x data
%  Y1:  vector of y data
%  X2:  vector of x data
%  Y2:  vector of y data

%  Auto-generated by MATLAB on 09-Dec-2014 14:53:15

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'FontSize',14);
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[6.883 7.38532499999999]);
hold(axes1,'all');

% Create plot
plot(X1,Y1,'MarkerSize',12,'Marker','o','LineStyle','none',...
    'Color',[0.168627455830574 0.505882382392883 0.337254911661148]);

% Create plot
plot(X2,Y2);

% Create xlabel
xlabel('Hansen Radius','FontSize',16);

% Create ylabel
ylabel('Mobility (cm^2/V-s)','FontSize',16);

% Create title
title('Chlorobenzene/Acetone','FontSize',16);
