clear all;
clc;
close all;


lambda = 8.0;           % initial lambda value (assumed)

PD = 800;               % total dispatched power 
BB = [ 0 ; 0 ; 0 ];        % no transmission loss given
alpha = [ 500 400 200 ];
beta = [ 5.3 5.5 5.8 ];
gamma = [ 0.004 0.006 0.009 ];
X_limit=[200 450
         150 350
         100 225];
D = length (X_limit(:,1));  
P = zeros(1,D);

X_min = X_limit(:,1)';
X_max = X_limit(:,2)';
del_P = 0;
del_lambda = 0;
PL = 0;
max_iter = 500;

for k = 1:max_iter
    for i = 1:D
        P(i) = ( lambda - beta(i) ) / ( 2 * ( gamma(i) + lambda *  BB(i) ) ) ;
        if P(i) < X_min(i)
            P(i) = X_min(i);
        elseif P(i) > X_max(i)
            P(i) = X_max(i);
        end   
    end

%    PL = (P.^2) * BB;       % Power loss

    del_P = PD + PL - sum(P);

%    del_P_lambda = 0;
%     for i = 1:2
%         del_P_lambda = del_P_lambda +( ( gamma(i) + BB(i) .* beta(i) ) / ( 2 * ( ( gamma(i) + lambda *  BB(i) ).^2 ) ) ) ;
%     end

%    del_lambda = del_P / del_P_lambda;
    
    del_lambda = del_P / sum(1./(2*gamma));
    lambda = lambda + del_lambda;
    
    fprintf('iter = %i   P_generated = %f   P1 = %f   P2 = %f  P3 = %f\n', k, sum(P), P(1) , P(2) , P(3) );
end

final_cost = sum(alpha +  beta.*P +gamma.* (P.^(2)) );



