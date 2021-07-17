function [Y1, Y2] = uniform_crossover (P1, P2,D, X, X_min, X_max)
zeta = rand (1,D);
Y1 = zeta.*X(P1,:) + (1-zeta).*X(P2,:);
Y2 = zeta.*X(P2,:) + (1-zeta).*X(P1,:);

% check boundary condition
a=find (Y1<X_min);
Y1(a) = X_min(a);
b=find (Y1>X_max);
Y1(b) = X_max(b);
c=find (Y2<X_min);
Y1(c) = X_min(c);
d=find (Y2>X_max);
Y1(d) = X_max(d);
end