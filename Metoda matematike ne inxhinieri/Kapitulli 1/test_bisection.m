% Shembull perdorimi i metodës së biseksionit

f = @(x) x.^3 - x - 2;

a = 1;
b = 2;

tol = 1e-6;
maxIter = 100;

[root, iter] = bisection(f, a, b, tol, maxIter);

fprintf('Rrenja e përafërt: %.8f\n', root);
fprintf('Numri i iteracioneve: %d\n', iter);
