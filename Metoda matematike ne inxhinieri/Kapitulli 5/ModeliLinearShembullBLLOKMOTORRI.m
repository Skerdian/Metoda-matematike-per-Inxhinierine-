clc;
clear;
close all;

% ----------------------------------------
% 1) Te dhenat eksperimentale (t, T)
% ----------------------------------------
t = [0 2 4 6 8]';          % koha (min)
T = [100.0 75.3 58.7 47.6 40.1]';   % temperatura (°C)

% ----------------------------------------
% 2) Funksioni i modelit T(t) = c + a e^{-k t}
%    dhe funksioni i katroreve me te vegjel S(c,a,k)
%    S(x) = sum( (T_i - Tmodel_i)^2 )
%    x = [c, a, k]
% ----------------------------------------
S = @(x) sum( ( T - ( x(1) + x(2)*exp(-x(3)*t ) ) ).^2 );

% ----------------------------------------
% 3) Vleresimi fillestar i parametrave [c, a, k]
%    (mund ta ndryshosh nese do)
% ----------------------------------------
x0 = [30; 60; 0.1];   % c0 ? 30°C, a0 ? 60, k0 ? 0.1

% ----------------------------------------
% 4) Minimizo funksionin S me fminsearch (MKV jolineare)
% ----------------------------------------
options = optimset('Display','iter','TolX',1e-8,'TolFun',1e-8);
[x_est, S_min] = fminsearch(S, x0, options);

c_est = x_est(1);
a_est = x_est(2);
k_est = x_est(3);

fprintf('Parametrat e vleresuar (MKV jo-linear):\n');
fprintf('  c = %.6f °C\n', c_est);
fprintf('  a = %.6f\n',     a_est);
fprintf('  k = %.6f  1/min\n', k_est);
fprintf('Minimumi i S(c,a,k) = %.6e\n', S_min);

% ----------------------------------------
% 5) Grafik krahasues: te dhenat vs modeli
% ----------------------------------------
t_plot = linspace(min(t), max(t), 200);
T_model = c_est + a_est * exp(-k_est * t_plot);

figure;
plot(t, T, 'ro', 'MarkerSize', 8, 'LineWidth', 2); hold on;
plot(t_plot, T_model, 'b-', 'LineWidth', 2);
grid on;
xlabel('Koha t (min)');
ylabel('Temperatura T (°C)');
title('Regresioni me MKV jo-linear: T(t) = c + a e^{-k t}');
legend('Të dhënat eksperimentale', 'Modeli i përshtatur', 'Location', 'northeast');
