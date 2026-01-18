% REGRESION EKSPONENCIAL JO-LINEAR ME METODËN E GRADIENTIT
% Implementim manual duke përdorur derivatet e funksionit të gabimit

clear;
clc;
close all;

%% 1. GJENERIMI I TË DHËNAVE SHEMBULL
fprintf('================================================================\n');
fprintf('REGRESION EKSPONENCIAL - METODA E GRADIENTIT\n');
fprintf('================================================================\n');

% Parametrat e vërtetë
a_true = 2.5;  % Vlera e vërtetë e parametrit a
b_true = 0.8;  % Vlera e vërtetë e parametrit b

% Krijoni të dhëna sintetike
x = (0:0.5:5)';                     % Variabla e pavarur
n = length(x);                      % Numri i vëzhgimeve
y_true = a_true * exp(b_true * x);  % Vlera të vërteta pa zhurmë
y_data = y_true + 0.3 * randn(n, 1); % Të dhëna me zhurmë të rastësishme

fprintf('Të dhënat e gjeneruara:\n');
fprintf('Numri i pikave: %d\n', n);
fprintf('Vlerat e vërteta: a = %.3f, b = %.3f\n', a_true, b_true);
fprintf('---------------------------------------------------------------\n');

%% 2. DEFINIMI I FUNKSIONIT TË GABIMIT DHE DERIVATIVEVE
% Modeli: y = a * exp(b*x)
% Funksioni i gabimit: J = (1/(2n)) * sum((y_data - a*exp(b*x))^2)
% Derivatet:
% dJ/da = -(1/n) * sum((y_data - a*exp(b*x)) * exp(b*x))
% dJ/db = -(1/n) * sum((y_data - a*exp(b*x)) * a*x*exp(b*x))

% Funksioni për llogaritjen e gabimit dhe derivateve
function [J, dJ_da, dJ_db] = compute_gradient(a, b, x, y_data)
    n = length(x);
    y_pred = a * exp(b * x);
    errors = y_data - y_pred;
    
    % Funksioni i gabimit
    J = (1/(2*n)) * sum(errors.^2);
    
    % Derivatet
    dJ_da = -(1/n) * sum(errors .* exp(b * x));
    dJ_db = -(1/n) * sum(errors .* a .* x .* exp(b * x));
end

%% 3. PARAMETRAT E ALGORITMIT
% Vlerat fillestare për parametrat
a = 1.0;    % Vlerë fillestare për a
b = 0.3;    % Vlerë fillestare për b

% Parametrat e zbritjes së gradientit
learning_rate = 0.05;   % Shkalla e të mësuarit
max_iterations = 5000;  % Numri maksimal i përsëritjeve
tolerance = 1e-8;       % Toleranca për konvergjencë

fprintf('Parametrat e algoritmit:\n');
fprintf('Vlerat fillestare: a0 = %.3f, b0 = %.3f\n', a, b);
fprintf('Learning rate: %.4f\n', learning_rate);
fprintf('Iteracione maksimale: %d\n', max_iterations);
fprintf('Toleranca: %.2e\n', tolerance);
fprintf('---------------------------------------------------------------\n');

%% 4. ZBRITJA E GRADIENTIT (GRADIENT DESCENT)
fprintf('Duke ekzekutuar zbritjen e gradientit...\n');

% Vektorë për ruajtjen e historikut
a_history = zeros(max_iterations, 1);
b_history = zeros(max_iterations, 1);
J_history = zeros(max_iterations, 1);

