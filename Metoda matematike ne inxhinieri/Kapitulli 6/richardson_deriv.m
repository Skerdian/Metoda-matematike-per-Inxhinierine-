function [D_best, R] = richardson_deriv(f, x0, h, nLevels)
% RICHARDSON_DERIV - Derivim numerik me ekstrapolim Richardson
%   f       - handle i funksionit, p.sh. @(x) sin(x)
%   x0      - pika ku llogarisim derivatin
%   h       - hapi fillestar
%   nLevels - numri i niveleve të Richardson-it (p.sh. 3, 4, 5)
%
%   D_best  - vlera më e mirë e derivatit (fundorja e tabelës)
%   R       - tabela e Richardson-it (nLevels x nLevels)

    if nargin < 4
        nLevels = 3;
    end

    R = zeros(nLevels, nLevels);

    % -------------------------------------------------
    % 1) Diferenca qendrore për hapa h, h/2, h/4, ...
    % -------------------------------------------------
    for k = 1:nLevels
        hk = h / 2^(k-1);
        R(k,1) = ( f(x0 + hk) - f(x0 - hk) ) / (2*hk);
    end

    % -------------------------------------------------
    % 2) Ekstrapolimi Richardson (p = 2 për diferencë qendrore)
    % -------------------------------------------------
    p = 2;  % rendi i skemës bazë
    for j = 2:nLevels
        for k = j:nLevels
            R(k,j) = R(k,j-1) + ( R(k,j-1) - R(k-1,j-1) ) / ( 2^(p*(j-1)) - 1 );
        end
    end

    D_best = R(nLevels, nLevels);
end
