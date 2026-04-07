% ASEN 3802 - Aerospace Sciences Laboratory 2
% Aerodynamics Lab - Part 1, Task 1
%
% Authors: Sam Wieder, Michael McAllister, David Hernandez,Carson Schlageter
% Date: April 7th, 2026
%
% Description:
% Generates the panel boundary point coordinates for a NACA 0021
% and NACA 2421 airfoil using equiangular spacing.

clearvars; 
clc; 
close all;

% Parameters
c = 1.0; 
N = 50; 

% NACA 0021 
m1 = 0.00;   
p1 = 0.00;   
t1 = 0.21;  

% NACA 2421 
m2 = 0.02;  
p2 = 0.40;   
t2 = 0.21;   

% Generate Airfoil Coordinates
[x_b1, y_b1, ~, ~] = NACA_Airfoils(m1, p1, t1, c, N);  % NACA 0021
[x_b2, y_b2, x_camber, y_camber] = NACA_Airfoils(m2, p2, t2, c, N);  % NACA 2421

% Figure 1 - NACA 0021
figure('Units', 'inches', 'Position', [1, 1, 10, 7]);
hold on;
 
% Surface line
h1 = plot(x_b1, y_b1, '-','Color', 'b', 'LineWidth', 1.8, 'DisplayName', 'NACA 0021 Surface');
 
% Panel boundary points
h2 = plot(x_b1, y_b1, 'o','Color', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 4.5, 'DisplayName', 'NACA 0021 Panel Points');
 
% Chord line reference
h3 = plot([0, c], [0, 0], '--','Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Chord Line');
 
hold off;
grid on;
axis equal;
 
xlabel('x/c', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('y/c', 'FontSize', 14, 'FontWeight', 'bold');
title('NACA 0021 Panel Geometry', 'FontSize', 14, 'FontWeight', 'bold');
 
x_margin = 0.05 * c;
y_margin = 0.15 * c;
xlim([-x_margin, c + x_margin]);
ylim([-0.20*c - y_margin, 0.20*c + y_margin]);
 
legend([h1, h2, h3], ...
    'Location', 'northeast', 'FontSize', 11, 'Box', 'on');
 
% Figure 2 - NACA 2421
figure('Units', 'inches', 'Position', [2, 2, 10, 7]);
hold on;
 
% Surface line
h4 = plot(x_b2, y_b2, '-', 'Color', 'r', 'LineWidth', 1.8, 'DisplayName', 'NACA 2421 Surface');
 
% Panel boundary points
h5 = plot(x_b2, y_b2, 's', 'Color', 'r', 'MarkerFaceColor', 'r', 'MarkerSize', 4.5, 'DisplayName', 'NACA 2421 Panel Points');
 
% Camber line
h6 = plot(x_camber, y_camber, '--', 'Color', [0.7, 0.3, 0.9], 'LineWidth', 1.8, 'DisplayName', 'NACA 2421 Camber Line');
 
% Chord line reference
h7 = plot([0, c], [0, 0], '--', 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Chord Line');
 
hold off;
grid on;
axis equal;
 
xlabel('x/c', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('y/c ', 'FontSize', 14, 'FontWeight', 'bold');
title('NACA 2421 Panel Geometry', 'FontSize', 14, 'FontWeight', 'bold');

x_margin = 0.05 * c;
y_margin = 0.15 * c;
xlim([-x_margin, c + x_margin]);
ylim([-0.20*c - y_margin, 0.20*c + y_margin]);
 
legend([h4, h5, h6, h7], ...
    'Location', 'northeast', 'FontSize', 11, 'Box', 'on');

function [x_b, y_b, x_camber, y_camber] = NACA_Airfoils(m, p, t, c, N)
% NACA_Airfoils Generates NACA 4-digit airfoil panel boundary points

% Equiangular spacing 
theta = linspace(0, pi, N + 1);
x = (c/2) .* (1 - cos(theta));
x = x(1:N); % take first N points 
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

x_camber = fliplr(x);
y_camber = fliplr(y_c);

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