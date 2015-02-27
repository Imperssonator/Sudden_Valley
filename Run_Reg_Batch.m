%% Run Batch of Regressions

clear all
clc

% Consider logarithmic and exponential non-linear transformations of data
% variables

XL2STRUCT();
[Data, R, VarNames] = Struct2Data();

CondensedData = Data(:,[1 3 4 5 13]); % Take Mn, HR, BP, InitConc, CoatProc
CondensedVarNames = VarNames([1 3 4 5 13]);

LogData = log(CondensedData);
% ExpData = exp(CondensedData);

CombinedData = [CondensedData, LogData];

PolyDeg = 3;
NPerms = 4;

WhichVars = (1:size(CombinedData,2));

CombinedVarNames = [CondensedVarNames;...
                    cellfun(@(x) Append_VarName(x,'Log'),CondensedVarNames,'UniformOutput',false)];...
%                     cellfun(@(y) Append_VarName(y,'Exp'),CondensedVarNames,'UniformOutput',false)];

[REG, ERR] = Run_Regress(CombinedData,R,WhichVars,NPerms,PolyDeg,CombinedVarNames);


