function I = rregulli_simpsonit_38(f, a, b, n)
%RREGULLI_SIMPSONIT_38 Rregulli i kompozuar i Simpson-it 3/8 për integrim numerik (me grafik).
%   I = RREGULLI_SIMPSONIT_38(f, a, b, n) llogarit përafrimin e integralit
%   \int_a^b f(x) dx duke përdorur rregullin e kompozuar të Simpson-it 3/8.
%
%   f : funksion (handle), p.sh. @(x) sin(x)
%   a : kufiri i majtë
%   b : kufiri i djathtë
%   n : numri i nën-intervaleve (duhet të jetë shumëfish i 3 dhe n >= 3)
%
%   Funksioni gjithashtu vizaton grafikun e funksionit dhe nyjet e përdorura.

    % --------- KONTROLLET ---------
    if n < 3
        error('Parametri n duhet të jetë >= 3.');
    end
    if mod(n, 3) ~= 0
        error('Për rregullin Simpson 3/8, n duhet të jetë shumëfish i 3 (n mod 3 = 0).');
    end

    % --------- NDARJA E INTERVALIT ---------
    h = (b - a) / n;        % gjatësia e hapit
    x = a:h:b;              % nyjet: gjithsej n+1 pika
    y = f(x);               % vlerat e funksionit në nyje

    % --------- INDEKSET E BRENDSHME ---------
    % Në formulë përdorim j = 1,2,...,n-1 (nyjet e brendshme)
    % Në MATLAB, këto korrespondojnë me y(j+1) sepse:
    % y(1) -> x0=a, y(n+1) -> xn=b
    j = 1:n-1;

    j_shumefish_3     = j(mod(j, 3) == 0);   % j të shumëfishtat e 3
    j_jo_shumefish_3  = j(mod(j, 3) ~= 0);   % j që nuk janë shumëfish të 3

    % --------- FORMULA E SIMPSONIT 3/8 (E KOMPOZUAR) ---------
    I = (3*h/8) * ( ...
        y(1) + y(end) + ...
        3 * sum( y(j_jo_shumefish_3 + 1) ) + ...
        2 * sum( y(j_shumefish_3     + 1) ) );

    % --------- GRAFIKU ---------
    xx = linspace(a, b, 400);
    yy = f(xx);

    figure;
    plot(xx, yy, 'k', 'LineWidth', 1.5); hold on;
    plot(x, y, 'ro-', 'LineWidth', 1.0, 'MarkerSize', 6);

    grid on;
    xlabel('x');
    ylabel('f(x)');
    titulli = sprintf('Rregulli i kompozuar i Simpson-it 3/8 (n = %d),  I ≈ %.10g', n, I);
    title(titulli);
    legend('Funksioni f(x)', 'Nyjet', 'Location', 'Best');
end
