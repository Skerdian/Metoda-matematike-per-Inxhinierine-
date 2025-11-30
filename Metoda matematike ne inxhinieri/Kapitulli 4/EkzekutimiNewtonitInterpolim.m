% newton_interp_krahasim.m
% Krahasimi i funksionit ekzakt me polinomin e Newtonit

clc; clear; close all;

%% 1) Percakto funksionin dhe nyjet
f = @(x) exp(x);        % funksioni i vertete f(x)
a = 0; b = 2;           % intervali [a,b]
x_nodes = linspace(a, b, 5);   % nyjet e interpolimit (mund t'i ndryshosh)
y_nodes = f(x_nodes);          % vlerat e funksionit ne nyje

n = length(x_nodes);

%% 2) Ndertimi i tabeles se diferencave te ndara (Newton)
D = zeros(n,n);
D(:,1) = y_nodes(:);   % kolona e pare eshte vektori i y-ve

for j = 2:n
    for i = 1:n-j+1
        D(i,j) = (D(i+1,j-1) - D(i,j-1)) / (x_nodes(i+j-1) - x_nodes(i));
    end
end

% koeficientet e polinomit te Newtonit
a_newton = D(1,:);

%% 3) Zgjedh nje pike xp, krahaso vleren ekzakte dhe te perafruar
xp = 0.7;                       % pika ku duam krahasimin
exact_val   = f(xp);            % vlera ekzakte
approx_val  = newton_eval(a_newton, x_nodes, xp);  % vlera e perafruar

fprintf('Pika xp = %.4f\n', xp);
fprintf('f(xp)      (ekzakte)   = %.10f\n', exact_val);
fprintf('P_N(xp)    (Newton)    = %.10f\n', approx_val);
fprintf('Gabimi |f(xp) - P_N(xp)| = %.3e\n', abs(exact_val - approx_val));

%% 4) Nderto grafikun per krahasim ne nje rrjet te dendur
xx = linspace(a, b, 400);
yy_exact  = f(xx);
yy_newton = arrayfun(@(t) newton_eval(a_newton, x_nodes, t), xx);

figure;
plot(xx, yy_exact, 'LineWidth', 2); hold on;
plot(xx, yy_newton, '--', 'LineWidth', 2);
plot(x_nodes, y_nodes, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % nyjet
plot(xp, exact_val, 's', 'MarkerSize', 8, 'MarkerFaceColor', 'g');    % pika xp (ekzakte)
plot(xp, approx_val, 'd', 'MarkerSize', 8, 'MarkerFaceColor', 'r');   % pika xp (Newton)

grid on;
xlabel('x');
ylabel('vlera');
title('Krahasimi: funksioni ekzakt vs interpolimi i Newtonit');
legend('f(x) ekzakt', 'Polinomi i Newtonit', 'Nyjet', ...
       'f(x_p)', 'P_N(x_p)', 'Location', 'Best');

%% (Opsionale) Grafik i gabimit ne tere intervalin
figure;
plot(xx, abs(yy_exact - yy_newton), 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('|f(x) - P_N(x)|');
title('Gabimi absolut midis funksionit dhe interpolimit te Newtonit');