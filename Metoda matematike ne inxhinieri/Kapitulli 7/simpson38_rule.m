function I = simpson38_rule(f, a, b, n)
%SIMPSON38_RULE Composite Simpson 3/8 rule for numerical integration with plot.
%   I = SIMPSON38_RULE(f, a, b, n) llogarit afersine e integralit
%   \int_a^b f(x) dx duke perdorur rregullin e kompozuar te Simpson-it 3/8.
%
%   f : funksion handle
%   a : kufiri i majte
%   b : kufiri i djathte
%   n : numri i nen-intervaleve (duhet te jete shumëfish i 3, n >= 3)
%
%   Funksioni gjithashtu vizaton grafikun e funksionit dhe nyjet.

    if mod(n, 3) ~= 0
        error('Per Simpson 3/8, n duhet te jete shumëfish i 3 (n mod 3 = 0).');
    end
    if n < 3
        error('n duhet te jete >= 3.');
    end

    h = (b - a) / n;
    x = a:h:b;
    y = f(x);

    idx = 2:n; % indeksat nga 2 deri ne n
    idx3 = idx(mod(idx, 3) == 0);     % indekset qe jane shumëfish i 3
    idx_not3 = idx(mod(idx, 3) ~= 0); % indekset qe NUK jane shumëfish i 3

    I = 3*h/8 * (y(1) + y(end) + ...
        3 * sum(y(idx_not3)) + ...
        2 * sum(y(idx3)));

    % ------------------ GRAFIKU ------------------
    xx = linspace(a, b, 400);
    yy = f(xx);

    figure;
    plot(xx, yy, 'k', 'LineWidth', 1.5); hold on;
    plot(x, y, 'ro-', 'LineWidth', 1.0, 'MarkerSize', 6);

    grid on;
    xlabel('x');
    ylabel('f(x)');
    title(sprintf('Composite Simpson 3/8 rule (n = %d)  I \approx %.6f', n, I), 'Interpreter', 'none');
    legend('f(x)', 'Nodes', 'Location', 'Best');

end
