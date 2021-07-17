function wind_total_cost = windcost(Scheduled_wind_power)
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
    % Wind calculation. w = power. wr = rated power
    Prw0 = 1 - exp(-(Vin/scale_factor)^(shape_factor)) + exp(-(Vout/scale_factor)^(shape_factor));  % power at w = 0
    Prwwr = exp(-(Vr/scale_factor)^(shape_factor)) - exp(-(Vout/scale_factor)^(shape_factor));      % power at w = wr

    rated_wind_power = No_Turbine * Pr;
    ratio_of_velocity = (Vr - Vin)/Vin;

    Prwwu = @ (w)   (w -  Scheduled_wind_power)/rated_wind_power * (shape_factor*ratio_of_velocity*Vin/scale_factor)*(((1+(w/rated_wind_power*ratio_of_velocity))*Vin/scale_factor)^(shape_factor-1))*(exp(-(((1+(w/rated_wind_power*ratio_of_velocity))*Vin/scale_factor)^(shape_factor))));
    wundesti = integral(Prwwu, Scheduled_wind_power, rated_wind_power, 'ArrayValue', true);

    Wind_underestimation_cost = Cpwj * wundesti + (rated_wind_power-Scheduled_wind_power)*Prwwr*Cpwj;

    Prwwo = @ (w)   (Scheduled_wind_power-w)/rated_wind_power* (shape_factor*ratio_of_velocity*Vin/scale_factor)*(((1+(w/rated_wind_power*ratio_of_velocity))*Vin/scale_factor)^(shape_factor-1))*(exp(-(((1+(w/rated_wind_power*ratio_of_velocity))*Vin/scale_factor)^(shape_factor))));
    woveresti = integral(Prwwo, 0, Scheduled_wind_power, 'ArrayValue', true);

    Wind_overestimation_cost = Crwj * woveresti + (Scheduled_wind_power-0)*Prw0*Crwj;

    direct_cost = Scheduled_wind_power*direct_wind_cost_coe;


    wind_total_cost = Wind_underestimation_cost + Wind_overestimation_cost + direct_cost;
end

