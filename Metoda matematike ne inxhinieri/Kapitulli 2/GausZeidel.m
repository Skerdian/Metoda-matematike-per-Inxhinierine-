% gauss_seidel_simple.m
% Metoda e Gauss-Seidel per zgjidhjen e Ax = b

clc; clear;

% ---------------------------------
% 1) Shembull matrice A dhe vektori b
% ---------------------------------
A = [4, -1, 0;
    -1, 4, -1;
     0, -1, 4];      % shembull 3x3 (diagonalisht dominuese)

b = [1; 4; 2];

n = length(b);       % dimensioni i sistemit

% ---------------------------------
% 2) Parametrat e metodes
% ---------------------------------
x     = zeros(n,1);   % vlera fillestare (p.sh. zero)
tol   = 1e-6;         % toleranca
maxit = 100;          % maksimumi i iteracioneve

% ---------------------------------
% 3) Iteracionet e Gauss-Seidel
% ---------------------------------
for k = 1:maxit
    x_old = x;    % ruaj vlerat e meparshme per gabimin

    for i = 1:n
        % llogarit shumatorët perpara dhe pas diagonalit
        % sum_{j < i} a_ij * x_j^{(k+1)}  (përdor vlerat e reja)
        sum1 = A(i,1:i-1) * x(1:i-1);

        % sum_{j > i} a_ij * x_j^{(k)}    (përdor vlerat e vjetra)
        sum2 = A(i,i+1:n) * x(i+1:n);

        x(i) = (b(i) - sum1 - sum2) / A(i,i);
    end

    % shfaq iteracionin
    fprintf('Iter %2d: x = [%.8f  %.8f  %.8f]\n', k, x(1), x(2), x(3));

    % kushti i ndalimit (norma ? e ndryshimit)
    if norm(x - x_old, inf) < tol
        fprintf('\nMetoda Gauss-Seidel konvergoi pas %d iteracionesh.\n', k);
        fprintf('Zgjidhja aproksimuese: x = \n');
        disp(x);
        break;
    end
end

% nese nuk ka konverguar brenda maxit
if norm(x - x_old, inf) >= tol
    fprintf('\nKujdes: mund te mos kete konverguar brenda %d iteracioneve.\n', maxit);
    fprintf('Aproksim aktual: x = \n');
    disp(x);
end
