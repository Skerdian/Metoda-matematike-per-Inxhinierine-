function [x, k] = broyden_secant(F, x0, tol, maxit)
% BROYDEN_SECANT - Metode tip-sekante (Broyden) per sisteme jolineare F(x) = 0
%
%   [x, k] = broyden_secant(F, x0, tol, maxit)
%
%   F    - funksion @(x) qe kthen vektor kolone (n x 1)
%          p.sh. F = @(x)[ ... ; ... ; ... ];
%   x0   - vektori fillestar (n x 1)
%   tol  - toleranca (p.sh. 1e-6)
%   maxit- nr. maksimal iteracionesh
%
%   x    - aproksimi i zgjidhjes
%   k    - nr. iteracioneve te perdorura
%
%   Kjo eshte nje metode quasi-Newton (sekant multi-dim)
%   ku aproksimojme J^{-1} me Broyden, duke nisur nga
%   nje Jakobian numerik ne x0.

    if nargin < 3 || isempty(tol)
        tol = 1e-6;
    end
    if nargin < 4 || isempty(maxit)
        maxit = 50;
    end

    % sigurohu qe x0 eshte vektor kolone
    x = x0(:);
    n = length(x);

    % vlera fillestare e funksionit
    Fx = F(x);

    % inicializo B0 ? J(x0)^{-1} duke perdorur Jakobian numerik
    B = approx_inv_jacobian(F, x);

    for k = 1:maxit
        % hap quasi-Newton: s_k = -B_k * F(x_k)
        s = - B * Fx;
        x_new = x + s;
        Fx_new = F(x_new);

        fprintf('Iter %2d: ||F(x)|| = %.3e, ||s|| = %.3e\n', ...
                k, norm(Fx, inf), norm(s, inf));

        % kushtet e ndalimit
        if norm(s, inf) < tol || norm(Fx_new, inf) < tol
            x = x_new;
            return;
        end

        % vektoret perditesues
        y = Fx_new - Fx;
        denom = (s.' * y);

        if abs(denom) < 1e-14
            warning('Broyden: s^T y shume i vogel -> riaproksimo Jakobianin numerikisht.');
            x  = x_new;
            Fx = Fx_new;
            B  = approx_inv_jacobian(F, x);   % RESET i B-se
        else
            % perditesimi i B sipas Broyden-it (rank-1 update)
            % B_{k+1} = B_k + ((s - B_k y) s^T) / (s^T y)
            B = B + ((s - B * y) * (s.')) / denom;

            % perditeso x dhe F(x)
            x  = x_new;
            Fx = Fx_new;
        end
    end

    warning('Broyden_secant: nuk ka konverguar brenda %d iteracioneve.', maxit);
end

% -----------------------------------------------------------
% Funksion ndihmes per aproksim te Jakobianit dhe inversit te tij
% -----------------------------------------------------------
function B0 = approx_inv_jacobian(F, x)
% APROX_INV_JACOBIAN - Llogarit J(x) numerikisht me diferenca te vogla
% dhe kthen B0 ? J(x)^{-1}.

    x = x(:);
    n = length(x);
    Fx = F(x);

    h = 1e-6;        % hap i vogel per diferenca
    J = zeros(n,n);

    for j = 1:n
        e = zeros(n,1);
        e(j) = 1;

        Fx_h = F(x + h*e);
        J(:, j) = (Fx_h - Fx) / h;
    end

    % inversi i Jakobianit (nese eshte i invertueshem)
    B0 = inv(J);
end
