% REGRESION EKSPONENCIAL JO-LINEAR ME ZBRITJE GRADIENTI
% Metodë e bazuar në derivatin e funksionit të gabimit

clear;
clc;
close all;

%% 1. TË DHËNAT SHEMBULL
% Krijo të dhëna testuese me formën: y = a * exp(b*x) + zhurmë
a_veri = 2.5;    % Vlera e vërtetë e parametrit a
b_veri = 0.8;    % Vlera e vërtetë e parametrit b

x = (0:0.5:5)';                     % Variabla e pavarur
y_veri = a_veri * exp(b_veri * x);  % Vlera të vërteta pa zhurmë
y_masa = y_veri + 0.5*randn(size(x)); % Të dhëna të matura me zhurmë

n = length(x);  % Numri i pikave të të dhënave

%% 2. PARAMETRAT E ALGORITMIT TË ZBRITJES SË GRADIENTIT
alpha = 0.01;      % Shkalla e të mësuarit (learning rate)
num_iter = 1000;   % Numri i përsëritjeve
toleranca = 1e-6;  % Toleranca për konvergjencë

% Vlerat fillestare për parametrat
a = 1.0;  % Vlerë fillestare për a
b = 0.5;  % Vlerë fillestare për b

% Ruaj historikun e vlerave për vizualizim
hist_a = zeros(num_iter, 1);
hist_b = zeros(num_iter, 1);
hist_gabim = zeros(num_iter, 1);

%% 3. FUNKSIONI I GABIMIT DHE DERIVATET E TIJ
% Funksioni i gabimit: J = (1/2n) * Σ(y_masa - a*exp(b*x))^2
% Derivatet:
% ∂J/∂a = -(1/n) * Σ[(y_masa - a*exp(b*x)) * exp(b*x)]
% ∂J/∂b = -(1/n) * Σ[(y_masa - a*exp(b*x)) * a*x*exp(b*x)]

fprintf('================================================================\n');
fprintf('REGRESION EKSPONENCIAL ME ZBRITJE GRADIENTI\n');
fprintf('================================================================\n');
fprintf('Duke filluar me: a=%.4f, b=%.4f\n', a, b);
fprintf('Shkalla e të mësuarit (alpha): %.4f\n', alpha);
fprintf('Numri maksimal i përsëritjeve: %d\n', num_iter);
fprintf('Toleranca: %.6f\n', toleranca);
fprintf('----------------------------------------------------------------\n');

%% 4. LOOP I ZBRITJES SË GRADIENTIT
for iter = 1:num_iter
    % Llogarit vlerat e modelit për parametrat aktualë
    y_model = a * exp(b * x);
    
    % Llogarit gabimet (diferencat)
    gabimet = y_masa - y_model;
    
    % Llogarit funksionin e gabimit (kosto)
    J = (1/(2*n)) * sum(gabimet.^2);
    
    % Llogarit derivatet e pjesshme
    dJ_da = -(1/n) * sum(gabimet .* exp(b * x));
    dJ_db = -(1/n) * sum(gabimet .* a .* x .* exp(b * x));
    
    % Ruaj vlerat për historik
    hist_a(iter) = a;
    hist_b(iter) = b;
    hist_gabim(iter) = J;
    
    % Përditëso parametrat duke përdorur zbrinjën e gradientit
    a_old = a;
    b_old = b;
    
    a = a_old - alpha * dJ_da;
    b = b_old - alpha * dJ_db;
    
    % Kontrollo konvergjencën (ndryshim i vogël)
    if iter > 1
        ndryshim = abs(hist_gabim(iter) - hist_gabim(iter-1));
        if ndryshim < toleranca
            fprintf('Konvergjenca arritur në përsëritjen %d\n', iter);
            fprintf('Gabimi ndryshoi vetëm %.8f\n', ndryshim);
            break;
        end
    end
    
    % Shfaq progresin çdo 100 përsëritje
    if mod(iter, 100) == 0
        fprintf('Iter %4d: a=%.4f, b=%.4f, Gabimi=%.6f\n', iter, a, b, J);
    end
end

% Shkurtoj vektorët e historikut nëse përsëritjet janë më pak
if iter < num_iter
    hist_a = hist_a(1:iter);
    hist_b = hist_b(1:iter);
    hist_gabim = hist_gabim(1:iter);
end

fprintf('----------------------------------------------------------------\n');

%% 5. REZULTATET
fprintf('REZULTATET PËRFUNDIMTARE:\n');
fprintf('Parametri a (i përshtatur): %.4f (e vërteta: %.4f)\n', a, a_veri);
fprintf('Parametri b (i përshtatur): %.4f (e vërteta: %.4f)\n', b, b_veri);
fprintf('Gabimi përfundimtar (J): %.6f\n', hist_gabim(end));
fprintf('Numri i përsëritjeve: %d\n', length(hist_gabim));
fprintf('================================================================\n');

%% 6. LLOGARIT R-SQUARED
y_perfituar = a * exp(b * x);
y_mesatar = mean(y_masa);
SS_total = sum((y_masa - y_mesatar).^2);
SS_residual = sum((y_masa - y_perfituar).^2);
R_squared = 1 - (SS_residual / SS_total);
fprintf('R-squared: %.4f\n', R_squared);
fprintf('================================================================\n');

