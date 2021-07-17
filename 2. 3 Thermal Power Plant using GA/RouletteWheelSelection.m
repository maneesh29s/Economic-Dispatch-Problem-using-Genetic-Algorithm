function ij = RouletteWheelSelection(prob)
    r=rand;
    
    c=cumsum(prob);
    
    ij=find(r<=c,1,'first');
end