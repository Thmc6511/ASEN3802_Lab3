function [x_b,y_b] = NACA_Airfoils(m,p,t,c,N)
%NewFunction Summary of this function goes here
% Detailed explanation goes here
%
% Author: {primary author, should be you}
% Collaborators: J. Doe, J. Smith {acknowledge whomever you worked with}
% Date: {should include the date last revised}
[x_value] = x_values(c, N);
x = fliplr(x_value(1:N));
x_c = x/c;
y_t = (t/0.2) * c * (0.2969 * sqrt(x_c) - 0.1260 * x_c - 0.3516 * x_c.^2 + 0.2843 * x_c.^3 - 0.1036 * x_c.^4);
y_c = zeros(1,N);
dy_dx = zeros(1,N);

if m ~= 0 && p ~= 0
    for i = 1:N
        if x(i) < p * c
        y_c(i) = m * (x(i) / p^2) * (2*p - x(i)/c);
        dy_dx(i) = (2 * m / p) - (2 * m * x(i) / (p^2 * c));
        else
        y_c(i) = m * ((c - x(i))/(1-p)^2) * (1 + x(i)/c - 2*p);
        dy_dx(i) = m/(1-p)^2 * (2*p - 2*x(i)/c);
        end
    end
end

zeta = atan(dy_dx);

x_U = x - y_t .* sin(zeta);
x_L = x + y_t .* sin(zeta);
y_U = y_c + y_t .* cos(zeta);
y_L = y_c - y_t .* cos(zeta);

x_lower = fliplr(x_L);
y_lower = fliplr(y_L);

x_b = [x_lower,x_U];
y_b = [y_lower,y_U];

end
