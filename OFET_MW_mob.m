LOADED_STRUCT = load('OFET.mat');
OFETcopy = LOADED_STRUCT.OFET;
disp(OFETcopy)

A = [];
for x = 1:length(OFETcopy)
    A(1,x) = OFETcopy(x).Mn;
    A(2,x) = OFETcopy(x).RTMob;
    A(3,x) = OFETcopy(x).HR;
end
    
testifvec = [];
count1 = 0;
count2 = 0;
for y = 1:2
    for z = 1:length(A)
        if(isnan(A(y,z))) 
            testifvec(y,z) = false;
            A(y,z) = 0;
            if y == 1
                count1 = count1 + 1;
            elseif y == 2
                count2 = count2 + 1;
            end
        else testifvec(y,z) = true;
        end
    end
end

sums = sum(A,2);
avg_val(1) = sums(1)/(length(A)-count1);
avg_val(2) = sums(2)/(length(A)-count2);

for y = 1:2
    for z = 1:length(A)
        if testifvec(y,z) == false
            if y == 1
                A(y,z) = avg_val(1);
            elseif y == 2
                A(y,z) = avg_val(2);
            end
        end
    end
end

% bls = regress(A(2,:),[ones(1,92) A(1,:)]);

% Right here, you need to add something that turns this into log(A). I
% think you could just do A= log(A)
X = [ones(length(A),1) log(A(1,:)') log(A(3,:))'];
M = log(A(2,:)');
[brob, bint, r,rint,stats] = regress(M,X);
disp(brob)
% disp(x)
disp(stats)
% loglog(A(1,:),A(2,:),'ob');
% %grid on;
% hold on;
% title('Mobility vs Mn')
% xlabel('Mn')
% ylabel('Mobility')
% % 
% % plot(A(1,:),bls(1)+bls(2)*x,'r','LineWidth',2);
% Y = exp(brob(1)+brob(2).*log(A(1,:)));
% plot(A(1,:),Y,'og')
% 
% legend('Data','Ordinary Least Squares','Robust Regression')