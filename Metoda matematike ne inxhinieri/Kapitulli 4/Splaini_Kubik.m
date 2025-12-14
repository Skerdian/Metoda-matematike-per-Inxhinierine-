function [aj,bj,cj,dj,pp] = NaturalCubicSpline(x, y)
% NaturalCubicSpline  - Natural cubic spline (S''(x0)=S''(xn)=0)
%
% INPUT:
%   x : (n+1)x1 nodes, strictly increasing
%   y : (n+1)x1 values f(xi)
%
% OUTPUT:
%   aj,bj,cj,dj : coefficients for each segment j=0..n-1 (length n)
%       S_j(x) = aj(j) + bj(j)*(x-xj) + cj(j)*(x-xj)^2 + dj(j)*(x-xj)^3
%   pp : piecewise polynomial structure (use ppval)
%
% NOTE:
%   Standard tridiagonal algorithm for the natural cubic spline.

    x = x(:);  y = y(:);

    if numel(x) ~= numel(y)
        error('x and y must have the same length.');
    end
    if any(diff(x) <= 0)
        error('x nodes must be strictly increasing.');
    end

    n = numel(x) - 1;        % number of segments
    h = diff(x);             % h_i = x_{i+1}-x_i, length n

    % Step 2: alpha
    alpha = zeros(n+1,1);
    for i = 2:n
        alpha(i) = 3/h(i)   * (y(i+1)-y(i)) ...
                 - 3/h(i-1) * (y(i)-y(i-1));
    end

    % Steps 3-5: solve tridiagonal system (l, mu, z)
    l  = zeros(n+1,1);
    mu = zeros(n+1,1);
    z  = zeros(n+1,1);

    l(1)  = 1;  mu(1) = 0;  z(1) = 0;

    for i = 2:n
        l(i)  = 2*(x(i+1)-x(i-1)) - h(i-1)*mu(i-1);
        mu(i) = h(i)/l(i);
        z(i)  = (alpha(i) - h(i-1)*z(i-1))/l(i);
    end

    l(n+1) = 1;
    z(n+1) = 0;

    % Step 6: back substitution for c, then b,d
    c = zeros(n+1,1);
    b = zeros(n,1);
    d = zeros(n,1);

    c(n+1) = 0;  % natural boundary condition

    for j = n:-1:1
        c(j) = z(j) - mu(j)*c(j+1);
        b(j) = (y(j+1)-y(j))/h(j) - h(j)*(c(j+1)+2*c(j))/3;
        d(j) = (c(j+1)-c(j)) / (3*h(j));
    end

    a = y(1:n);   % a_j = y_j

    aj = a(:);
    bj = b(:);
    cj = c(1:n);
    dj = d(:);

    % Build pp for ppval:
    % S_j = dj*(x-xj)^3 + cj*(x-xj)^2 + bj*(x-xj) + aj
    coefs = [dj cj bj aj];
    pp = mkpp(x, coefs);
end
