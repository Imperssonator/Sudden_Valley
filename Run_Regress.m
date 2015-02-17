function [REG, ERR] = Run_Regress(Data,R,WhichVars,N)
% Take filled-in data matrix as input, and vector of mobilities R, as well
% as 'WhichVars', a row vector of which variables of Data to use, and N,
% how many of those to use at a time at max

%% Create permutation vectors
% In order to run regressions on all possible combinations of the chosen
% variables
Combos = {};

for i = 1:N
    Combosi = nchoosek(WhichVars,i);
    for j = 1:length(Combosi)
        Combos = [Combos; Combosi(j,:)];
    end
end
disp(Combos)

Len = length(Combos);
ERR = zeros(Len,3);
count = 0;
REG = struct();

%% Run Regression
% Generate regression parameters and errors for each combination up to the
% 3rd degree

for i = 1:Len
    for j = 1:3
        disp('____')
        count = count+1;
        lmn = Combos{i};
        reg = MultiPolyRegress(Data(:,lmn),R,j);
        ERR(i,j) = reg.CVMAE;
        REG(count).r = reg;
    end
end

