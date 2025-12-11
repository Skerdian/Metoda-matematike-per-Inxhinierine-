% Shembull funksioni
f = @(x) exp(x);
a = 0;
b = 1;
n = 10;   % sipas rregullit (p.sh. n çift për Simpson 1/3, shumëfish i 3 për 3/8)

I_mid = midpoint_rule(f, a, b, n);
I_trap = trapezoidal_rule(f, a, b, n);
I_s13 = simpson13_rule(f, a, b, 10);   % n duhet te jete çift
I_s38 = simpson38_rule(f, a, b, 12);   % n duhet te jete shumëfish i 3
