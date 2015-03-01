function Updated = OFETFilter(Old,Field,HoldValue)

NumDevs = length(Old);
Updated = struct();
if length(Old)<1
    return
end

KeepVec = [];
if isnan(HoldValue)
    for i = 1:NumDevs
        if isnan(Old(i).(Field))
            KeepVec = [KeepVec i];
        end
    end
else
    for i = 1:NumDevs
        if isequal(Old(i).(Field),HoldValue)
            KeepVec = [KeepVec i];
        end
    end
end

Updated = Old(KeepVec);

end