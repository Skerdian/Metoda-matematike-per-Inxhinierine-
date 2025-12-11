function demo_romberg()
f1 = @(x) exp(x);
exact1 = exp(1) - 1;
fprintf('\n=== Shembulli 1: e^x ne [0,1] ===\n');
R1 = romberg_integration(f1, 0, 1, 3);
fprintf('Rezultati final = %.10f, gabimi = %.3e\n', R1(end,end), abs(R1(end,end)-exact1));

f2 = @(x) sin(x);
fprintf('\n=== Shembulli 2: sin(x) ne [0,pi] ===\n');
R2 = romberg_integration(f2, 0, pi, 3);
fprintf('Rezultati final = %.10f, gabimi = %.3e\n', R2(end,end), abs(R2(end,end)-2));
end
