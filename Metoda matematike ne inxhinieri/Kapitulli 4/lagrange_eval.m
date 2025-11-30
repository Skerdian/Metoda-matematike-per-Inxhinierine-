function P = lagrange_eval(x, y, xp)
% LAGRANGE_EVAL - Vlereson polinomin interpolues te Lagranzhit ne xp
%
%   P = lagrange_eval(x, y, xp)
%
%   x  - nyjet (vektor)
%   y  - vlerat e funksionit ne nyje (vektor)
%   xp - pika (ose vektor pikash) ku duam interpolimin
%
%   P  - vlera(t) e polinomit te Lagranzhit ne xp

    x = x(:);
    y = y(:);
    n = length(x);

    xp = xp(:).';      % e bejme rresht per iterim te lehte
    m = length(xp);
    P = zeros(1, m);

    for k = 1:m
        s = 0;
        for i = 1:n
            Li = 1;
            for j = 1:n
                if j ~= i
                    Li = Li * ( (xp(k) - x(j)) / (x(i) - x(j)) );
                end
            end
            s = s + y(i) * Li;
        end
        P(k) = s;
    end

    P = P(:);   % ktheje si vektor kolone
end
