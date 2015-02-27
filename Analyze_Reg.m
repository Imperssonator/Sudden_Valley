function [P Fval] = Analyze_Reg(REG,ERR)

[lowErr, minRows] = min(ERR);

BestFits = REG(1,1).r;

for i = 1:size(minRows,2)
    BestFits(i) = REG(minRows(i),i).r;
end

[LowestErr, AbsoluteBest] = min(lowErr);

CoefMatrix = [BestFits(AbsoluteBest).PowerMatrix, BestFits(AbsoluteBest).Coefficients];
[m,n] = size(CoefMatrix);

ProcPropFunc = @(X) -sum(sum((repmat(X,[m 1]).^CoefMatrix(:,1:n-1)).*repmat(CoefMatrix(:,n),[1 n-1])));

StartGuess = [60,200,1];

[P Fval] = fmincon(ProcPropFunc,StartGuess,[],[],[],[],[0 0 0],[300 500 2]);


end