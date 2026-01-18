%% Zgjidhja e ODE me Euler dhe Midpoint
clc; clear; close all;

% --- Definimi i ODE ---
% Dyshimi: dy/dx = f(x,y)
f = @(x,y) y - x.^2 + 1;   % shembull: y' = y - x^2 + 1
y_exact = @(x) (x+1).^2 - 0.5*exp(x); % zgjidhja eksakte për krahasim

% --- Parametrat e integrimit ---
x0 = 0; y0 = 0.5; % kushtet fillestare
xf = 2;            % fundi i intervalit
N = 10;            % numri i hapave
h = (xf - x0)/N;   % hapi i integrimit

% --- Inicializimi i vektoreve ---
x = x0:h:xf;
y_euler = zeros(size(x));
y_mid = zeros(size(x));
y_exact_vals = y_exact(x);

y_euler(1) = y0;
y_mid(1) = y0;

%% 1. Metoda e Euler-it
for i = 1:N
    y_euler(i+1) = y_euler(i) + h*f(x(i),y_euler(i));
end

%% 2. Metoda e Pikës së Mesit (Midpoint)
for i = 1:N
    k1 = f(x(i), y_mid(i));
    k2 = f(x(i) + h/2, y_mid(i) + h/2*k1);
    y_mid(i+1) = y_mid(i) + h*k2;
end

%% 3. Vizualizimi
figure;
plot(x, y_exact_vals, 'k-', 'LineWidth', 2); hold on;
plot(x, y_euler, 'bo-', 'LineWidth', 1.5, 'MarkerSize',6);
plot(x, y_mid, 'rs--', 'LineWidth', 1.5, 'MarkerSize',6);
xlabel('x'); ylabel('y');
legend('Zgjidhja eksakte','Euler','Midpoint','Location','northwest');
title('Zgjidhja e ODE me Euler dhe Midpoint');
grid on;

%% 4. Krahasimi në tabelë
T = table(x', y_exact_vals', y_euler', y_mid', ...
    abs(y_euler'-y_exact_vals'), abs(y_mid'-y_exact_vals'), ...
    'VariableNames', {'x','Exact','Euler','Midpoint','Error_Euler','Error_Midpoint'});

disp('Tabela e krahasimit:');
disp(T);
