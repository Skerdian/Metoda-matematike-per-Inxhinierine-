% test_broyden.m
clc; clear;

% Sistemi F(x) ne R^2
F = @(x) [ ...
    x(1)^2 + x(2)^2 - 4;   % f1(x,y)
    exp(x(1)) + x(2) - 1   % f2(x,y)
];

% vektori fillestar (zgjidhe afersisht prane rrenjes)
x0 = [1; 1];

% thirr metoda sekante multi-dimensionale (Broyden me J numerik)
[x_sol, k] = broyden_secant(F, x0, 1e-8, 50);

fprintf('\nZgjidhja aproksimuese pas %d iteracionesh:\n', k);
fprintf('x = [%.10f  %.10f]\n', x_sol(1), x_sol(2));
fprintf('||F(x)||_inf = %.3e\n', norm(F(x_sol), inf));

