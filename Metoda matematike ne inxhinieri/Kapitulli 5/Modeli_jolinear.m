%% Shembull MATLAB: Model jolinear dhe eksponencial me MKV

clc; clear; close all;

% --- Të dhënat e shembullit ---
x = [0 1 2 3 4 5]';  % variabla e pavarur
y = [2.1 2.9 4.1 7.2 11.3 18.0]'; % variabla e varur

%% 1. Modeli jolinear: y = a*x + b
X_lin = [x ones(size(x))]; % matrica për MKV
theta_lin = X_lin \ y;    % zgjidhja MKV

a_lin = theta_lin(1);
b_lin = theta_lin(2);

y_fit_lin = a_lin*x + b_lin;

fprintf('Modeli jolinear: y = %.3f*x + %.3f\n', a_lin, b_lin);

%% 2. Modeli eksponencial: y = c*exp(d*x)
% Marrim logaritmin për ta bërë linear
Y_log = log(y); % log(y) = log(c) + d*x
X_exp = [x ones(size(x))]; 
theta_exp = X_exp \ Y_log; 

d_exp = theta_exp(1);
log_c = theta_exp(2);
c_exp = exp(log_c);

y_fit_exp = c_exp * exp(d_exp * x);

fprintf('Modeli eksponencial: y = %.3f * exp(%.3f*x)\n', c_exp, d_exp);

%% 3. Vizualizimi
figure;
plot(x, y, 'ko', 'MarkerSize',8,'LineWidth',1.5); hold on;
plot(x, y_fit_lin, 'b-', 'LineWidth',2);
plot(x, y_fit_exp, 'r--', 'LineWidth',2);
xlabel('x'); ylabel('y');
legend('Të dhënat','MKV Jolinear','MKV Eksponencial','Location','northwest');
title('Përshtatja me MKV: Model Jolinear vs Eksponencial');
grid on;
