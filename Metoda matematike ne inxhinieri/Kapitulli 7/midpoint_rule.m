function I = midpoint_rule(f, a, b, n)
%MIDPOINT_RULE Composite midpoint rule for numerical integration with plot.
%   I = MIDPOINT_RULE(f, a, b, n) llogarit afersine e integralit
%   \int_a^b f(x) dx duke perdorur rregullin e kompozuar te pikes se mesit.
%
%   f : funksion handle, p.sh. @(x) exp(x)
%   a : kufiri i majte i intervalit
%   b : kufiri i djathte i intervalit
%   n : numri i nen-intervaleve (n >= 1)
%
%   Funksioni gjithashtu vizaton grafikun e funksionit dhe drejtkendeshat.

    if n < 1
        error('n duhet te jete >= 1');
    end

    h = (b - a) / n;
    % pikat e mesit
    x_mid = a + ((1:n) - 0.5) * h;

    % vleresimi i formulës se kompozuar
    I = h * sum(f(x_mid));

    % ------------------ GRAFIKU ------------------
    xx = linspace(a, b, 400);
    yy = f(xx);

    figure;
    plot(xx, yy, 'k', 'LineWidth', 1.5); hold on;

    for i = 1:n
        xm = x_mid(i);
        ym = f(xm);
        xr = [xm - h/2, xm + h/2, xm + h/2, xm - h/2];
        yr = [0, 0, ym, ym];
        patch(xr, yr, [0.8 0.8 1.0], 'FaceAlpha', 0.5, 'EdgeColor', 'b');
    end

    grid on;
    xlabel('x');
    ylabel('f(x)');
    title(sprintf('Composite midpoint rule (n = %d)  I \approx %.6f', n, I), 'Interpreter', 'none');
    legend('f(x)', 'Rectangles', 'Location', 'Best');

end
