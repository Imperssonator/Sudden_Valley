
clear all
clc

% This function converts the XLSX spreadsheet into a MATLAB struct

[ndata, text, alldata] = xlsread('OFET fab table copy.xlsx'); % all cells in spreadsheet saved as cell arrays in "alldata"
% ndata = numerical matrix of just numerical cells, alldata = cell array of
% all information
[m1,n1] = size(alldata);
% disp(n1)

OFET = struct(); % initialize the structure


first_blank_vec = cellfun(@isnan,alldata(12,3:end)); %vector of 0's and 1's that say whether there is a value for "BP" in that column
if ~any(first_blank_vec)
    last_filled = n1;
else
    last_filled = find(first_blank_vec,1)+1; %returns the last column in "SPUN", +1 is because I want last filled, not first blank
end

whos

for ii = 3:last_filled % columns of spin coated devices, assumes that a plurality of devices are spun
    for j = 1:29 % rows of process variables
        cat = alldata(j,2); % category = name of process variable in row j
        cellji = alldata(j,ii); % store value of that process variable in cellji
        OFET(ii-2).(cat{1})=cellji{1}; %store the value of cellji in the OFET structure at i-2 because we started at 3
    end
    disp(length(OFET))
    OFET(ii-2).CoatProc='Spun';
end

for ii = 1:3
    disp(ii)
end

[m,n] = size(OFET) % recalc size on each category to prevent overwrite
first_blank_vec = cellfun(@isnan,alldata(43,3:end)); %vector of 0's and 1's that say whether there is a value for "BP" in that column
last_filled = find(first_blank_vec,1,'first')+1; %returns the last column in "DIPPED", +1 is because I want last filled, not first blank
disp(last_filled)

for ii = 3:last_filled
    disp(ii)
    for j = 33:60
        cat = alldata(j,2);
        cellji = alldata(j,ii);
        OFET(ii-2+n).(cat{1})=cellji{1};
    end
    OFET(ii-2+n).CoatProc='Dipped';
end

[m,n]=size(OFET)
first_blank_vec = cellfun(@isnan,alldata(74,3:end)); %vector of 0's and 1's that say whether there is a value for "BP" in that column
last_filled = find(first_blank_vec,1,'first')+1; %returns the last column in "DROPPED", +1 is because I want last filled, not first blank

for ii = 3:last_filled
    for j = 64:91
        cat = alldata(j,2);
        cellji = alldata(j,ii);
        OFET(ii-2+n).(cat{1})=cellji{1};
    end
    OFET(ii-2+n).CoatProc='Dropped';
end

save('OFET.mat','OFET');
