function richardson_derivative_interval()
% RICHardson ekstrapolimi per derivatin e pare ne nje interval
% Shembull: f(x) = exp(x) ne intervalin [0, 1] me hap h = 0.1
%
% Mund te ndryshosh:
%   - funksionin f dhe derivatin e tij fp
%   - intervalin [a, b]
%   - hapin h

%% Funksioni dhe derivati i tij (ndrysho sipas deshires)
f  = @(x) exp(x);   % funksioni
fp = @(x) exp(x);   % derivati ekzakt

%% Parametrat e intervalit
a = 0;              % kufiri i majte
b = 1;              % kufiri i djathte
h = 0.1;            % hapi
p = 2;              % rendi i metodes qendrore (p = 2)

% Pikat ku llogarisim derivatin
x = a:h:b;
n = numel(x);

% Vektoret per rezultatet
D_h     = zeros(size(x));   % derivati me diference qendrore, hap h
D_h2    = zeros(size(x));   % derivati me diference qendrore, hap h/2
D_rich  = zeros(size(x));   % ekstrapolimi i Richardson-it
D_exact = fp(x);            % derivati i sakte

%% Llogaritja e D(h), D(h/2) dhe ekstrapolimit ne cdo pike
for k = 1:n
    xk = x(k);

    % Diferenca qendrore me hap h
    D_h(k) = (f(xk + h) - f(xk - h)) / (2*h);

    % Diferenca qendrore me hap h/2
    D_h2(k) = (f(xk + h/2) - f(xk - h/2)) / h;

    % Ekstrapolimi i Richardson-it
    D_rich(k) = (2^p * D_h2(k) - D_h(k)) / (2^p - 1);
end

%% Tabela e rezultateve (afishohet ne Command Window)
fprintf('\n--- Ekstrapolimi i Richardson-it ne interval ---\n');
fprintf('  k      x_k        D(h)          D(h/2)       D_rich        D_exact       |D_rich - D_exact|\n');
fprintf('----------------------------------------------------------------------------------------------\n');
for k = 1:n
    fprintf('%3d  %9.5f  %11.7f  %11.7f  %11.7f  %11.7f  %14.7e\n', ...
        k, x(k), D_h(k), D_h2(k), D_rich(k), D_exact(k), abs(D_rich(k) - D_exact(k)));
end

%% Grafiku i derivateve
figure;
plot(x, D_exact, '-k', 'LineWidth', 1.5); hold on;
plot(x, D_h, 'bo-', 'LineWidth', 1.0, 'MarkerSize', 5);
plot(x, D_rich, 'r--', 'LineWidth', 1.5);
grid on;
xlabel('x');
ylabel('f''(x)');
title('Derivati: ekzakt, qendror (h) dhe Richardson');
legend('Derivati ekzakt', 'Diferenca qendrore D(h)', 'Ekstrapolimi Richardson', ...
       'Location', 'Best');

%% Grafiku i gabimit te Richardson-it
figure;
semilogy(x, abs(D_rich - D_exact), 'ms-', 'LineWidth', 1.5, 'MarkerSize', 6);
grid on;
xlabel('x');
ylabel('|D_{rich} - f''(x)|');
title('Gabimi absolut i ekstrapolimit Richardson');

end