% Përsëritja kryesore e zbritjes së gradientit
for iter = 1:max_iterations
    % Llogarit gabimin dhe derivatet
    [J, dJ_da, dJ_db] = compute_gradient(a, b, x, y_data);
    
    % Ruaj historikun
    a_history(iter) = a;
    b_history(iter) = b;
    J_history(iter) = J;
    
    % Përditëso parametrat
    a_new = a - learning_rate * dJ_da;
    b_new = b - learning_rate * dJ_db;
    
    % Kontrollo konvergjencën
    if iter > 1
        delta_J = abs(J_history(iter) - J_history(iter-1));
        if delta_J < tolerance
            fprintf('Konvergjenca arritur në iteracionin %d!\n', iter);
            fprintf('Ndryshimi në gabim: %.2e\n', delta_J);
            break;
        end
    end
    
    % Caktimi i vlerave të reja
    a = a_new;
    b = b_new;
    
    % Shfaq progresin çdo 500 iteracione
    if mod(iter, 500) == 0
        fprintf('Iteracioni %4d: J = %.6f, a = %.4f, b = %.4f\n', iter, J, a, b);
    end
end

% Nëse arrihet numri maksimal i iteracioneve
if iter == max_iterations
    fprintf('Arritur numri maksimal i iteracioneve (%d)\n', max_iterations);
end

% Prerja e vektorëve të historikut
a_history = a_history(1:iter);
b_history = b_history(1:iter);
J_history = J_history(1:iter);

%% 5. REZULTATET
fprintf('\n---------------------------------------------------------------\n');
fprintf('REZULTATET PËRFUNDIMTARE:\n');
fprintf('---------------------------------------------------------------\n');
fprintf('Parametrat e gjetur:\n');
fprintf('  a = %.6f (e vërteta: %.6f)\n', a, a_true);
fprintf('  b = %.6f (e vërteta: %.6f)\n', b, b_true);
fprintf('Gabimi relativ:\n');
fprintf('  Δa = %.4f%%\n', 100 * abs(a - a_true) / abs(a_true));
fprintf('  Δb = %.4f%%\n', 100 * abs(b - b_true) / abs(b_true));
fprintf('\nStatistikat e përshtatjes:\n');
fprintf('  Iteracione të kryera: %d\n', iter);
fprintf('  Gabimi përfundimtar (J): %.6e\n', J_history(end));
fprintf('---------------------------------------------------------------\n');

% Llogarit R-squared
y_pred = a * exp(b * x);
SS_res = sum((y_data - y_pred).^2);
SS_tot = sum((y_data - mean(y_data)).^2);
R2 = 1 - SS_res / SS_tot;
fprintf('  R-squared: %.4f\n', R2);
fprintf('---------------------------------------------------------------\n');

%% 6. VIZUALIZIMET
% Figura 1: Të dhënat dhe modeli
figure('Position', [100, 100, 1000, 800]);

