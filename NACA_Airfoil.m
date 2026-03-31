function [x_b, y_b, x_camber, y_camber] = NACA_Airfoil(m, p, t, c, N)
% =========================================================================
% NACA_Airfoil.m
% =========================================================================
% ASEN 3802 - Aerospace Sciences Laboratory 2
% Aerodynamics Lab - Part 1, Task 1
%
% Description:
%   Generates the panel boundary point coordinates for a NACA 4-digit
%   airfoil using cosine (equiangular) spacing to cluster points near the
%   leading and trailing edges. Boundary points are ordered clockwise
%   starting and ending at the trailing edge, as required by Vortex_Panel.m
%
% Inputs:
%   m  - Maximum camber as a fraction of chord
%          (1st NACA digit / 100, e.g., 0.02 for NACA 2XXX)
%   p  - Chordwise location of maximum camber as a fraction of chord
%          (2nd NACA digit / 10, e.g., 0.4 for NACA X4XX)
%   t  - Maximum thickness as a fraction of chord
%          (last 2 NACA digits / 100, e.g., 0.12 for NACA XX12)
%   c  - Chord length [m]
%   N  - Number of panels on EACH surface (upper and lower)
%          Total panels = 2N
%
% Outputs:
%   x_b     - x-coordinates of boundary points [m], clockwise from TE
%   y_b     - y-coordinates of boundary points [m], clockwise from TE
%   x_camber - x-coordinates of the mean camber line [m]
%   y_camber - y-coordinates of the mean camber line [m]
% =========================================================================

% Step 1: Generate chordwise x-coordinates using equiangular spacing
theta = linspace(0, pi, N + 1);      
x = (c/2) .* (1 - cos(theta)); % x: 0 (LE) --> c (TE)

% Step 2: Compute thickness distribution y_t at each x location
xc = x / c; % Normalized chord coordinate 

y_t = (t / 0.2) .* c .* (0.2969 .* sqrt(xc) - 0.1260 .* xc - 0.3516 .* xc.^2 + 0.2843 .* xc.^3 - 0.1036 .* xc.^4);

% Step 3: Compute mean camber line and slope 
y_c = zeros(1, N + 1);
dyc_dx = zeros(1, N + 1);

if m ~= 0 && p ~= 0
    for i = 1:N + 1
        if x(i) < p * c
            % Forward region: 0 <= x < p*c
            y_c(i) = m * (x(i) / p^2) * (2*p - x(i)/c);
            dyc_dx(i) = (2*m / p^2) * (p - x(i)/c);
        else
            % Aft region: p*c <= x <= c
            y_c(i) = m * ((c - x(i)) / (1 - p)^2) * (1 + x(i)/c - 2*p);
            dyc_dx(i) = (2*m / (1 - p)^2) * (p - x(i)/c);
        end
    end
end

% Store camber line for plotting output
x_camber = x;
y_camber = y_c;

% Step 4: Compute local camber line angle 
xi = atan(dyc_dx);

% Step 5: Upper (U) and lower (L) surface coordinates
x_U = x - y_t .* sin(xi);
y_U = y_c + y_t .* cos(xi);

x_L = x + y_t .* sin(xi);
y_L = y_c - y_t .* cos(xi);

% Step 6: Arrange boundary points in clockwise orientation
x_upper = fliplr(x_U); % Upper surface: TE --> LE
y_upper = fliplr(y_U);

x_lower = x_L(2:end); % Lower surface: LE --> TE 
y_lower = y_L(2:end);

x_b = [x_upper, x_lower]; % Length = 2N + 1
y_b = [y_upper, y_lower];

end
