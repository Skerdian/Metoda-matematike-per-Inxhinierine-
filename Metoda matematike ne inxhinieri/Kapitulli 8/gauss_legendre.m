function I = gauss_legendre(f, a, b, n)
switch n
    case 2
        xg = [-1/sqrt(3), 1/sqrt(3)];
        wg = [1,1];
    case 3
        xg = [-sqrt(3/5), 0, sqrt(3/5)];
        wg = [5/9, 8/9, 5/9];
    otherwise
        error('Vetem n=2 ose n=3');
end

xm = (a+b)/2;
xr = (b-a)/2;

I = 0;
for i=1:n
    I = I + wg(i) * f(xm + xr*xg(i));
end
I = xr * I;
end
