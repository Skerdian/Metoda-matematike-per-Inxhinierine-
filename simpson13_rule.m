function I = simpson13_rule(f, a, b, n)
%SIMPSON13_RULE Composite Simpson 1/3 rule for numerical integration with plot.
%   I = SIMPSON13_RULE(f, a, b, n) llogarit afersine e integralit
%   \int_a^b f(x) dx duke perdorur rregullin e kompozuar te Simpson-it 1/3.
%
%   f : funksion handle
%   a : kufiri i majte
%   b : kufiri i djathte
%   n : numri i nen-intervaleve (duhet te jete çift, n >= 2)
%
%   Funksioni gjithashtu vizaton grafikun e funksionit dhe nyjet.

    if mod(n, 2) ~= 0
        error('Per Simpson 1/3, n duhet te jete çift (n mod 2 = 0).');
    end
    if n < 2
        error('n duhet te jete >= 2.');
    end

    h = (b - a) / n;
    x = a:h:b;
    y = f(x);

    % formula e kompozuar e Simpson 1/3
    I = h/3 * (y(1) + y(end) + ...
        4 * sum(y(2:2:end-1)) + ...
        2 * sum(y(3:2:end-2)));

    % ------------------ GRAFIKU ------------------
    xx = linspace(a, b, 400);
    yy = f(xx);

    figure;
    plot(xx, yy, 'k', 'LineWidth', 1.5); hold on;
    plot(x, y, 'bo-', 'LineWidth', 1.0, 'MarkerSize', 6);

    grid on;
    xlabel('x');
    ylabel('f(x)');
    title(sprintf('Composite Simpson 1/3 rule (n = %d)  I \approx %.6f', n, I), 'Interpreter', 'none');
    legend('f(x)', 'Nodes', 'Location', 'Best');

end
