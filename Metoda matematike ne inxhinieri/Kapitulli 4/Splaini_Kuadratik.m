function pp = cubic_spline_custom(x, y, bcType, bcVals)
% CUBIC_SPLINE_CUSTOM  Nderton spline kubik sipas kushteve klasike (a)-(f).
%
%   pp = cubic_spline_custom(x, y, 'natural')
%       -> spline natyral: S''(x0) = S''(xn) = 0.
%
%   pp = cubic_spline_custom(x, y, 'clamped', [fp0, fpn])
%       -> spline i fiksuar (clamped):
%          S'(x0) = fp0,  S'(xn) = fpn.
%
%   Dalja 'pp' eshte strukture piecewise polynomial e kompatibel me ppval/mkpp.
%
%   Kushtet:
%   (a)  Ne cdo nen-interval [x_j, x_{j+1}] funksioni eshte polinom kubik S_j(x).
%   (b)  S_j(x_j)   = f(x_j),   S_j(x_{j+1}) = f(x_{j+1})  (kalon neper pikat e dhena).
%   (c)  S_j(x_{j+1}) = S_{j+1}(x_{j+1})      (vazhdueshmeri e S).
%   (d)  S'_j(x_{j+1}) = S'_{j+1}(x_{j+1})    (vazhdueshmeri e derivatit te pare).
%   (e)  S''_j(x_{j+1}) = S''_{j+1}(x_{j+1})  (vazhdueshmeri e derivatit te dyte).
%   (f)  Kufij natyral ose clamped, sipas 'bcType'.
%
%   Ky funksion perdor formulen klasike me derivatet e dyta M_j = S''(x_j).
%

    % Siguro formatet kolona
    x = x(:);
    y = y(:);

    n = length(x) - 1;  % numri i intervaleve

    if n < 1
        error('Duhet te pakten dy pika.');
    end

    if length(y) ~= length(x)
        error('Vektori x dhe y duhet te kene te njejten gjatesi.');
    end

    % x duhet te jete strikt ne rritje
    if any(diff(x) <= 0)
        error('Nyjet x duhet te plotesojne x0 < x1 < ... < xn.');
    end

    if nargin < 3 || isempty(bcType)
        bcType = 'natural';
    end

    h = diff(x);                 % gjatesite e nen-intervaleve
    A = zeros(n+1, n+1);
    rhs = zeros(n+1, 1);

    % -------------------------
    %  Kushtet e kufirit (f)
    % -------------------------
    switch lower(bcType)
        case 'natural'
            % (f)(i) S''(x0) = S''(xn) = 0
            A(1,1)       = 1.0;
            rhs(1)       = 0.0;
            A(n+1,n+1)   = 1.0;
            rhs(n+1)     = 0.0;

        case 'clamped'
            % (f)(ii) S'(x0) = f'(x0),  S'(xn) = f'(xn)
            if nargin < 4 || numel(bcVals) ~= 2
                error('Per ''clamped'' jep vektorin bcVals = [fp0, fpn].');
            end
            fp0 = bcVals(1);     % f'(x0)
            fpn = bcVals(2);     % f'(xn)

            % Rreshti i pare (kushti ne x0)
            A(1,1) = 2*h(1);
            A(1,2) =   h(1);
            rhs(1) = 6 * ( (y(2) - y(1))/h(1) - fp0 );

            % Rreshti i fundit (kushti ne xn)
            A(n+1,n)   =   h(n);
            A(n+1,n+1) = 2*h(n);
            rhs(n+1)   = 6 * ( fpn - (y(n+1) - y(n))/h(n) );

        otherwise
            error('bcType duhet te jete ''natural'' ose ''clamped''.');
    end

    % -------------------------------------------------------------
    %  Nyjet e brendshme: kushte (c), (d), (e) -> sistem tridiagonal
    % -------------------------------------------------------------
    % Per j = 1,...,n-1 (indeks MATLAB = j+1)
    for j = 2:n
        A(j, j-1) = h(j-1);
        A(j, j)   = 2 * (h(j-1) + h(j));
        A(j, j+1) = h(j);

        rhs(j) = 6 * ( (y(j+1) - y(j))/h(j) ...
                     - (y(j)   - y(j-1))/h(j-1) );
    end

    % Zgjidhim per derivatet e dyta M_0,...,M_n
    M = A \ rhs;   % (n+1)-vektor

    % -------------------------------------------------------------
    %  Per cdo interval [x_j, x_{j+1}] ndertojme polinomin kubik
    % -------------------------------------------------------------
    % Forma me zhvendosje (x - x_j):
    % S_j(x) = a3*(x-xj)^3 + a2*(x-xj)^2 + a1*(x-xj) + a0
    %
    % ku:
    %   a3 = (M_{j+1} - M_j) / (6*h_j)
    %   a2 = M_j / 2
    %   a1 = (y_{j+1} - y_j)/h_j - (2*M_j + M_{j+1})*h_j/6
    %   a0 = y_j
    %

    coefs = zeros(n, 4);
    for j = 1:n
        hj = h(j);
        a3 = (M(j+1) - M(j)) / (6*hj);
        a2 = M(j) / 2;
        a1 = (y(j+1) - y(j))/hj - (2*M(j) + M(j+1))*hj/6;
        a0 = y(j);

        coefs(j, :) = [a3, a2, a1, a0];
    end

    % Krijojme strukturen piecewise-polynomial (MATLAB pp-form)
    pp = mkpp(x, coefs);
end
