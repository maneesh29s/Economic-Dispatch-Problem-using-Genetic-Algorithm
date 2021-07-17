function y = mutate (p, D, sigma)
j = randi(D);

y = p;

r = randn(size(p));

y(j) = p(j)+ r(j)*sigma;

end