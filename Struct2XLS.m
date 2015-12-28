function C = Struct2Cell(S)

FN = fieldnames(S);
[m n] = size(S);

XCell = cell(n+1,length(FN));

for j = 1:length(FN)
    XCell{1,j} = FN{j};
end

for i = 2:n
    for j = 1:length(FN)
        XCell{i,j} = S(i).(FN{j});
    end
end

C = XCell;
% xlswrite('OFET.xls',XCell);

end