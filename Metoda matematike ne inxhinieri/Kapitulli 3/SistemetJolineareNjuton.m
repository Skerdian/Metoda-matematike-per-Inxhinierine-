% newton_system_simple.m
% Metoda e Newtonit per zgjidhjen e nje sistemi jolinear F(x) = 0

clc; clear;

% -------------------------------------------------
% 1) Percakto funksionin F(x) dhe Jakobianin J(x)
%    Shembull sistem ne R^2:
%    f1(x,y) = x^2 + y^2 - 4  = 0
%    f2(x,y) = exp(x) + y - 1 = 0
% -------------------------------------------------
F = @(x) [ ...
    x(1)^2 + x(2)^2 - 4;      % f1
    exp(x(1)) + x(2) - 1      % f2
];

J = @(x) [ ...
    2*x(1),      2*x(2);      % df1/dx, df1/dy
    exp(x(1)),   1            % df2/dx, df2/dy
];

% -------------------------------------------------
% 2) Parametrat e metodes
% -------------------------------------------------
x  = [1; 1];    % vektori fillestar [x0; y0]
tol   = 1e-8;   % toleranca per norm(dx)
maxit = 50;     % nr. maksimal iteracionesh

% -------------------------------------------------
% 3) Iteracionet e Newtonit
% -------------------------------------------------
for k = 1:maxit
    Fx = F(x);
    Jx = J(x);

    % zgjidh sistemin Jx * dx = -Fx
    dx = - Jx \ Fx;

    x_new = x + dx;

    fprintf('Iter %2d: x = [%.10f  %.10f],  ||dx|| = %.3e\n', ...
        k, x_new(1), x_new(2), norm(dx, inf));

    % kushti i ndalimit
    if norm(dx, inf) < tol
        x = x_new;
        fprintf('\nMetoda e Newtonit konvergoi pas %d iteracionesh.\n', k);
        fprintf('Zgjidhja perafruar: x = [%.10f  %.10f]\n', x(1), x(2));
        break;
    end

    x = x_new;
end

if norm(dx, inf) >= tol
    fprintf('\nKujdes: mund te mos kete konverguar brenda %d iteracioneve.\n', maxit);
    fprintf('perafrimi aktual: x = [%.10f  %.10f]\n', x(1), x(2));
end
