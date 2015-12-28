function [Trends, Filtered] = OFETBox(Constants,Variable)

%% OFET Box Plot
%
% OFET Box Plot is the grandaddy master function that takes all the marbles
% Tell it what variables you want to be held constant at what value as a
% cell array:
% {'Process Field', 'Value';...
%  'other process field', 'other value to hold constant'}
% New: Value can now be a vector with [LB, UB] if a range of values is
% desired

% And what variable you want to plot mobility against (must also be a valid process field):
% 'Variable'

% Returns Trends:
% [Variable value, Mobility;...
%  next variable value, mob]
% 
% It then makes a box plot based on the groups of string-based variable

load('OFETDatabase.mat');

Filtered = OFET; % Start with the full structure

NumConst = size(Constants,1); % How many constraints are there
if NumConst>0
    for c = 1:NumConst
        Field = Constants{c,1};
        HoldValue = Constants{c,2};
        Filtered = OFETFilter(Filtered,Field,HoldValue);
    end
else
end

% Remove Devices that don't have a reported value for "Variable"

Filtered = RemoveNans(Filtered,Variable);
Groups = cell(length(Filtered),1);
Mobs = zeros(length(Filtered),1);

if isnumeric(Filtered(1).(Variable))
    numeric = true;
else
    numeric = false;
end
if numeric
    for i = 1:length(Filtered)      % Build up the either numeric or string matrix 'Groups'
        Groups{i,1} = num2str(Filtered(i).(Variable));
        Mobs(i,1) = Filtered(i).RTMob;  % and the corresponding mobilities
    end
else
    for i = 1:length(Filtered)      % Build up the either numeric or string matrix 'Groups'
        Groups{i,1} = Filtered(i).(Variable);
        Mobs(i,1) = Filtered(i).RTMob;  % and the corresponding mobilities
    end
end

whos Groups
Groups
save('SearchDebug')

[trash, idx] = sort(Groups);    % sort the groups in ascending order
Trends = {Groups(idx,1), Mobs(idx,1)};  % combine groups and mobilities in a cell array, Nx2

% Create figure
figure

% Create ylabel
ylabel('Mobility (cm^2/V*s)');

% Create xlabel
xlabel(Variable);

% Create boxplot
boxplot(Trends{:,2},Trends{:,1},'colors','k','jitter',0.5,'symbol','ko','whisker',0)

end
