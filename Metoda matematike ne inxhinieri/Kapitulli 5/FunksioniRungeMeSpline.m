%% =========================================================
%  SPLINE LINEAR (ME DORE) vs MATLAB interp1('linear')
%  Krahasim me funksionin ekzakt ne nje grafik
% =========================================================

clear; clc; close all;

%% 1) FUNKSIONI (NDËRRO VETËM KËTU)
f = @(x) 1./(1 + 25*x.^2);     % Runge
% f = @(x) exp(x);
% f = @(x) sin(5*x);

%% 2) INTERVALI DHE NYJET
a = -1;
b =  1;

N = 200;                       % numri i nyjeve (rrite p.sh. 41, 101)
x = linspace(a,b,N);          % nyjet
y = f(x);                     % vlerat

%% 3) RRJET I DENDUR PER GRAFIK
xx = linspace(a,b,2000);
f_exact = f(xx);

%% =========================================================
%  4) SPLINE LINEAR SIPAS TEORISE (ME DORE)
%  Ne secilin segment [x_i, x_{i+1}]:
%  S_i(t) = y_i + (y_{i+1}-y_i)/(x_{i+1}-x_i) * (t-x_i)
% =========================================================
S_manual = zeros(size(xx));

for i = 1:(N-1)
    xi  = x(i);
    xip = x(i+1);
    yi  = y(i);
    yip = y(i+1);

    hi = xip - xi;
    slope = (yip - yi) / hi;

    idx = (xx >= xi) & (xx <= xip);
    S_manual(idx) = yi + slope * (xx(idx) - xi);
end

%% =========================================================
%  5) MATLAB FUNKSIONI I GATSHEM (LINEAR)
% =========================================================
S_matlab = interp1(x, y, xx, 'linear');   % spline linear (piecewise linear)

%% 6) GRAFIKU I PERBASHKET (NJË FIGURË)
figure;
plot(xx, f_exact, 'k-', 'LineWidth', 2); hold on;
plot(xx, S_manual, 'r--', 'LineWidth', 2);
plot(xx, S_matlab, 'b:', 'LineWidth', 2);
plot(x, y, 'ko', 'MarkerFaceColor','k', 'MarkerSize', 5);

grid on;
xlabel('x'); ylabel('y');
title(sprintf('Krahasim: Ekzakt vs Spline Linear (N=%d nyje)', N));
legend('Funksioni ekzakt', ...
       'Spline linear (me dore)', ...
       'MATLAB interp1(linear)', ...
       'Nyjet', ...
       'Location','Best');

%% 7) (OPSIONALE) GABIMI: manual dhe matlab (duhet të dalin identikë)
err_manual = f_exact - S_manual;
err_matlab = f_exact - S_matlab;

figure;
plot(xx, abs(err_manual), 'r--', 'LineWidth', 2); hold on;
plot(xx, abs(err_matlab), 'b:', 'LineWidth', 2);
grid on;
xlabel('x'); ylabel('|gabimi|');
title('Gabimi absolut: spline linear (me dore) vs MATLAB');
legend('|f - S_{manual}|', '|f - S_{matlab}|', 'Location','Best');

%% 8) (OPSIONALE) Printo norma gabimi
Linf_manual = max(abs(err_manual));
L2_manual   = sqrt(trapz(xx, err_manual.^2));

fprintf('N=%d\n', N);
fprintf('Spline linear (manual): Linf = %.6e, L2 = %.6e\n', Linf_manual, L2_manual);

% Kontroll: diferenca mes dy implementimeve (duhet ~0 numerikisht)
diff_max = max(abs(S_manual - S_matlab));
fprintf('Max |S_manual - S_matlab| = %.6e (duhet shume afer 0)\n', diff_max);
