% DEMO_CUBIC_SPLINE_POINTS
% Shembull konkret i spline kubike natyrale per pikat:
% (1,1), (2,3), (3,2), (4,5).
%
% Pasi ndertohet spline me cubic_spline_custom, verifikojme edhe
% formulat e marra "me dore" per secilin nen-interval.

clear; clc; close all;

% Pikat e interpolimit
x = [1 2 3 4];
y = [1 3 2 5];

% Ndertojme spline natyral
pp = cubic_spline_custom(x, y, 'natural');

% Rrjeti i vleresimit
xx = linspace(1,4,400);
S_num = ppval(pp, xx);   % spline nga algoritmi i pergjithshem

% Spline sipas formulave manuale te nxjerra ne detyrimin teorik
S_exp = zeros(size(xx));

% Intervali [1,2]
I0 = (xx >= 1) & (xx <= 2);
xt = xx(I0);
S_exp(I0) = 1 + (46/15).*(xt-1) - (16/15).*(xt-1).^3;

% Intervali [2,3]
I1 = (xx > 2) & (xx <= 3);
xt = xx(I1);
S_exp(I1) = 3 - (2/15).*(xt-2) - (16/5).*(xt-2).^2 + (7/3).*(xt-2).^3;

% Intervali [3,4]
I2 = (xx > 3) & (xx <= 4);
xt = xx(I2);
S_exp(I2) = 2 + (7/15).*(xt-3) + (19/5).*(xt-3).^2 - (19/15).*(xt-3).^3;

% Gabimi maksimal midis dy formave
maxDiff = max(abs(S_num - S_exp));
fprintf('Gabimi maksimal midis spline-it numerik dhe atij manual: %.3e\n', maxDiff);

% Grafiku
figure;
plot(xx, S_num, 'b-', 'LineWidth', 1.8); hold on;
plot(xx, S_exp, 'r--', 'LineWidth', 1.2);
plot(x, y, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);
grid on;
xlabel('x');
ylabel('S(x)');
legend('Spline nga cubic\_spline\_custom', 'Spline nga formulat manuale', ...
       'Pikat e dhena', 'Location', 'Best');
title('Spline kubik natyral per pikat (1,1), (2,3), (3,2), (4,5)');
