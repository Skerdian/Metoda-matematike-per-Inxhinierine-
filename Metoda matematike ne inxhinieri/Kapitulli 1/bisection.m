function [root, iter] = bisection(f, a, b, tol, maxIter)
% METODA E BISEKSIONIT
% ---------------------
% f       - funksioni anonim, p.sh. @(x) x.^3 - x - 2
% [a, b]  - intervali fillestar ku f(a)*f(b) < 0
% tol     - toleranca e gabimit, p.sh. 1e-6
% maxIter - numri maksimal i iteracioneve
%
% root    - rrënja e përafërt
% iter    - numri i iteracioneve të kryera

    if f(a) * f(b) > 0
        error('f(a) dhe f(b) kane te njejten shenje. Zgjidh nje interval tjeter!');
    end

    iter = 0;
    while (b - a)/2 > tol && iter < maxIter
        c = (a + b)/2;   
        fc = f(c);

        if abs(fc) < tol
            break;
        end

        if f(a)*fc < 0
            b = c;
        else
            a = c;
        end

        iter = iter + 1;
    end

    root = (a + b)/2; 
end
