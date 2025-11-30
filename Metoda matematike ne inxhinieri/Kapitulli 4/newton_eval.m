%% ---------------- Funksioni ndihmes per vleresimin e Newtonit ----------------
function P = newton_eval(a, x_nodes, xp)
% NEWTON_EVAL - Vlereson polinomin e Newtonit ne piken xp
%   a       - koeficientet e Newtonit (nga diferencat e ndara)
%   x_nodes - nyjet e interpolimit
%   xp      - pika ku duam te vleresojme polinomin

    n = length(a);
    P = a(1);
    prod_term = 1;

    for k = 2:n
        prod_term = prod_term * (xp - x_nodes(k-1));
        P = P + a(k) * prod_term;
    end
end
