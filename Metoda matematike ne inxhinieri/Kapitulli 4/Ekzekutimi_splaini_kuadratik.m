% Ky skedar perdor funksionin cubic_spline_natural.m
%
% Si ta perdorni:
%   1) Vendosni te dy skedaret ne te njejtin folder
%   2) Ne MATLAB: shko ne ate folder dhe ekzekuto:
%         run_cubic_spline_demo
%
% Mund ta ndryshoni funksionin/nyjet me poshte sipas nevojes.

clear; clc; close all;

% -----------------------------
% Shembull 1: Interpolim i nje funksioni te dhene
% -----------------------------
f = @(x) 1./(1 + 25*x.^2);     % Funksioni Runge ne [-1,1]
a = -1; b = 1;

n = 11;                        % numri i nyjeve (p.sh. 11)
x = linspace(a,b,n);
y = f(x);

[S, coeffs] = cubic_spline_natural(x, y);

xx = linspace(a,b,1000);
yy = S(xx);

figure;
plot(x, y, 'o', 'LineWidth', 1.2); hold on;
plot(xx, yy, '-', 'LineWidth', 1.4);
plot(xx, f(xx), '--', 'LineWidth', 1.2);
grid on;
xlabel('x');
ylabel('y');
legend('Nyjet (x,y)', 'Spline kubik natyror', 'Funksioni ekzakt', 'Location', 'best');
title('Interpolimi me spline kubik natyror');

% Gabimi maksimal ne rrjetin e vleresimit
err = max(abs(yy - f(xx)));
fprintf('Gabimi maksimal |S(x)-f(x)| ne rrjet: %.6e\n', err);

% -----------------------------
% Shembull 2: Vleresim ne pika te veçanta
% -----------------------------
xq = [-0.75 -0.3 0 0.4 0.9];
yq = S(xq);

disp('Pika testimi dhe vlerat e spline-it:');
disp(table(xq(:), yq(:), 'VariableNames', {'x', 'Sx'}));

% -----------------------------
% Shfaq koeficientet per çdo interval
% -----------------------------
% coeffs(i,:) = [a_i b_i c_i d_i] per [x(i), x(i+1)]
disp('Koeficientet per intervalet [x(i), x(i+1)] : [a b c d]');
disp(coeffs);



