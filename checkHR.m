OFET = load('OFET.mat');
OFET = OFET.OFET;
count = 0;
for i = 1:length(OFET)
    if isnan(OFET(i).HR)
        count = count+1
    end
end
