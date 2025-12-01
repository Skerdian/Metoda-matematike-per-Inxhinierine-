% =========================================================
% Derivimi numerik + Tabelë + Krahasim grafik
% =========================================================

clear; clc; close all;

% ----------------------------------------
% 1) Funksioni dhe derivati ekzakt
% ----------------------------------------
f  = @(x) sin(x);     % Funksioni
df = @(x) cos(x);     % Derivati ekzakt

a = 0;
b = pi;
N = 100;                       % pak pika që tabela të jetë e lexueshme
x = linspace(a, b, N);
h = x(2) - x(1);

% ----------------------------------------
% 2) Derivimi numerik
% ----------------------------------------
x_in = x(2:N-1);

df_exact  = df(x_in);
df_forward  = (f(x(3:N))   - f(x(2:N-1))) / h;
df_backward = (f(x(2:N-1)) - f(x(1:N-2))) / h;
df_central  = (f(x(3:N))   - f(x(1:N-2))) / (2*h);

% ----------------------------------------
% 3) Ndërtimi i TABELËS
% ----------------------------------------
Tabela = table( ...
    x_in.', ...
    df_exact.', ...
    df_forward.', ...
    df_backward.', ...
    df_central.', ...
    abs(df_exact.' - df_forward.'), ...
    abs(df_exact.' - df_backward.'), ...
    abs(df_exact.' - df_central.'), ...
    'VariableNames', { ...
    'x', ...
    'Derivati_Egzakt', ...
    'Para', ...
    'Pas', ...
    'Qendror', ...
    'Gabimi_Para', ...
    'Gabimi_Pas', ...
    'Gabimi_Qendror'});

disp('=================== TABELA E REZULTATEVE ===================');
disp(Tabela);

% ----------------------------------------
% 4) Grafikimi
% ----------------------------------------
figure;
plot(x_in, df_exact, 'k-', 'LineWidth', 2); hold on;
plot(x_in, df_forward,  'r--', 'LineWidth', 1.5);
plot(x_in, df_backward, 'b-.', 'LineWidth', 1.5);
plot(x_in, df_central,  'g:',  'LineWidth', 2);

grid on;
xlabel('x');
ylabel('Derivati');
title('Derivimi Numerik: Para – Pas – Qendror vs Ekzakt');
legend('Ekzakt', 'Para', 'Pas', 'Qendror', 'Location','best');
