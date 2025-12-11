function R = romberg_integration(f, a, b, max_level)
R = zeros(max_level+1, max_level+1);
h = b - a;
R(1,1) = 0.5 * h * (f(a) + f(b));

fprintf('\n======= Tabela e Romberg-ut =======\n');
fprintf('Niveli   h           R(k,0)        R(k,1)        R(k,2)        R(k,3)\n');
fprintf('-----------------------------------------------------------------------\n');
fprintf('%3d   %10.6f  %12.8f\n', 0, h, R(1,1));

for k = 1:max_level
    h = (b - a) / 2^k;
    x_new = a + h : 2*h : b - h;
    sum_new = sum(f(x_new));
    R(k+1,1) = 0.5 * R(k,1) + h * sum_new;

    for j = 2:(k+1)
        R(k+1,j) = R(k+1,j-1) + (R(k+1,j-1) - R(k,j-1))/(4^(j-1)-1);
    end

    fprintf('%3d   %10.6f', k, h);
    for j = 1:(k+1)
        fprintf('  %12.8f', R(k+1,j));
    end
    fprintf('\n');
end

fprintf('-----------------------------------------------------------------------\n');
fprintf('Vlera me e mire (Romberg) = %.10f\n', R(end,end));
end
