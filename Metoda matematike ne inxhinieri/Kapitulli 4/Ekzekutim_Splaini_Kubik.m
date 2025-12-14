clear; clc; close all;

%% =========================================================
%  DEMO: Natural cubic spline (theory) vs MATLAB built-in
%  You only change f(x) and N (number of nodes).
% =========================================================

%% 1) Function (change ONLY here)
f = @(x) 1./(1 + 25*x.^2);     % Runge
% f = @(x) exp(x);
% f = @(x) sin(5*x);

%% 2) Interval and nodes
a = -1;  b = 1;
N = 21;                       % number of nodes (e.g., 11, 21, 41, 101)
x = linspace(a,b,N);
y = f(x);

%% 3) Natural cubic spline (theory implementation)
[aj,bj,cj,dj,pp_nat] = NaturalCubicSpline(x,y);

%% 4) Evaluate on a dense grid
xx = linspace(a,b,2000);
f_exact = f(xx);
S_nat   = ppval(pp_nat, xx);

%% 5) MATLAB reference spline
% If you have Curve Fitting Toolbox, csape(...,'variational') is natural (S''=0 at ends).
% Otherwise, MATLAB's spline(...) is not-a-knot (still useful as a reference).
S_mat = nan(size(xx));
lab  = "";

try
    pp_csape = csape(x, y, 'variational');     % natural spline
    S_mat = fnval(pp_csape, xx);
    lab = "MATLAB csape('variational') (natural)";
catch
    S_mat = spline(x, y, xx);                  % not-a-knot
    lab = "MATLAB spline (not-a-knot)";
end

%% 6) One plot: exact vs our natural spline vs MATLAB + nodes
figure;
plot(xx, f_exact, 'k-', 'LineWidth', 2); hold on;
plot(xx, S_nat,   'r--', 'LineWidth', 2);
plot(xx, S_mat,   'b:', 'LineWidth', 2);
plot(x, y, 'ko', 'MarkerFaceColor','k', 'MarkerSize', 5);

grid on;
xlabel('x'); ylabel('y');
title(sprintf('Natural Cubic Spline (N=%d nodes)', N));
legend('Exact f(x)', 'Natural spline (theory)', lab, 'Nodes', 'Location','Best');

%% 7) Error plot (optional)
figure;
plot(xx, abs(f_exact - S_nat), 'm', 'LineWidth', 2); hold on;
plot(xx, abs(f_exact - S_mat), 'c--', 'LineWidth', 2);
grid on;
xlabel('x'); ylabel('|error|');
title('Absolute error: theory vs MATLAB');
legend('|f - S_{nat}|', '|f - S_{MATLAB}|', 'Location','Best');

%% 8) Print simple norms
err = f_exact - S_nat;
Linf = max(abs(err));
L2   = sqrt(trapz(xx, err.^2));
fprintf('Natural spline (theory): N=%d, Linf=%.6e, L2=%.6e\n', N, Linf, L2);
