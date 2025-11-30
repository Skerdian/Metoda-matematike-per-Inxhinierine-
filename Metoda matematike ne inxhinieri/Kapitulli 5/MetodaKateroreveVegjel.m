clc;
clear;
close all;

% --------------------------------
% TË DHËNAT
% --------------------------------
x = [1 4 7 9];
y = [4 7 10 8];

n = length(x);

% --------------------------------
% METODA E KATRORËVE MË TË VEGJËL
% y ? a x + b
% --------------------------------
X = [x' ones(n,1)];         % matrica e dizajnit
A = (X' * X) \ (X' * y');   % zgjidhja LS

a = A(1);   % pjerrësia
b = A(2);   % intercepti

fprintf('Vija e përafrimit (LS): y = %.6f x + %.6f\n', a, b);

% Vlerat e përafruara në pikat ekzistuese
y_fit = a*x + b;

% --------------------------------
% KOEFCIENTI I KORRELACIONIT r
% --------------------------------
Sx  = sum(x);
Sy  = sum(y);
Sxx = sum(x.^2);
Syy = sum(y.^2);
Sxy = sum(x.*y);

r = (n*Sxy - Sx*Sy) / sqrt( (n*Sxx - Sx^2) * (n*Syy - Sy^2) );

fprintf('Koeficienti i korrelacionit r = %.6f\n', r);
fprintf('r^2 (coef. i determinimit)   = %.6f\n', r^2);

% --------------------------------
% GRAFIKU: PIKAT + VIJA E PËRAFRIMIT
% --------------------------------
xx = linspace(min(x), max(x), 200);
yy = a*xx + b;

figure;
plot(x, y, 'ro', 'MarkerSize', 8, 'LineWidth', 2); hold on;
plot(xx, yy, 'b-', 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('y');
title('Metoda e katrorëve më të vegjël - Regresion linear');
legend('Pikat eksperimentale', 'Vija e përafrimit', 'Location', 'best');
