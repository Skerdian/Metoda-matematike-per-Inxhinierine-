function SplineKuadratik
% SplineKuadratik - spline kuadratik per pikat (1,1),(2,3),(3,2),(4,5)
% dhe krahasim me spline kubik te MATLAB-it.

clc; clear; close all;

% --------------------------------------------------------
% 1) Te dhenat
% --------------------------------------------------------
x = [1 2 3 4];
y = [1 3 2 5];

% --------------------------------------------------------
% 2) Llogarit koeficientet e spline kuadratik
%    S_j(x) = a_j x^2 + b_j x + c_j
% --------------------------------------------------------
[a,b,c] = quad_spline_coeff(x, y);

% --------------------------------------------------------
% 3) Vleresimi ne rrjet te dendur
% --------------------------------------------------------
xx = linspace(x(1), x(end), 400);
yy_quad = quad_spline_eval(xx, x, a, b, c);

% Spline kubik i MATLAB-it (per krahasim vizual)
yy_cubic = spline(x, y, xx);

% --------------------------------------------------------
% 4) Grafik – spline kuadratik vs MATLAB spline (kubik)
% --------------------------------------------------------
figure;
plot(xx, yy_quad, 'b-', 'LineWidth', 2); hold on;
plot(xx, yy_cubic, 'r--', 'LineWidth', 2);
plot(x, y, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 8);

grid on;
xlabel('x');
ylabel('y');
title('Spline kuadratik (kod vet) vs spline kubik (MATLAB spline)');
legend('Spline kuadratik', ...
       'Spline kubik (MATLAB spline)', ...
       'Pikat e te dhenave', ...
       'Location', 'best');

% --------------------------------------------------------
% (opsionale) shfaq koeficientet
% --------------------------------------------------------
disp('Koeficientet e spline kuadratik:');
m = numel(x)-1;
for j = 1:m
    fprintf('S_%d(x) = %.4f x^2 + %.4f x + %.4f\n', ...
        j, a(j), b(j), c(j));
end

end  % fundi i funksionit kryesor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [a,b,c] = quad_spline_coeff(x, y)
% QUAD_SPLINE_COEFF - nderton spline kuadratik C^1
% mbi nyjet x(i), me kusht "natural" ne skajin e majte:
% S_1''(x_1) = 0.
%
% Ne cdo interval [x_j, x_{j+1}] kemi
%   S_j(x) = a_j x^2 + b_j x + c_j

    x = x(:); y = y(:);
    n = numel(x);
    if n < 3
        error('Duhet te pakten 3 pika per spline kuadratik.');
    end
    if any(diff(x) <= 0)
        error('Nyjet x duhet te jene ne rend rrites strikt.');
    end

    m = n - 1;          % numri i intervaleve
    A = zeros(3*m, 3*m);
    bvec = zeros(3*m, 1);
    eq = 1;

    % 1) Interpolimi ne cdo interval:
    %    S_j(x_j)   = y_j
    %    S_j(x_{j+1}) = y_{j+1}
    for j = 1:m
        idx = 3*(j-1) + (1:3);   % kolonat per [a_j, b_j, c_j]

        % S_j(x_j) = y_j
        xj = x(j);
        A(eq, idx) = [xj^2, xj, 1];
        bvec(eq) = y(j);
        eq = eq + 1;

        % S_j(x_{j+1}) = y_{j+1}
        xjp1 = x(j+1);
        A(eq, idx) = [xjp1^2, xjp1, 1];
        bvec(eq) = y(j+1);
        eq = eq + 1;
    end

    % 2) Vazhdimesia e derivatit ne nyjet e brendshme:
    %    S_j'(x_{j+1}) = S_{j+1}'(x_{j+1})
    %    S_j'(x) = 2 a_j x + b_j
    for j = 1:m-1
        xk = x(j+1);       % nyja e brendshme x_{j+1}

        idxL = 3*(j-1) + (1:3);   % S_j
        idxR = 3*j       + (1:3); % S_{j+1}

        A(eq, idxL) = [2*xk, 1, 0];
        A(eq, idxR) = [-2*xk, -1, 0];
        bvec(eq) = 0;
        eq = eq + 1;
    end

    % 3) Kusht "natural" ne skajin e majte:
    %    S_1''(x_1) = 0  ->  2 a_1 = 0
    A(eq, 1) = 2;
    bvec(eq) = 0;
    eq = eq + 1;

    if eq-1 ~= 3*m
        error('Numri i ekuacioneve nuk perputhet me 3*m.');
    end

    % Zgjidhim sistemin linear
    coeff = A \ bvec;

    % Nxjerrim koeficientet a_j, b_j, c_j
    a = zeros(m,1);
    b = zeros(m,1);
    c = zeros(m,1);
    for j = 1:m
        idx = 3*(j-1) + (1:3);
        a(j) = coeff(idx(1));
        b(j) = coeff(idx(2));
        c(j) = coeff(idx(3));
    end
end

function yy = quad_spline_eval(xx, xnodes, a, b, c)
% QUAD_SPLINE_EVAL - vlereson spline kuadratik ne piket xx.

    xx = xx(:).';
    xnodes = xnodes(:);
    m = numel(xnodes) - 1;
    yy = zeros(size(xx));

    for j = 1:m
        if j < m
            mask = (xx >= xnodes(j)) & (xx <= xnodes(j+1));
        else
            mask = (xx >= xnodes(j)) & (xx <= xnodes(j+1));
        end
        xloc = xx(mask);
        yy(mask) = a(j)*xloc.^2 + b(j)*xloc + c(j);
    end
end