subplot(2, 2, 1);
plot(x, y_data, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'Të dhënat');
hold on;
x_fine = linspace(min(x), max(x), 100)';
y_fine = a * exp(b * x_fine);
plot(x_fine, y_fine, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Modeli: y=%.3f·exp(%.3f·x)', a, b));
plot(x, y_true, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Modeli i vërtetë');
grid on;
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title('Regresioni Eksponencial', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 10);
axis tight;

% Figura 2: Konvergjenca e funksionit të gabimit
subplot(2, 2, 2);
plot(1:iter, J_history, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('Iteracioni', 'FontSize', 12);
ylabel('Gabimi (J)', 'FontSize', 12);
title('Konvergjenca e Funksionit të Gabimit', 'FontSize', 14);
set(gca, 'YScale', 'log');  % Shkallë logaritmike për gabimin
axis tight;

% Figura 3: Rruga e parametrave
subplot(2, 2, 3);
plot(a_history, b_history, 'b.-', 'LineWidth', 1.5, 'MarkerSize', 10);
hold on;
plot(a_true, b_true, 'rx', 'MarkerSize', 15, 'LineWidth', 2, 'DisplayName', 'Vlera e vërtetë');
plot(a, b, 'go', 'MarkerSize', 12, 'LineWidth', 2, 'DisplayName', 'Vlera përfundimtare');
xlabel('Parametri a', 'FontSize', 12);
ylabel('Parametri b', 'FontSize', 12);
title('Rruga e Parametrave në Hapësirën a-b', 'FontSize', 14);
legend('Location', 'best', 'FontSize', 10);
grid on;

% Figura 4: Gabimet e mbetura
subplot(2, 2, 4);
residuals = y_data - y_pred;
plot(x, residuals, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
hold on;
plot([min(x), max(x)], [0, 0], 'r--', 'LineWidth', 1.5);
grid on;
xlabel('x', 'FontSize', 12);
ylabel('Gabimet e mbetura', 'FontSize', 12);
title('Gabimet e Mbetura', 'FontSize', 14);
axis tight;

%% 7. ANALIZË SHTESË E MODELIT
fprintf('\nANALIZË SHTESË E MODELIT:\n');
fprintf('---------------------------------------------------------------\n');

% Llogarit intervalet e besimit të përafërta (metodë e thjeshtë)
% Përdorim përafrimin e Jakobianit për llogaritjen e kovariancës
J_matrix = zeros(n, 2);
for i = 1:n
    exp_bx = exp(b * x(i));
    J_matrix(i, 1) = exp_bx;                     % Derivati në lidhje me a
    J_matrix(i, 2) = a * x(i) * exp_bx;          % Derivati në lidhje me b
end

% Kovarianca e parametrave
residual_variance = sum(residuals.^2) / (n - 2);
cov_params = residual_variance * inv(J_matrix' * J_matrix);

% Gabimet standarde
se_a = sqrt(cov_params(1, 1));
se_b = sqrt(cov_params(2, 2));

fprintf('Gabimet standarde:\n');
fprintf('  SE(a) = %.6f\n', se_a);
fprintf('  SE(b) = %.6f\n', se_b);
fprintf('\nIntervalet 95%% besimi:\n');
fprintf('  a: %.6f ± %.6f  [%.6f, %.6f]\n', a, 1.96*se_a, a-1.96*se_a, a+1.96*se_a);
fprintf('  b: %.6f ± %.6f  [%.6f, %.6f]\n', b, 1.96*se_b, b-1.96*se_b, b+1.96*se_b);
fprintf('---------------------------------------------------------------\n');

%% 8. TESTIMI I MODELIT ME TË DHËNA TË REJA
fprintf('\nTESTIMI I MODELIT:\n');
fprintf('---------------------------------------------------------------\n');

% Krijoni të dhëna të reja testuese
x_test = [5.5; 6.0; 6.5];  % Pika të reja për testim
y_test_true = a_true * exp(b_true * x_test);
y_test_pred = a * exp(b * x_test);

fprintf('Parashikimet për pikat e reja:\n');
for i = 1:length(x_test)
    fprintf('  x = %.1f: y_vërtetë = %.4f, y_parashikuar = %.4f, gabim = %.4f\n', ...
        x_test(i), y_test_true(i), y_test_pred(i), abs(y_test_true(i)-y_test_pred(i)));
end
fprintf('---------------------------------------------------------------\n');

%% 9. FUNKSIONI PËR PËRDORIM TË PËRSËRITSHËM
% Funksioni që mund të përdoret për të përshtatur modele të reja
function [a_opt, b_opt, history] = exponential_regression_gd(x_data, y_data, a_init, b_init, alpha, max_iter)
    % Funksion për kryerjen e regresionit eksponencial me zbritje gradienti
    % Input:
    %   x_data, y_data: të dhënat
    %   a_init, b_init: vlerat fillestare të parametrave
    %   alpha: shkalla e të mësuarit
    %   max_iter: numri maksimal i iteracioneve
    % Output:
    %   a_opt, b_opt: parametrat e optimizuar
    %   history: strukturë me historikun e optimizimit
    
    n = length(x_data);
    a = a_init;
    b = b_init;
    
    % Inicializimi i historikut
    history.a = zeros(max_iter, 1);
    history.b = zeros(max_iter, 1);
    history.J = zeros(max_iter, 1);
    
    % Zbritja e gradientit
    for iter = 1:max_iter
        % Llogarit parashikimet
        y_pred = a * exp(b * x_data);
        errors = y_data - y_pred;
        
        % Funksioni i gabimit
        J = (1/(2*n)) * sum(errors.^2);
        
        % Derivatet
        dJ_da = -(1/n) * sum(errors .* exp(b * x_data));
        dJ_db = -(1/n) * sum(errors .* a .* x_data .* exp(b * x_data));
        
        % Ruaj historikun
        history.a(iter) = a;
        history.b(iter) = b;
        history.J(iter) = J;
        
        % Përditësimi i parametrave
        a = a - alpha * dJ_da;
        b = b - alpha * dJ_db;
        
        % Kontrolli i konvergjencës
        if iter > 1 && abs(history.J(iter) - history.J(iter-1)) < 1e-8
            % Prerja e historikut
            history.a = history.a(1:iter);
            history.b = history.b(1:iter);
            history.J = history.J(1:iter);
            break;
        end
    end
    
    a_opt = a;
    b_opt = b;
end

%% 10. SHEMBULL I PËRDORIMIT TË FUNKSIONIT
fprintf('\nSHEMBULL I PËRDORIMIT TË FUNKSIONIT:\n');
fprintf('---------------------------------------------------------------\n');

% Përdorimi i funksionit për të kryer regresionin
[a_func, b_func, history] = exponential_regression_gd(x, y_data, 1.0, 0.3, 0.05, 5000);

fprintf('Rezultatet nga funksioni:\n');
fprintf('  a = %.6f\n', a_func);
fprintf('  b = %.6f\n', b_func);
fprintf('  Iteracione: %d\n', length(history.J));
fprintf('  Gabimi përfundimtar: %.6e\n', history.J(end));
fprintf('================================================================\n');

%% 11. KRAHASIMI I REZULTATEVE
% Paraqitni krahasimin midis metodave të ndryshme
figure('Position', [200, 200, 800, 400]);

% Metoda e zbritjes së gradientit
y_gd = a * exp(b * x);

% Metoda e linearizimit (për krahasim)
log_y = log(y_data);
p = polyfit(x, log_y, 1);
a_lin = exp(p(2));
b_lin = p(1);
y_lin = a_lin * exp(b_lin * x);

subplot(1, 2, 1);
plot(x, y_data, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k', 'DisplayName', 'Të dhënat');
hold on;
plot(x, y_gd, 'r-', 'LineWidth', 2, 'DisplayName', 'Zbritja e gradientit');
plot(x, y_lin, 'b--', 'LineWidth', 2, 'DisplayName', 'Linearizimi');
grid on;
xlabel('x');
ylabel('y');
title('Krahasimi i Metodave');
legend('Location', 'northwest');
axis tight;

subplot(1, 2, 2);
bar(1:2, [abs(a-a_true)/a_true, abs(b-b_true)/b_true; abs(a_lin-a_true)/a_true, abs(b_lin-b_true)/b_true] * 100);
set(gca, 'XTickLabel', {'Zbritja Gradientit'; 'Linearizimi'});
ylabel('Gabim relativ (%)');
title('Gabimi relativ i parametrave');
legend({'a'; 'b'}, 'Location', 'northwest');
grid on;

fprintf('\nKRAHASIMI I METODAVE:\n');
fprintf('---------------------------------------------------------------\n');
fprintf('Metoda              a          b      Gabim a%%   Gabim b%%\n');
fprintf('---------------------------------------------------------------\n');
fprintf('Zbritja Gradientit  %.4f     %.4f     %.2f       %.2f\n', ...
    a, b, 100*abs(a-a_true)/a_true, 100*abs(b-b_true)/b_true);
fprintf('Linearizimi         %.4f     %.4f     %.2f       %.2f\n', ...
    a_lin, b_lin, 100*abs(a_lin-a_true)/a_true, 100*abs(b_lin-b_true)/b_true);
fprintf('================================================================\n');
