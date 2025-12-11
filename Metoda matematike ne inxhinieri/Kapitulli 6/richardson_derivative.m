function richardson_derivative()
% Ekstrapolimi i Richardson-it per derivatin e pare (shembull i thjeshte)

f  = @(x) exp(x);      % Funksioni
fp = @(x) exp(x);      % Derivati ekzakt

x0 = 1;                % Pika ku llogarisim derivatin
h  = 0.1;              % Hapi
p  = 2;                % Rendi i metodes qendrore

% 1) Llogarit D(h)
D_h = (f(x0 + h) - f(x0 - h)) / (2*h);

% 2) Llogarit D(h/2)
D_h2 = (f(x0 + h/2) - f(x0 - h/2)) / h;

% 3) Ekstrapolimi i Richardson-it
D_rich = (2^p * D_h2 - D_h) / (2^p - 1);

% 4) Derivati i sakte
D_exact = fp(x0);

% 5) Shfaqja e rezultateve ne MATLAB
fprintf('\n--- Ekstrapolimi i Richardson-it ---\n');
fprintf('Pika x0 = %.4f\n\n', x0);

fprintf('D(h)       = %.10f\n', D_h);
fprintf('D(h/2)     = %.10f\n', D_h2);
fprintf('Richardson = %.10f\n', D_rich);
fprintf('Exact      = %.10f\n\n', D_exact);

fprintf('Gabimi i Richardson-it = %.10e\n', abs(D_rich - D_exact));

end
