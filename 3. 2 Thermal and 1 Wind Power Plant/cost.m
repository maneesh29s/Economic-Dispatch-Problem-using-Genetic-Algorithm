function Z = cost(X1,alpha, beta, gama, PD , lambda)
Voilation = constraint(X1,PD);
yy = length (X1(:,1));
thermal_generation_cost = zeros(yy,1);
for co = 1:yy
    thermal_generation_cost(co) = sum(alpha + beta.*X1(co,1:2)+gama.*(X1(co,1:2).^(2)));
end

wind_generation_cost = zeros(yy,1);

for co = 1:yy
    Scheduled_wind_power = X1(co,3);
    wind_generation_cost(co) = windcost(Scheduled_wind_power);
end

Z = thermal_generation_cost + wind_generation_cost + lambda .* Voilation;

end


