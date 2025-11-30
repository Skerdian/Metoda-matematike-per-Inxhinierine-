% EkzekutimiLagranzhiInterpolim.m
% Interpolimi i Lagranzhit + polinomi i shkruar qarte dhe i printuar

clc; clear; close all;

%% 1) Pikat e dhena (nyjet) (x_i, y_i)
x_nodes = [0 1 2 3];      % nyjet
y_nodes = [1 2 0 5];      % vlerat e funksionit ne nyje

n = length(x_nodes);

%% 2) Ndertimi i polinomit interpolues ne forme standarde
% P(x) = p(1)*x^(n-1) + ... + p(n-1)*x + p(n)

p = zeros(1, n);    % koeficientet e P(x), fillimisht zero

for i = 1:n
    % Nderto polinomin baze L_i(x) si polinom ne forme koeficientesh
    % L_i(x) = prod_{j != i} (x - x_j)/(x_i - x_j)
    Li = 1;         % polinom konstante 1 -> vektor [1]
    denom = 1;      % produkti i (x_i - x_j)

    for j = 1:n
        if j ~= i
            % Shumezo polinomisht me (x - x_j)
            Li = conv(Li, [1, -x_nodes(j)]);
            denom = denom * (x_nodes(i) - x_nodes(j));
        end
    end

    Li = Li / denom;         % L_i(x) pas pjesetimit me produktin

    % Shto kontributin y_i * L_i(x) ne polinomin total P(x)
    p = p + y_nodes(i) * Li;
end

%% 3) Shfaq koeficientet dhe polinomin P(x)
disp('Koeficientet e polinomit te interpolimit P(x):');
disp(p);

% Printo polinomin si string, pa Symbolic Toolbox
poly_str = poly_to_string(p, 'x');
disp('Polinomi i interpolimit:');
disp(poly_str);

%% 4) Zgjedh nje pike xp dhe llogarit P(xp)
xp = 1.5;
Pxp = polyval(p, xp);
fprintf('P(%.4f) = %.10f\n', xp, Pxp);

%% 5) Grafiku i polinomit interpolues
xx = linspace(min(x_nodes), max(x_nodes), 400);
yy = polyval(p, xx);

figure;
plot(xx, yy, 'LineWidth', 2); hold on;
plot(x_nodes, y_nodes, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'r');    % nyjet
plot(xp, Pxp, 's', 'MarkerSize', 8, 'MarkerFaceColor', 'g');             % pika e interpoluar

grid on;
xlabel('x');
ylabel('P(x)');
title('Interpolimi i Lagranzhit - Polinomi i interpolimit');
legend('P(x) (polinomi)', 'Nyjet (x_i, y_i)', 'P(x_p)', 'Location', 'Best');


