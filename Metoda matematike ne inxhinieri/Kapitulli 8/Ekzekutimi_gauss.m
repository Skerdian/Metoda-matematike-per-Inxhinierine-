function demo_gauss()
f1 = @(x) exp(x);
exact1 = exp(1)-1;

fprintf('\n=== Gauss-Legendre ne [0,1], f(x)=e^x ===\n');
fprintf('n   I_approx           I_exact           gabimi\n');
for n=[2,3]
    I = gauss_legendre(f1,0,1,n);
    fprintf('%d   %.10f   %.10f   %.3e\n', n, I, exact1, abs(I-exact1));
end

f2 = @(x) sin(x);
exact2 = 2;

fprintf('\n=== Gauss-Legendre ne [0,pi], f(x)=sin(x) ===\n');
fprintf('n   I_approx           I_exact           gabimi\n');
for n=[2,3]
    I = gauss_legendre(f2,0,pi,n);
    fprintf('%d   %.10f   %.10f   %.3e\n', n, I, exact2, abs(I-exact2));
end
end
