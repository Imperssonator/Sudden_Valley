function OFET = Xls2Struct(DirectoryPath)

% Directory path = the file path of the folder that has Directory.xlsx in
% it

[NN, TT, Directory] = xlsread(DirectoryPath);

MainPath = Directory{2,2};
FileNames = Directory(3:end,1);

OFET=struct();
NumDevs = 0;

for p = 1:size(FileNames,1)
    XLSFile = [MainPath FileNames{p,1} '/' FileNames{p,1} '.xlsx'];
    [ndata, text, alldata] = xlsread(XLSFile);
    [ProcVars,Devs] = size(alldata); % Number of process variables, number of devices (columns in spreadsheet)

    for j = 2:Devs
        NumDevs = NumDevs+1;
        for i = 1:ProcVars
            cat = alldata(i,1); % category = name of process variable in row i
            cellij = alldata(i,j); % store value of that process variable in cellji
            OFET(NumDevs).(cat{1})=cellij{1}; %store the value of cellji in the OFET structure
        end
        
        OFET = ClearEmpty(OFET);
        
        OFET(NumDevs) = AddSolventProps(OFET(NumDevs));
    end
end

OFET = ClearEmpty(OFET);
save('OFETDatabase.mat','OFET')

end