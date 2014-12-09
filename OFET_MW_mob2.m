clear all
close all
clc

XL2STRUCT;

LOADED_STRUCT = load('OFET.mat');
OFETcopy = LOADED_STRUCT.OFET;
%disp(OFETcopy)

A = [];
for x = 1:length(OFETcopy)
    A(1,x) = OFETcopy(x).Mn;
    A(2,x) = OFETcopy(x).RTMob;
    A(3,x) = OFETcopy(x).HR;
    A(4,x) = OFETcopy(x).BP;
    A(5,x) = OFETcopy(x).InitConc;
end

%% Separate Hansen Parameters

for x = 1:length(OFETcopy)
    AA = Find_Hansen(OFETcopy);
end

% AA is a 7xN matrix:
% It is 7xN, with the following rows:
% solvent 1: dd, dp, dh,
% solvent 2: dd, dp, dh;
% volume fraction of solvent 1

% All of the d's are relative to P3HT. So P3HT is now the origin of Hansen
% Space

% Start with a linear model: B'*AA = 


%% Find NaNs in MW, BP, HR, RTMob...
[AAr, AAc] = size(AA);
for d = 1:3
    for e = 1:AAc
        AA(d,e) = AA(d,e) * AA(7,e);   %Multiply the effect of each HR parameter for Solv1 by its volume fraction
    end
end

for d = 4:6
    for e = 1:AAc
        AA(d,e) = AA(d,e) * (1-AA(7,e));   %Multiply the effect of each HR parameter for Solv2 by its volume fraction
    end
end

A = [A; AA];

[m,n] = size(A); % m is number of parameters, n is number of devices

testifvec = [];
% count1 = 0;
% count2 = 0;
COUNT = zeros(m,1);

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
%disp(sums)
% avg_val(1) = sums(1)/(length(A)-count1); % compute average value of each parameter excluding NaNs
% 
avg_val = zeros(m,1);
%disp(n)
%disp(COUNT)
for ii = 1:m
    avg_val(ii) = sums(ii)/(n-COUNT(ii));
end
%disp(avg_val)
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

Proc_Vec2 = zeros(2,1);
for i = 1:length(OFETcopy)
    if isequal(OFETcopy(i).ProcEnv,'N2')
        Proc_Vec2(:,i)=[0; 0];
    elseif isequal(OFETcopy(i).ProcEnv,'Vacuum')
        Proc_Vec2(:,i)=[1; 0];
    elseif isequal(OFETcopy(i).ProcEnv,'air')
        Proc_Vec2(:,i)=[0; 1];
    end
end

A = [A; Proc_Vec; Proc_Vec2];

%disp(A)

% %% Diagnostics
% %disp(A)
% % whos A
% % sum(find(A(4)==0))
% % bls = regress(A(2,:),[ones(1,92) A(1,:)]);
% 
% % Right here, you need to add something that turns this into log(A). I
% % think you could just do A= log(A)
% 
% %% Logarithmic Model
% disp('_____________')
% disp('Log regression over MW')
% X = [ones(69,1) log(A(1,1:69)')]; % doing a regression against MW only for spun
% M = log(A(2,1:69)'); % mobility
% [brob, bint, r,rint,stats] = regress(M,X);
% SUMSQ = sum(r.^2);
% disp(brob)
% % disp(x)
% disp(stats)
% 
% %% Logarithmic Model 3 parameter
% disp('_____________')
% disp('Log regression over MW and BP')
% X = [ones(length(A),1) log(A(1,:)') log(A(4,:)')]; % doing a regression against MW and BP
% M = log(A(2,:)'); % mobility
% [brob3, bint3, r3,rint3,stats3] = regress(M,X);
% SUMSQ3 = sum(r3.^2);
% disp(brob3)
% % disp(x)
% disp(stats3)
% 
% %% Linear Model
% disp('_____________')
% disp('Linear regression with MW, BP, and two params for dip and drop')
% X1 = [ones(length(A),1) A(1,:)' A(4,:)' A(5,:)' A(6,:)'];
% M1 = A(2,:)';
% [brob1, bint1, r1, rint1, stats1] = regress(M1,X1);
% SUMSQ1 = sum(r1.^2);
% disp(brob1)
% disp(stats1)

%% Linear Model for Individual Hansen Parameters

% Your X1 will be [ones, AA(1,:)', AA(2,:)'....] so it will be N x 8, where
% there are N devices, and 8 variables, thus there are 8 parameters in B

% disp('_____________')
% disp('Linear regression with 3 HR params for Solv1, 3 HR params for Solv2')
% X1 = [ones(length(A),1) A(1,:)' (A(4,:).^2)' (A(6,:).^2)' (A(7,:).^2)' (A(8,:).^2)' (A(9,:).^2)' (A(10,:).^2)' (A(11,:).^2)' A(13,:)' A(14,:)'];
% M1 = A(2,:)';
% [brob1, bint1, r1, rint1, stats1] = regress(M1,X1);
% SUMSQ1 = sum(r1.^2);
% disp(brob1)
% disp(stats1)



%% Linear Model for Parabolas
disp('_____________')
disp('Linear regression with HR using 3-parameter Parabolic fit')
Asquare = A.^2;
X1 = [ones(6,1) A(3,29:34)' Asquare(3,29:34)'];
M1 = A(2,29:34)';
[brob1, bint1, r1, rint1, stats1] = regress(M1,X1);
SUMSQ1 = sum(r1.^2);
disp(brob1)
disp(stats1)
figure %open a figure window... every plot command will overlay on this figure
hold on % plot commands actually automatically erase whatever is in the existing figure
plot(A(3,29:34),A(2,29:34),'og','MarkerSize',12) % first we plot the real data points
fplot(@(x) brob1(1)+brob1(2)*x+brob1(3)*x^2,[min(A(3,29:34)), max(A(3,29:34))]) % next we plot the model, Mobility = B1 + B2x + B3x^2

X2 = [ones(6,1) [A(3,29) A(3,35:39)]' [Asquare(3,29) Asquare(3,35:39)]'];
M2 = [A(2,29) A(2,35:39)]';
[brob2, bint2, r2, rint2, stats2] = regress(M2,X2);
SUMSQ2 = sum(r2.^2);
disp(brob2)
disp(stats2)
figure %open a figure window... every plot command will overlay on this figure
hold on % plot commands actually automatically erase whatever is in the existing figure
plot([A(3,29) A(3,35:39)],[A(2,29) A(2,35:39)],'og','MarkerSize',12) % first we plot the real data points
fplot(@(x) brob2(1)+brob2(2)*x+brob2(3)*x^2,[min([A(3,29) A(3,35:39)]), max([A(3,29) A(3,35:39)])]) % next we plot the model, Mobility = B1 + B2x + B3x^2


X3 = [ones(6,1) A(3,40:45)' Asquare(3,40:45)'];
M3 = A(2,40:45)';
[brob3, bint3, r3, rint3, stats3] = regress(M3,X3);
SUMSQ3 = sum(r3.^2);
disp(brob3)
disp(stats3)
figure %open a figure window... every plot command will overlay on this figure
hold on % plot commands actually automatically erase whatever is in the existing figure
plot(A(3,40:45),A(2,40:45),'og','MarkerSize',12) % first we plot the real data points
fplot(@(x) brob3(1)+brob3(2)*x+brob3(3)*x^2,[min(A(3,40:45)), max(A(3,40:45))]) % next we plot the model, Mobility = B1 + B2x + B3x^2


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
