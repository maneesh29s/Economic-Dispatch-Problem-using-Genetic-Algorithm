clc;
clear;
close all;

%% Problem formulation
%% Thermal Power Plants
X_limit=[200 450
         150 350];
X_min = X_limit(:,1)';
X_max = X_limit(:,2)';
PD = 800;
alpha = [500 400];
beta = [5.3 5.5];
gama = [0.004 0.006];
%% Wind Power Plants
No_Turbine = 50;
Pr = 4; % rated power each turbine
Vin = 3;
Vr = 10;
Vout = 20;
direct_wind_cost_coe = 0.08;
Cpwj = [10];    % penalty cost
Crwj = [4];     % reserved supply cost
shape_factor = 2;   % k
scale_factor = 9;    % c

rated_wind_power = No_Turbine * Pr;
ratio_of_velocity = (Vr - Vin)/Vin;

X_min(1,3) = 0;
X_max(1,3) = rated_wind_power;

D = length(X_min(1,:));

%% GA Parameters
Max_iter = 1000;
np = 200;
pc = 0.7;
mu = 0.2;
nc = round(pc*np/2);              % number of crossovers
nm = round(np*mu);
sigma=0.1;
lambda = 1000;          % voilation cost multiplier

%% Initialization
X = repmat (X_min, np ,1) + rand(np,D).* (repmat (X_max, np ,1) - repmat (X_min, np ,1));

Z = cost(X,alpha, beta, gama, PD , lambda);

[best_cost,ii] = min(Z);
best_parameter= X(ii,:);
 
%% Main loop
prob = zeros(np,1);
W = zeros(1,Max_iter);

for it = 1:Max_iter
    % selection probabilities
    fitness_function = 1./(1 + Z);
    for k = 1:np
        prob(k,:) = fitness_function(k,:)/sum(fitness_function);
    end
    
    Zcross=zeros(nc,2);
    Y1 = zeros(nc,D);
    Y2 = zeros(nc,D);
    
    for j = 1:nc
        % select parents
        P1 = RouletteWheelSelection(prob);
        P2 = RouletteWheelSelection(prob);
        
        % perform crossover
        [Y1(j,:),Y2(j,:)] = uniform_crossover (P1, P2, D, X , X_min, X_max);           % create 2 offspring
        Zcross(j,1) = cost(Y1(j,:),alpha, beta, gama, PD , lambda);         % sphere value of 1st offspring
        Zcross(j,2) = cost(Y2(j,:),alpha, beta, gama, PD , lambda);         % sphere value of 2nd offspring
    end
    Ycross=[Y1;Y2];             % convert all to a column matrix [nc*2,2]
    Zcross=Zcross(:);           % convert all to a column matrix [nc*2,1]
    
    y=zeros(nm,D);
    Zmutate=zeros(nm,1);
    for i=1:nm
        % Select Parent
        m=randi([1 np]);
        p=X(m,:);
        
        % Apply Mutation
        y(i,:) = mutate (p, D, sigma);
        
        Zmutate(i,:) = cost(y(i,:),alpha, beta, gama, PD , lambda);
    end
    Ymutate=y;
    % Create Merged Population
    Zga=[Z
         Zcross
         Zmutate];          % shape [np + nc*2 + nm , 1]
    Yga=[X
         Ycross
         Ymutate];                % shape [np + nc*2 + nm , 3]
     
    % Sort Population
    [Zga, SortOrder]=sort(Zga);
    Yga=Yga(SortOrder,:);
    
    % Update Worst Cost
    WorstCost=max(Zga);
    
    % Truncation
    Z=Zga(1:np,:);
    Y=Yga(1:np,:);
        
    % Store Best Solution Ever Found
    best_iter_parameter=Yga(1,:);
    
    % Store Best Cost Ever Found
    best_iter_cost_value = Zga(1,:);
    
    if best_iter_cost_value < best_cost
        best_cost = best_iter_cost_value;
        best_parameter = best_iter_parameter;        
    end
    W(it) = best_cost;
    % Show Iteration Information
    fprintf('it = %f best_cost_value = %f X1 = %f X2 = %f X3 = %g\n', it, best_cost, best_parameter)
    
end

% Results

figure;
plot(W,'LineWidth',2);
xlabel('Iteration');
ylabel('Cost');
grid on;

final_cost=cost(best_parameter,alpha, beta, gama,PD , lambda);
voilation = constraint(best_parameter , PD);
wind_generation_cost = windcost(best_parameter(1,3));
thermal_generation_cost = final_cost - wind_generation_cost - lambda*voilation;