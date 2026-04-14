% ASEN 3802 - Aerodynamics Lab 
% Part 2: Analysis of Finite Wings with Prandtl Lifting Line Theory
%
% Authors: []
% Date: April 2026
% Course: ASEN 3802 - Aerodynamics Lab
%
% Description:
%   Implements the PLLT function and:
%   Validates against the lecture (L17p5) hand-calculation example
%   Reproduces Anderson Figure 5.20 (delta vs. taper ratio)

clear; clc; close all;

N = 50;         
a0_uniform = 2 * pi;  
geo_angle = 5;          
aero_angle = 0;          

% Aspect ratios and taper ratios 
AR_list = [4, 6, 8, 10];
lambda_list = linspace(0, 1.0, 80);  % ct/cr
delta_matrix = zeros(length(AR_list), length(lambda_list));

% Sweep over AR and taper ratio 
for k = 1:length(AR_list)
    AR = AR_list(k);

    for m = 1:length(lambda_list)
        lambda = lambda_list(m);   

        % Normalize c_r = 1; only ratios matter for delta
        c_r = 1.0;
        c_t = lambda * c_r;
        b = AR * (c_r + c_t) / 2;

        % Call PLLT 
        [e, ~, ~] = PLLT(b, a0_uniform, a0_uniform, ...
                         c_t, c_r,               ...
                         aero_angle, aero_angle,  ...
                         geo_angle,  geo_angle,   ...
                         N);
        % Recover delta from span efficiency
        delta_matrix(k, m) = 1/e - 1;
    end
end

% Plot
figure('Name', 'Anderson Fig 5.20 - Induced Drag Factor vs Taper Ratio', ...
       'NumberTitle', 'off', 'Position', [100, 100, 750, 520]);

hold on;
plot_colors = lines(length(AR_list));
line_styles = {'-', '--', '-.', ':'};

for k = 1:length(AR_list)
    plot(lambda_list, delta_matrix(k,:),       ...
         'Color',     plot_colors(k,:),         ...
         'LineStyle', line_styles{k},           ...
         'LineWidth', 2.0,                      ...
         'DisplayName', sprintf('AR = %d', AR_list(k)));
end

xlabel('Taper Ratio,  c_t / c_r',           'FontSize', 13);
ylabel('Induced Drag Factor,  \delta',        'FontSize', 13);
title ('Induced Drag Factor vs. Taper Ratio (Anderson Fig. 5.20)', 'FontSize', 13);
legend('Location', 'northeast', 'FontSize', 11);
grid on;
xlim([0, 1]);
ylim([0, 0.2]);
set(gca, 'FontSize', 11);

fprintf('Figure 5.20 plotted successfully.\n\n');

function [e, c_L, c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N)

    % Convert all angles from degrees to radians
    aero_t = deg2rad(aero_t);
    aero_r = deg2rad(aero_r);
    geo_t  = deg2rad(geo_t);
    geo_r  = deg2rad(geo_r);

    % Collocation points
    i     = (1:N)';
    theta = i * pi / (2*N);
    frac  = cos(theta);

    % Linear spanwise variation of local properties
    a0_loc   = a0_r   + (a0_t   - a0_r  ) .* frac;
    c_loc    = c_r    + (c_t    - c_r   ) .* frac;
    aL0_loc  = aero_r + (aero_t - aero_r) .* frac;
    alpha_loc = geo_r + (geo_t  - geo_r ) .* frac;

    % Odd Fourier term indices
    n_odd = 2*(1:N) - 1;

    % Build [N x N] matrix using nested loops
    M = zeros(N, N);
    for i = 1:N
        for j = 1:N
            n = n_odd(j);
            M(i,j) = sin(n * theta(i)) * (4*b / (a0_loc(i) * c_loc(i)) + n / sin(theta(i)));
        end
    end

    % Right hand side and solve
    RHS = alpha_loc - aL0_loc;
    A   = M \ RHS;

    % Wing area and aspect ratio
    S  = b * (c_r + c_t) / 2;
    AR = b^2 / S;

    % Lift coefficient
    c_L = pi * AR * A(1);

    % Induced drag factor delta
    delta = 0;
    for j = 2:N
        n     = n_odd(j);
        delta = delta + n * (A(j) / A(1))^2;
    end

    % Span efficiency and induced drag
    e    = 1 / (1 + delta);
    c_Di = c_L^2 / (pi * AR * e);

end