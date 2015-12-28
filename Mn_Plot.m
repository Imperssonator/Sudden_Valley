figure
hold on

for i = 1:length(OFET)
    if isequal(OFET(i).Depo,'SPUN')
        plot(OFET(i).Mn,OFET(i).RTMob,'ob')
    elseif isequal(OFET(i).Depo,'DIPPED')
        plot(OFET(i).Mn,OFET(i).RTMob,'xr')
    else
        plot(OFET(i).Mn,OFET(i).RTMob,'*g')
    end
end