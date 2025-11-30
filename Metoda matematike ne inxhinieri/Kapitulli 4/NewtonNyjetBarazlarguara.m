clc; clear; close all;

% =======================================================
% 1) Parametrat – intervali dhe numri i nyjeve
% =======================================================
a = 1;          % skaji i majte (ln(x) kerkon x>0)
b = 4;          % skaji i djathte
n = 6;          % numri i nyjeve (mund ta ndryshosh)

% =======================================================
% 2) Nyjet e barazlarguara dhe vlerat e funksionit ln(x)
% =======================================================
x = linspace(a, b, n);   % nyje te barazlarguara
y = log(x);              % ln(x) ne nyje

% =======================================================
% 3) Tabela e diferencave te ndara (divided differences)
%    DD(i,1) = y_i
%    DD(i,j) = (DD(i+1,j-1) - DD(i,j-1)) / (x_{i+j-1} - x_i)
% =======================================================
DD = zeros(n, n);
DD(:,1) = y(:);

for j = 2:n          % kolona
    for i = 1:(n-j+1)   % rreshti
        DD(i,j) = (DD(i+1,j-1) - DD(i,j-1)) / (x(i+j-1) - x(i));
    end
end

% Koeficientet e Newtonit ndodhen ne rreshtin e pare:
% c0 = DD(1,1), c1 = DD(1,2), ..., c_{n-1} = DD(1,n)

% =======================================================
% 4) Vleresimi i polinomit te Newtonit ne rrjet te dendur
%    P(x) = c0 + c1(x-x0) + c2(x-x0)(x-x1) + ...
% =======================================================
xx = linspace(a, b, 400);    % rrjet i dendur per grafik
P  = zeros(size(xx));        % vlerat e polinomit te Newtonit

for k = 1:length(xx)
    t = xx(k);
    p = DD(1,1);     % c0
    prod = 1;
    for j = 2:n
        prod = prod * (t - x(j-1));   % (x - x0)(x - x1)...
        p = p + DD(1,j) * prod;      % shtojme c_j * prod
    end
    P(k) = p;
end

% Funksioni i sakte ln(x)
f = log(xx);

% =======================================================
% 5) Grafik: ln(x) vs polinomi i Newtonit
% =======================================================
figure;
plot(xx, f, 'k-', 'LineWidth', 2); hold on;
plot(xx, P, 'r--', 'LineWidth', 2);
plot(x, y, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 8);
grid on;
xlabel('x');
ylabel('y');
title(sprintf('Interpolimi i Newtonit me nyje te barazlarguara (n = %d)', n));
legend('f(x) = ln(x)', 'Polinomi i Newtonit', 'Nyjet', 'Location', 'best');

% =======================================================
% 6) Grafik i gabimit |ln(x) - P(x)|
% =======================================================
err = abs(f - P);

figure;
plot(xx, err, 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('|ln(x) - P(x)|');
title('Gabimi absolut i interpolimit te Newtonit');
