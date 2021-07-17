function Voilation = constraint(X,PD)
Pi = sum(X,2);
Voilation = zeros(length(Pi),1);
for cv = 1: length(Pi)
    if (Pi(cv)~=PD)
        Voilation(cv)=abs((Pi(cv)-PD));
    end
end