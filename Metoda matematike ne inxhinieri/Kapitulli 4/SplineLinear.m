% spline_linear_simple.m
% Spline linear ne pikat (1,2), (2,3), (4,1)

clc; clear; close all;

% Pikat (x_i, y_i)
x = [1 2 4];
y = [2 3 1];

% Numri i segmenteve
n = length(x) - 1;

% Llogaritim shpjetesite (koeficientet e drejtëzave ne çdo segment)
m = zeros(1,n);   % pjerrësitë
b = zeros(1,n);   % konstantet

for i = 1:n
    m(i) = (y(i+1) - y(i)) / (x(i+1) - x(i));   % koeficienti para x
    b(i) = y(i) - m(i)*x(i);                    % termi konstant
end

disp('Segmentet lineare (spline linear):');
for i = 1:n
    fprintf('Ne [%g, %g]:  S_%d(x) = %.4f*x + %.4f\n', ...
        x(i), x(i+1), i, m(i), b(i));
end

% Vleresim i spline linear ne nje rrjet me pika
xx = linspace(x(1), x(end), 200);
yy = zeros(size(xx));

for k = 1:length(xx)
    % gjej segmentin ku bie xx(k)
    if xx(k) <= x(2)
        i = 1;
    else
        i = 2;
    end
    yy(k) = m(i)*xx(k) + b(i);
end

% Mund te kontrollosh dhe me interp1 i MATLAB-it (opsionale):
yy_builtin = interp1(x, y, xx, 'linear');

% Grafik
figure;
plot(xx, yy, 'LineWidth', 2); hold on;
plot(x, y, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % pikat origjinale
grid on;
xlabel('x');
ylabel('S(x)');
title('Spline linear ne pikat (1,2), (2,3), (4,1)');
legend('Spline linear (manual)', 'Pikat (x_i, y_i)', 'Location', 'Best');
