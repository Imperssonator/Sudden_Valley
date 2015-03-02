function [Trends, Filtered] = OFETSearch(Constants,Variable)

%% OFET Search
%
% OFET Search is the grandaddy master function that takes all the marbles
% Tell it what variables you want to be held constant at what value as a
% cell array:
% {'Process Field', 'Value';...
%  'other process field', 'other value to hold constant'}

% And what variable you want to plot mobility against (must also be a valid process field):
% 'Variable'

% Returns Trends:
% [Variable value, Mobility;...
%  next variable value, mob]
% 
% And outputs a plot

% Future functionality: determine a fitting function that best predicts the
% trend you're looking at

load('OFETDatabase.mat');

Filtered = OFET; % Start with the full structure

NumConst = size(Constants,1);

for c = 1:NumConst
    Field = Constants{c,1};
    HoldValue = Constants{c,2};
    Filtered = OFETFilter(Filtered,Field,HoldValue);
end

X1 = [Filtered(:).(Variable)]';
Y1 = [Filtered(:).RTMob]';
disp(size(X1))
disp(size(Y1))
Trends = [X1 Y1];

figure1 = figure;
X1 = Trends(:,1);
Y1 = Trends(:,2);

% Create axes
axes1 = axes('Parent',figure1,'FontSize',14);
box(axes1,'on');
hold(axes1,'on');
xlabel(Variable)
ylabel('Mobility (cm^2/V*s)')

% Create plot
plot(X1,Y1,'MarkerSize',8,'Marker','o','LineStyle','none','Color',[0 0 1]);


end
