function I = trapezoidal_rule(f, a, b, n)
%TRAPEZOIDAL_RULE Composite trapezoidal rule for numerical integration with plot.
%   I = TRAPEZOIDAL_RULE(f, a, b, n) llogarit afersine e integralit
%   \int_a^b f(x) dx duke perdorur rregullin e kompozuar te trapezit.
%
%   f : funksion handle, p.sh. @(x) sin(x)
%   a : kufiri i majte
%   b : kufiri i djathte
%   n : numri i nen-intervaleve (n >= 1)
%
%   Funksioni gjithashtu vizaton grafikun e funksionit dhe trapezet.

    if n < 1
        error('n duhet te jete >= 1');
    end

    h = (b - a) / n;
    x = a:h:b;
    y = f(x);

    % formula e kompozuar e trapezit
    I = h * (0.5 * y(1) + sum(y(2:end-1)) + 0.5 * y(end));

    % ------------------ GRAFIKU ------------------
    xx = linspace(a, b, 400);
    yy = f(xx);

    figure;
    plot(xx, yy, 'k', 'LineWidth', 1.5); hold on;

    for i = 1:n
        x_local = [x(i), x(i+1), x(i+1), x(i)];
        y_local = [0, 0, y(i+1), y(i)];
        patch(x_local, y_local, [0.9 0.8 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'r');
    end

    grid on;
    xlabel('x');
    ylabel('f(x)');
    title(sprintf('Composite trapezoidal rule (n = %d)  I \approx %.6f', n, I), 'Interpreter', 'none');
    legend('f(x)', 'Trapezoids', 'Location', 'Best');

end
