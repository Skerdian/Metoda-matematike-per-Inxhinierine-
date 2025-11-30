% secant_simple.m
% Metoda e sekantes per zgjidhjen e f(x) = 0

clc; clear;

% ---------------------------------
% 1) Percakto funksionin
% ---------------------------------
f = @(x) x.^2 - 2;   % shembull: f(x) = x^2 - 2

% ---------------------------------
% 2) Parametrat e metodes
% ---------------------------------
x0    = 1;        % vlera e pare fillestare
x1    = 2;        % vlera e dyte fillestare
tol   = 1e-6;     % toleranca
maxit = 50;       % nr. maksimal iteracionesh

% ---------------------------------
% 3) Iteracionet e sekantes
% ---------------------------------
for k = 1:maxit
    f0 = f(x0);
    f1 = f(x1);

    denom = (f1 - f0);
    if denom == 0
        fprintf('Pjestimi me zero (f1 - f0 = 0). Ndalohet metoda.\n');
        break;
    end

    % formula e sekantes:
    x2 = x1 - f1 * (x1 - x0) / denom;

    fprintf('Iter %d: x = %.10f, f(x) = %.3e\n', k, x2, f(x2));

    % kushti i ndalimit
    if abs(x2 - x1) < tol
        fprintf('\nMetoda konvergoi ne x = %.10f pas %d iteracionesh.\n', x2, k);
        break;
    end

    % pergatit iteracionin tjeter
    x0 = x1;
    x1 = x2;
end

% nese nuk konvergon brenda maxit
if abs(x2 - x1) >= tol
    fprintf('\nKujdes: mund te mos kete konverguar brenda %d iteracioneve.\n', maxit);
end
