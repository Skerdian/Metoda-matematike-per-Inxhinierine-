clc;
clear;
close all;

% ============================================
% 0) Funksioni dhe derivati i saktë
% ============================================
% f(x)  = sin(x)
% f'(x) = cos(x)  (derivati ekzakt)
f  = @(x) sin(x);
df = @(x) cos(x);

% Intervali ku studiojmë derivatin
a = 0;
b = pi;

% Hapi numerik për diferencën qendrore
h = pi/4;   % mund ta ndryshosh (p.sh. 0.1, 0.05, ...)

% Pikat ku do të llogarisim derivatin numerik
% Duhet të kemi x ± h dhe x ± h/2 brenda [a,b],
% prandaj fillojmë nga a+h dhe mbarojmë në b-h
x = linspace(a + h, b - h, 200);

% ============================================
% 1) Derivati ekzakt
% ============================================
D_exact = df(x);

% ============================================
% 2) Derivati numerik:
%    - diferencë qendrore me h
%    - diferencë qendrore me h/2
%    - ekstrapolim Richardson
% ============================================
Dc_h  = ( f(x + h)   - f(x - h)   ) ./ (2*h);
Dc_h2 = ( f(x + h/2) - f(x - h/2) ) ./ (2*(h/2));  % 2*(h/2) = h

% Ekstrapolimi i Richardson-it (p = 2)
D_rich = (4*Dc_h2 - Dc_h) / 3;

% ============================================
% 3) Gabimet absolute
% ============================================
err_c   = abs(Dc_h   - D_exact);
err_c2  = abs(Dc_h2  - D_exact);
err_rich = abs(D_rich - D_exact);

% ============================================
% 4) Grafik: derivati ekzakt vs Richardson
% ============================================
figure;
plot(x, D_exact, 'k-', 'LineWidth', 2); hold on;
plot(x, Dc_h,   'bo-', 'LineWidth', 1.0, 'MarkerSize', 4);
plot(x, D_rich, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('x');
ylabel('Derivati');
title(sprintf('f(x) = sin(x), h = %.3f', h));
legend('f''(x) = cos(x) (ekzakt)', ...
       'Diferencë qendrore (h)', ...
       'Ekstrapolim Richardson', ...
       'Location', 'best');

% ============================================
% 5) Grafik: gabimi absolut
% ============================================
figure;
plot(x, err_c,   'bo-', 'LineWidth', 1.0, 'MarkerSize', 4); hold on;
plot(x, err_rich,'r--', 'LineWidth', 1.5);
grid on;
xlabel('x');
ylabel('Gabimi absolut');
title(sprintf('Gabimi i derivimit numerik, h = %.3f', h));
legend('|Central(h) - f''(x)|', '|Richardson - f''(x)|', 'Location', 'best');

% ============================================
% 6) Shembull numerik në një pikë të vetme x0
% ============================================
x0 = pi/4;   % p.sh. x0 = pi/4

% Derivati ekzakt
D_exact_x0 = df(x0);

% Derivati numerik me central(h) dhe Richardson në x0
Dc_h_x0  = ( f(x0 + h)   - f(x0 - h)   ) / (2*h);
Dc_h2_x0 = ( f(x0 + h/2) - f(x0 - h/2) ) / (2*(h/2));
D_rich_x0 = (4*Dc_h2_x0 - Dc_h_x0) / 3;

err_c_x0   = abs(Dc_h_x0   - D_exact_x0);
err_rich_x0 = abs(D_rich_x0 - D_exact_x0);

fprintf('Pika x0 = %.6f\n', x0);
fprintf('Derivati ekzakt   f''(x0)  = %.12f\n', D_exact_x0);
fprintf('Central diff(h)   Dc(h)    = %.12f,  gabimi = %.2e\n', Dc_h_x0,   err_c_x0);
fprintf('Richardson        D_rich   = %.12f,  gabimi = %.2e\n', D_rich_x0, err_rich_x0);
