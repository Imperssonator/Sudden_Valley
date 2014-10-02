LOADED_STRUCT = load('OFET.mat');
OFETcopy = LOADED_STRUCT.OFET;
%disp(OFETcopy)

A = [];
for x = 1:length(OFETcopy)
    A(1,x) = OFETcopy(x).Mn;
    A(2,x) = OFETcopy(x).RTMob;
    A(3,x) = OFETcopy(x).HR;
    A(4,x) = OFETcopy(x).BP;
end

[m,n] = size(A); % m is number of parameters, n is number of devices

testifvec = [];
% count1 = 0;
% count2 = 0;
COUNT = zeros(m,1);

%% Find NaNs in MW, BP, HR, RTMob...
for y = 1:m
    for z = 1:n
        if(isnan(A(y,z)))
            testifvec(y,z) = false;
            A(y,z) = 0;
            %             if y == 1
            %                 count(1) = count(1) + 1;
            %             elseif y == 2
            %                 count2 = count2 + 1;
            %             end
            COUNT(y) = COUNT(y)+1; % count up how many NaNs exist for a particular parameter
        else testifvec(y,z) = true;
        end
    end
end

%% Find Average values of the non-NaNs
sums = sum(A,2);
disp(sums)
% avg_val(1) = sums(1)/(length(A)-count1); % compute average value of each parameter excluding NaNs
% 
avg_val = zeros(m,1);
disp(n)
disp(COUNT)
for ii = 1:m
    avg_val(ii) = sums(ii)/(n-COUNT(ii));
end
disp(avg_val)
% avg_val(2) = sums(2)/(length(A)-count2);

%% Replace the NaNs
for y = 1:m
    for z = 1:n
        if testifvec(y,z) == false
            %             if y == 1
            %                 A(y,z) = avg_val(1);
            %             elseif y == 2
            %                 A(y,z) = avg_val(2);
            %             end
            A(y,z) = avg_val(y);
        end
    end
end

%% Add Spun, Dipped, or Dropped as x, y and z
% first we assign relative weights to each process. A higher weight means
% it allows more time for solvent evaporation. These are paratmeters that
% we will also have to change.
Proc_Vec = zeros(2,1); % initialize where we will store the values

% Change the following so that Proc_Vec has two variables, which will go in
% A(5,:) and A(6,:) 

for ii = 1:length(OFETcopy)
    if isequal(OFETcopy(ii).CoatProc,'Spun')
        Proc_Vec(:,ii)=[0; 0];
    elseif isequal(OFETcopy(ii).CoatProc,'Dipped')
        Proc_Vec(:,ii)=[1; 0];
    elseif isequal(OFETcopy(ii).CoatProc,'Dropped')
        Proc_Vec(:,ii)=[0; 1];
    end
end

A = [A; Proc_Vec];
%disp(A)

%% Diagnostics
%disp(A)
% whos A
% sum(find(A(4)==0))
% bls = regress(A(2,:),[ones(1,92) A(1,:)]);

% Right here, you need to add something that turns this into log(A). I
% think you could just do A= log(A)

%% Logarithmic Model
disp('_____________')
disp('Log regression over MW')
X = [ones(69,1) log(A(1,1:69)')]; % doing a regression against MW only for spun
M = log(A(2,1:69)'); % mobility
[brob, bint, r,rint,stats] = regress(M,X);
SUMSQ = sum(r.^2);
disp(brob)
% disp(x)
disp(stats)

%% Logarithmic Model 3 parameter
disp('_____________')
disp('Log regression over MW and BP')
X = [ones(length(A),1) log(A(1,:)') log(A(4,:)')]; % doing a regression against MW and BP
M = log(A(2,:)'); % mobility
[brob3, bint3, r3,rint3,stats3] = regress(M,X);
SUMSQ3 = sum(r3.^2);
disp(brob3)
% disp(x)
disp(stats3)

%% Linear Model
disp('_____________')
disp('Linear regression with MW, BP, and two params for dip and drop')
X1 = [ones(length(A),1) A(1,:)' A(4,:)' A(5,:)' A(6,:)'];
M1 = A(2,:)';
[brob1, bint1, r1, rint1, stats1] = regress(M1,X1);
SUMSQ1 = sum(r1.^2);
disp(brob1)
disp(stats1)


% Aspun = A(:,1:69); %This section is to get a 3D scatter with different colors for each processing type
% Adip = A(:,70:75);
% Adrop = A(:,76:92);
% hold on;
% scatter3(Aspun(1,:),Aspun(3,:),Aspun(2,:),36,'blue')
% scatter3(Adip(1,:),Adip(3,:),Adip(2,:),36,'red')
% scatter3(Adrop(1,:),Adrop(3,:),Adrop(2,:),36,'green')

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
