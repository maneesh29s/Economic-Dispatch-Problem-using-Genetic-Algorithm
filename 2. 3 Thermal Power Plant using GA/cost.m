function Z = cost(X1,alpha, beta, gama, PD , lambda)
Voilation = constraint(X1,PD);
yy = length (X1(:,1));
generation_cost = zeros(yy,1);
for co = 1:yy
    generation_cost(co) = generation_cost(co) + sum(alpha + beta.*X1(co,:)+gama.*(X1(co,:).^(2)));
end
Z = generation_cost + lambda .* Voilation;
end


