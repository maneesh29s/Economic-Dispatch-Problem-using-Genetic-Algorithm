function Voilation = constraint(X2,PD)
SUM_POWER = sum(X2,2);
Voilation = zeros(length(SUM_POWER),1);
for cv = 1: length(SUM_POWER)
    if (SUM_POWER(cv)~=PD)
        Voilation(cv)=abs((SUM_POWER(cv)-PD));
    end
end