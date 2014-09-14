clear all
clc

[ndata, text, alldata] = xlsread('OFET fab table copy.xlsx'); % all cells in spreadsheet saved as cell arrays in "alldata"
[m1,n1] = size(alldata);
OFET = struct(); % initialize the structure
for i = 3:n1 %columns of spin coated devices, assumes that a plurality of devices are spun
    for j = 1:29 % rows of process variables
        cat = alldata(j,2); % category = name of process variable in row j
        cellji = alldata(j,i); % store value of that process variable in cellji
        OFET(i-2).(cat{1})=cellji{1}; %store the value of cellji in the OFET structure at i-2 because we started at 3
    end
    OFET(i-2).CoatProc='Spun';
end

[m,n] = size(OFET);
first_blank_vec = cellfun(@isnan,alldata(43,3:end)); %vector of 0's and 1's that say whether there is a value for "BP" in that column
last_filled = find(first_blank_vec,1,'first')+1; %returns the last column in "DIPPED", +1 is because I want last filled, not first blank
for i = 3:last_filled
    for j = 33:60
        cat = alldata(j,2);
        cellji = alldata(j,i);
        OFET(i-2+n).(cat{1})=cellji{1};
    end
    OFET(i-2+n).CoatProc='Dipped';
end

[m,n]=size(OFET);
first_blank_vec = cellfun(@isnan,alldata(74,3:end)); %vector of 0's and 1's that say whether there is a value for "BP" in that column
last_filled = find(first_blank_vec,1,'first')+1; %returns the last column in "DIPPED", +1 is because I want last filled, not first blank

for i = 3:last_filled
    for j = 64:91
        cat = alldata(j,2);
        cellji = alldata(j,i);
        OFET(i-2+n).(cat{1})=cellji{1};
    end
    OFET(i-2+n).CoatProc='Dropped';
end

save('OFET.mat','OFET');