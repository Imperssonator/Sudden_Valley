function AA = Find_Hansen(OFET)

%% AA stores Hansen parametes and solvent fractions:
% It is 7xN, with the following rows:
% solvent 1: dd, dp, dh,
% solvent 2: dd, dp, dh;
% volume fraction of solvent 1

AA = zeros(7,length(OFET));


for i = 1:length(OFET)
    AA(1:3,i) = Hansen_Lookup(OFET(i).Solv1) - Hansen_Lookup('P3HT');
    if not(isnan(OFET(i).Solv2))
        AA(4:6,i) = Hansen_Lookup(OFET(i).Solv2) - Hansen_Lookup('P3HT');
        AA(7,i) = OFET(i).VFSolv1;
    else
        AA(7,i) = 1;
    end
end

end