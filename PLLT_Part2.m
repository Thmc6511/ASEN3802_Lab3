clear;
clc;
close all;

N = 50;          
a0_uniform = 2 * pi;     
geo_angle = 5; % Guess           
aero_angle = 0;    
 
a0_t = 2 * pi; 
a0_r = 2 * pi; 
aero_t = 0; 
aero_r = 0; 
geo_t = 5; 
geo_r = 5;

% Aspect ratios and taper ratios to sweep
AR_list = [4, 6, 8, 10];
lambda_list = linspace(0.0, 1.0, 60);   

% Pre-allocate storage
delta_matrix = zeros(length(AR_list), length(lambda_list));

for i = 1:length(AR_list)
    AR = AR_list(i);

    for j = 1:length(lambda_list)
        lambda = lambda_list(j);  
        c_r = 1.0;
        c_t = lambda * c_r;
        b = AR * (c_r + c_t) / 2;
        [e, c_L, c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N);

        % Delta from span efficiency
        delta_matrix(i, j) = 1/e - 1;

        c_L(j) = c_L;
        c_Di(j) = c_Di;
    end
end

figure;
hold on;
for k = 1:length(AR_list)
    plot(lambda_list, delta_matrix(k,:), 'DisplayName', sprintf('AR = %d', AR_list(k)));
end
xlabel('Taper Ratio, c_t/c_r');
ylabel('Induced Drag Factor, delta');
title('Induced Drag Factor vs. Taper Ratio (Anderson Fig. 5.20)');
legend;
grid on;
xlim([0, 1]);
ylim([0, 0.2]);

function [e, c_L, c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N)

    % Convert all angles from degrees to radians
    aero_t = deg2rad(aero_t);
    aero_r = deg2rad(aero_r);
    geo_t = deg2rad(geo_t);
    geo_r = deg2rad(geo_r);

    % Collocation points
    i = (1:N)';
    theta = i * pi / (2*N);
    frac = cos(theta);

    % Linearization to find local values
    a0_loc = a0_r + (a0_t - a0_r  ) .* frac;
    c_loc = c_r + (c_t - c_r) .* frac;
    aL0_loc = aero_r + (aero_t - aero_r) .* frac;
    alpha_loc = geo_r + (geo_t  - geo_r ) .* frac;

    % Odd Fourier term indices
    n_odd = 2*(1:N) - 1;

    % Build [N x N] matrix 
    M = zeros(N, N);
    for i = 1:N
        for j = 1:N
            n = n_odd(j);
            M(i,j) = sin(n * theta(i)) * (4*b / (a0_loc(i) * c_loc(i)) + n / sin(theta(i)));
        end
    end

    % Effective angle of attack
    A_eff = alpha_loc - aL0_loc;
    A = M \ A_eff;

    % Wing area and aspect ratio
    S = b * (c_r + c_t) / 2;
    AR = b^2 / S;

    % Lift coefficient
    c_L = pi * AR * A(1);

    % Induced drag factor delta
    delta = 0;
    for j = 2:N
        n = n_odd(j);
        delta = delta + n * (A(j) / A(1))^2;
    end

    % Span efficiency and induced drag
    e = 1 / (1 + delta);
    c_Di = c_L^2 / (pi * AR * e);

end