%% 7. VIZUALIZIMET
% Figura 1: Të dhënat dhe modeli i përshtatur
figure('Position', [50, 50, 1200, 500]);

subplot(1,3,1);
plot(x, y_masa, 'bo', 'MarkerSize', 8, 'LineWidth', 1.5, 'DisplayName', 'Të dhënat matur');
hold on;
plot(x, y_perfituar, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('y=%.3f*exp(%.3f*x)', a, b));
plot(x, y_veri, 'g--', 'LineWidth', 1.5, 'DisplayName', sprintf('Modeli i vërtetë: y=%.3f*exp(%.3f*x)', a_veri, b_veri));
grid on;
xlabel('x');
ylabel('y');
title('Regresioni Eksponencial me Zbritje Gradienti');
legend('Location', 'northwest');
axis tight;

% Figura 2: Konvergjenca e funksionit të gabimit
subplot(1,3,2);
plot(hist_gabim, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('Numri i përsëritjeve');
ylabel('Vlera e funksionit të gabimit (J)');
title('Konvergjenca e funksionit të gabimit');
axis tight;

% Figura 3: Rruga e parametrave në hapësirën a-b
subplot(1,3,3);
plot(hist_a, hist_b, 'b.-', 'LineWidth', 1.5, 'MarkerSize', 10);
hold on;
plot(a_veri, b_veri, 'rx', 'MarkerSize', 15, 'LineWidth', 2, 'DisplayName', 'Vlera e vërtetë');
plot(a, b, 'go', 'MarkerSize', 12, 'LineWidth', 2, 'DisplayName', 'Vlera përfundimtare');
xlabel('Parametri a');
ylabel('Parametri b');
title('Rruga e parametrave në hapësirën a-b');
legend('Location', 'best');
grid on;

%% 8. FUNKSIONI PËR PARASHIKIME
% Krijo një funksion që mund të përdoret për parashikime të reja
x_te_ri = linspace(min(x)-1, max(x)+1, 100)';
y_parashikim = a * exp(b * x_te_ri);

figure('Position', [100, 600, 500, 400]);
plot(x, y_masa, 'bo', 'MarkerSize', 8, 'DisplayName', 'Të dhënat matur');
hold on;
plot(x_te_ri, y_parashikim, 'r-', 'LineWidth', 2, 'DisplayName', 'Modeli i përshtatur');
fill([x_te_ri; flipud(x_te_ri)], ...
     [a * exp(b * x_te_ri) * 0.95; flipud(a * exp(b * x_te_ri) * 1.05)], ...
     'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', 'Zonë pasigurie ±5%');
grid on;
xlabel('x');
ylabel('y');
title('Parashikime me modelin e përshtatur');
legend('Location', 'northwest');
axis tight;

%% 9. FUNKSIONI PËR TESTIM (opsional)
% Testo ndjeshmërinë ndaj vlerave fillestare
fprintf('\nTESTIM I NDSJESHMËRISË NDAJ VLERAVE FILLESTARE:\n');
vlerat_fillestare = [
    0.5, 0.3;   % a, b
    1.0, 0.5;
    3.0, 1.0;
    5.0, 0.2
];

figure('Position', [600, 50, 500, 400]);
colors = ['r', 'g', 'b', 'm'];

for i = 1:size(vlerat_fillestare, 1)
    % Zbritje e gradientit me vlera fillestare të ndryshme
    [a_test, b_test] = zbritje_gradienti_eksponenciale(x, y_masa, ...
        vlerat_fillestare(i,1), vlerat_fillestare(i,2), alpha, num_iter);
    
    % Vizato kurbat e ndryshme
    y_test = a_test * exp(b_test * x_te_ri);
    plot(x_te_ri, y_test, '--', 'Color', colors(i), 'LineWidth', 1.5, ...
        'DisplayName', sprintf('Fillestare: a=%.1f, b=%.1f', vlerat_fillestare(i,1), vlerat_fillestare(i,2)));
    hold on;
end

plot(x, y_masa, 'ko', 'MarkerSize', 6, 'DisplayName', 'Të dhënat matur');
grid on;
xlabel('x');
ylabel('y');
title('Ndjeshmëria ndaj vlerave fillestare');
legend('Location', 'northwest', 'FontSize', 8);
axis tight;

fprintf('\n================================================================\n');
fprintf('KODI I PLOTË - Regresioni eksponencial me zbritje gradienti\n');
fprintf('================================================================\n');

%% FUNKSIONI I ZBRITJES SË GRADIENTIT (e ndarë në një funksion të veçantë)
function [a_final, b_final] = zbritje_gradienti_eksponenciale(x, y, a0, b0, alpha, max_iter)
    % Funksion ndihmës për të kryer zbritjen e gradientit
    n = length(x);
    a = a0;
    b = b0;
    
    for iter = 1:max_iter
        % Llogarit modelin dhe gabimet
        y_model = a * exp(b * x);
        gabimet = y - y_model;
        
        % Llogarit derivatet
        dJ_da = -(1/n) * sum(gabimet .* exp(b * x));
        dJ_db = -(1/n) * sum(gabimet .* a .* x .* exp(b * x));
        
        % Përditëso parametrat
        a = a - alpha * dJ_da;
        b = b - alpha * dJ_db;
    end
    
    a_final = a;
    b_final = b;
end
