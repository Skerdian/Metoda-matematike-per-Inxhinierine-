
% Metoda e Newtonit per zgjidhjen e f(x) = 0

clc; clear;

% ---------------------------------
% 1) Percakto funksionin dhe derivatin
% ---------------------------------
f  = @(x) x.^2 - 2;      % shembull: f(x) = x^2 - 2
df = @(x) 2*x;           % derivati: f'(x) = 2x

% ---------------------------------
% 2) Parametrat e metodes
% ---------------------------------
x0    = 1;       % vlera fillestare
tol   = 1e-6;    % toleranca e gabimit
maxit = 50;      % maksimumi i iteracioneve

% ---------------------------------
% 3) Iteracionet e Newtonit
% ---------------------------------
x = x0;
for k = 1:maxit
    fx  = f(x);
    dfx = df(x);
    
    if dfx == 0
        fprintf('Derivati u be zero. Ndalohet metoda.\n');
        break;
    end
    
    x_new = x - fx/dfx;     % formula e Newtonit
    
    fprintf('Iter %d: x = %.10f, f(x) = %.3e\n', k, x_new, f(x_new));
    
    % kushti i ndalimit
    if abs(x_new - x) < tol
        x = x_new;
        fprintf('\nMetoda konvergoi ne x = %.10f pas %d iteracionesh.\n', x, k);
        break;
    end
    
    x = x_new;
end

% Nese nuk ka konverguar brenda maxit
if abs(f(x)) > tol
    fprintf('\nKujdes: nuk ka konverguar brenda %d iteracioneve.\n', maxit);
    fprintf('Vlera aktuale: x ? %.10f, f(x) = %.3e\n', x, f(x));
end
