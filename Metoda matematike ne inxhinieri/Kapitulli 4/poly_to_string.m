function s = poly_to_string(p, varname)
% POLY_TO_STRING - Kthen koeficientet e nje polinomi ne nje string P(x) = ...
%
%   p       - vektori i koeficienteve [a_n ... a_1 a_0]
%   varname - emri i variables, p.sh. 'x'

    n = length(p);
    terms = {};

    for k = 1:n
        coeff = p(k);
        power = n - k;

        % anashkalo koeficientet shume afer zeros
        if abs(coeff) < 1e-12
            continue;
        end

        % shenja
        if coeff < 0
            sign_str = ' - ';
        else
            sign_str = ' + ';
        end

        c = abs(coeff);

        % pjese koeficienti
        if power == 0
            coeff_str = sprintf('%.4g', c);
        else
            if abs(c - 1) < 1e-12
                coeff_str = '';
            else
                coeff_str = sprintf('%.4g*', c);
            end
        end

        % pjese variable
        if power == 0
            var_str = '';
        elseif power == 1
            var_str = varname;
        else
            var_str = sprintf('%s^%d', varname, power);
        end

        term = [coeff_str var_str];
        terms{end+1} = [sign_str term]; %#ok<AGROW>
    end

    if isempty(terms)
        s = [ 'P(' varname ') = 0' ];
        return;
    end

    % trajto termat qe fillojne me ' + ' ose ' - '
    first = terms{1};
    if length(first) >= 3 && strcmp(first(1:3), ' + ')
        first = first(4:end);          % hiq ' + '
    elseif length(first) >= 3 && strcmp(first(1:3), ' - ')
        first = ['-' first(4:end)];    % beje '- ...'
    end

    s = ['P(' varname ') = ' first];
    for i = 2:numel(terms)
        s = [s terms{i}]; %#ok<AGROW>
    end
end

