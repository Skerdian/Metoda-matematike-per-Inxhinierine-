% jacobi_simple.m
% Metoda e Jakobit per zgjidhjen e Ax = b

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
x      = zeros(n,1);   % fillimi (p.sh. vektor zero)
tol    = 1e-6;         % toleranca
maxit  = 100;          % maksimumi i iteracioneve

% ---------------------------------
% 3) Ndarja e A ne D dhe R (A = D + R)
% ---------------------------------
D = diag(diag(A));     % matrica diagonale
R = A - D;             % pjesa tjeter (off-diagonal)

% ---------------------------------
% 4) Iteracionet e Jakobit
% ---------------------------------
for k = 1:maxit
    x_new = (b - R*x) ./ diag(A);   % formula x^{k+1}_i = (b_i - sum_{j!=i} a_ij x_j^k)/a_ii

    % shfaq iteracionin
    fprintf('Iter %2d: x = [%.8f  %.8f  %.8f]\n', k, x_new(1), x_new(2), x_new(3));

    % kushti i ndalimit
    if norm(x_new - x, inf) < tol
        x = x_new;
        fprintf('\nMetoda e Jakobit konvergoi pas %d iteracionesh.\n', k);
        fprintf('Zgjidhja aproksimuese: x = \n');
        disp(x);
        break;
    end

    x = x_new;
end

% nese nuk ka konverguar brenda maxit
if norm(x_new - x, inf) >= tol
    fprintf('\nKujdes: mund te mos kete konverguar brenda %d iteracioneve.\n', maxit);
    fprintf('Aproksim aktual: x = \n');
    disp(x_new);
end
