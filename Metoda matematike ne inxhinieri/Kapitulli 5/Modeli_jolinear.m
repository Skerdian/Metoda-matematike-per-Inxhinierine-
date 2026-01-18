% REGRESION EKSPONENCIAL JO-LINEAR

% Pastro dritaren e komandave dhe workspace-in
clear;
clc;

% 1. Krijo të dhëna shembull (për testim)
% Zakonisht këto të dhëna i merrni nga matjet eksperimentale
x = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]';  % Variabla e pavarur
y_aktuale = 2.5 * exp(0.8 * x) + 0.5 * randn(size(x));      % Lidhja eksponenciale me zhurmë

% 2. Përcakto funksionin eksponencial të modelit
% Forma: y = a * exp(b * x)
% Ku: a dhe b janë parametrat që do të përshtaten
modeli_eksponencial = @(param, x) param(1) * exp(param(2) * x);

% 3. Vlerësimet fillestare për parametrat a dhe b
% Këto janë të rëndësishme për konvergjencën e algoritmit
vlerat_fillestare = [1.0, 0.5]; % [a_fillestar, b_fillestar]

% 4. Krye regresionin jo-linear duke përdorur lsqcurvefit
% ky është një algoritëm i bazuar në katrorët më të vegjël (least squares)
opsionet = optimoptions('lsqcurvefit', 'Display', 'iter'); % Shfaq procesin e optimizimit
[parametrat, resnorm] = lsqcurvefit(modeli_eksponencial, vlerat_fillestare, x, y_aktuale, [], [], opsionet);

% 5. Ekstrakto parametrat e përshtatura
a_perfituar = parametrat(1);
b_perfituar = parametrat(2);

% 6. Krijo vektor të dhënash të përshtatura (për vizualizim)
x_për_vizualizim = linspace(min(x), max(x), 100)'; % 100 pika të shënuara
y_perfituar = a_perfituar * exp(b_perfituar * x_për_vizualizim);

% 7. Vizualizimi i rezultateve
figure('Position', [100, 100, 800, 500]); % Krijoni një dritare të re grafiku

% Vizato të dhënat aktuale
plot(x, y_aktuale, 'bo', 'MarkerSize', 8, 'LineWidth', 2);
hold on;

% Vizato kurbën e përshtatur
plot(x_për_vizualizim, y_perfituar, 'r-', 'LineWidth', 2);
grid on;

% Shto etiketa dhe titull
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title('Regresioni Eksponencial Jo-Linear', 'FontSize', 14);
legend('Të dhënat aktuale', ['y = ', num2str(a_perfituar, '%.3f'), ' * e^{', num2str(b_perfituar, '%.3f'), 'x}'], ...
       'Location', 'northwest', 'FontSize', 11);

% 8. Shfaq parametrat e përshtatura në dritaren e komandave
fprintf('===============================================\n');
fprintf('REZULTATET E REGRESIONIT EKSPONENCIAL\n');
fprintf('===============================================\n');
fprintf('Parametri a (koeficienti): %.4f\n', a_perfituar);
fprintf('Parametri b (eksponenti): %.4f\n', b_perfituar);
fprintf('Norma e mbetur: %.6f\n', resnorm);
fprintf('===============================================\n');

% 9. (Opsionale) Llogarit R-squared (koeficienti i përcaktimit)
y_mesatar = mean(y_aktuale);
SS_total = sum((y_aktuale - y_mesatar).^2);
SS_residual = sum((y_aktuale - a_perfituar * exp(b_perfituar * x)).^2);
R_squared = 1 - (SS_residual / SS_total);
fprintf('R-squared: %.4f\n', R_squared);
fprintf('===============================================\n');