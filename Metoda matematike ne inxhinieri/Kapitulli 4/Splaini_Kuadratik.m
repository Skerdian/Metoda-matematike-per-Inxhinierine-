function [S, coeffs] = cubic_spline_natural(x, y)
% CUBIC_SPLINE_NATURAL  Spline kubik natyror (natural) per interpolim.
%
%   [S, coeffs] = cubic_spline_natural(x, y)
%
%   Input:
%     x : vektor nyjesh (duhet te jete strikt rrites), n >= 2
%     y : vektor vlerash perkatese (i njejte gjatesi me x)
%
%   Output:
%     S      : funksion-handle, S(xx) kthen vlerat e spline-it ne pikat xx
%     coeffs : matrice (n-1) x 4 me koeficientet per çdo interval:
%              per intervalin [x(i), x(i+1)]:
%              s_i(t) = a + b*(t-x(i)) + c*(t-x(i))^2 + d*(t-x(i))^3
%              ku [a b c d] = coeffs(i,:)
%
%   Spline natyror: S''(x(1)) = 0 dhe S''(x(n)) = 0.
%
%   Shembull:
%     x = [0 1 2 3]; y = [1 2 0 2];
%     [S,c] = cubic_spline_natural(x,y);
%     xx = linspace(0,3,200);
%     plot(x,y,'o',xx,S(xx),'-');

    % --- Kontrolli i input-it ---
    x = x(:); y = y(:);
    n = numel(x);
    if n < 2
        error('Duhet te keni te pakten 2 nyje.');
    end
    if numel(y) ~= n
        error('x dhe y duhet te kene te njejten gjatesi.');
    end
    if any(~isfinite(x)) || any(~isfinite(y))
        error('x dhe y duhet te jene numra te fundem.');
    end
    if any(diff(x) <= 0)
        error('x duhet te jete strikt rrites (pa perseritje).');
    end

    % --- Hapat ---
    h = diff(x);                 % (n-1)x1
    a = y;                       % a_i = y_i

    % --- Sistemi tridiagonal per c (koeficienti i termit katror) ---
    % Per n=2 kemi vetem nje segment: spline behet vije e drejte (c=0,d=0).
    if n == 2
        b = (a(2)-a(1))/h(1);
        c = [0;0];
        d = 0;
        coeffs = [a(1) b 0 0];
        S = @(xx) eval_spline(xx, x, coeffs);
        return;
    end

    % alpha per nyjet e brendshme
    alpha = zeros(n,1);
    for i = 2:n-1
        alpha(i) = (3/h(i))*(a(i+1)-a(i)) - (3/h(i-1))*(a(i)-a(i-1));
    end

    % Zgjidhja me algoritmin Thomas (tridiagonal)
    l  = zeros(n,1);
    mu = zeros(n,1);
    z  = zeros(n,1);

    l(1) = 1; mu(1) = 0; z(1) = 0;        % kushti natyror ne fillim
    for i = 2:n-1
        l(i)  = 2*(x(i+1)-x(i-1)) - h(i-1)*mu(i-1);
        mu(i) = h(i)/l(i);
        z(i)  = (alpha(i) - h(i-1)*z(i-1))/l(i);
    end
    l(n) = 1; z(n) = 0;                   % kushti natyror ne fund
    c = zeros(n,1);

    b = zeros(n-1,1);
    d = zeros(n-1,1);

    % rikthim mbrapsht
    for j = n-1:-1:1
        c(j) = z(j) - mu(j)*c(j+1);
        b(j) = (a(j+1)-a(j))/h(j) - h(j)*(2*c(j)+c(j+1))/3;
        d(j) = (c(j+1)-c(j))/(3*h(j));
    end

    % Koeficientet per çdo interval: [a_i, b_i, c_i, d_i]
    coeffs = [a(1:n-1), b, c(1:n-1), d];

    % Funksion-handle per vleresim
    S = @(xx) eval_spline(xx, x, coeffs);
end

% ------------------------------------------------------------
function yy = eval_spline(xx, x, coeffs)
% Vlereson spline-in per vektor/matrice xx, me "clamp" ne interval [x1,xn].

    xx_in = xx;           % ruaj formen origjinale
    xx = xx(:);

    n = numel(x);
    % clamp
    xx(xx < x(1)) = x(1);
    xx(xx > x(n)) = x(n);

    % gjej intervalin per secilin xx
    % idx = i kur xx eshte ne [x(i), x(i+1)]
    idx = discretize(xx, x);
    idx(isnan(idx)) = n-1;     % nese xx==x(n), discretize jep NaN

    dx = xx - x(idx);

    a = coeffs(idx,1);
    b = coeffs(idx,2);
    c = coeffs(idx,3);
    d = coeffs(idx,4);

    yy = a + b.*dx + c.*dx.^2 + d.*dx.^3;
    yy = reshape(yy, size(xx_in));
end


