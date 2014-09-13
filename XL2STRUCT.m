clear all
clc

[ndata, text, alldata] = xlsread('OFET fab table copy.xlsx'); % all cells in spreadsheet saved as cell arrays in "alldata"

OFET = struct(); % initialize the structure
for i = 3:71 %columns of spin coated devices
    for j = 1:29 % rows of process variables
        cat = alldata(j,2); % category = name of process variable in row j
        cellji = alldata(j,i); % store value of that process variable in cellji
        OFET(i-2).(cat{1})=cellji{1}; %
    end
    OFET(i-2).CoatProc='Spun';
end

[m,n] = size(OFET);
for i = 3:8
    for j = 33:60
        cat = alldata(j,2);
        cellji = alldata(j,i);
        OFET(i-2+n).(cat{1})=cellji{1};
    end
    OFET(i-2+n).CoatProc='Dipped';
end
[m,n]=size(OFET);
for i = 3:19
    for j = 64:91
        cat = alldata(j,2);
        cellji = alldata(j,i);
        OFET(i-2+n).(cat{1})=cellji{1};
    end
    OFET(i-2+n).CoatProc='Dropped';
end

save('OFET.mat','OFET');