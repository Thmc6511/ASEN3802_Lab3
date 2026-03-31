% =========================================================================
% Task1_Deliverable.m
% =========================================================================
% ASEN 3802 - Aerospace Sciences Laboratory 2
% Aerodynamics Lab - Part 1, Task 1 Deliverable
%
% Description:
%   Generates the required Task 1 deliverable plot showing the panel
%   geometry for a NACA 0021 (symmetric) and NACA 2421 (cambered) airfoil.
%   Both airfoils use 50 panels per surface with cosine (equiangular)
%   spacing. The camber line is plotted for the NACA 2421.
%
% Calls:
%   NACA_Airfoil.m
% =========================================================================

clearvars; 
clc; 
close all;

% Airfoil Parameters
c = 1.0; % Chord length 
N = 50; % Number of panels per surface (upper and lower)

% NACA 0021 
% Digits: 0 = 0% camber, 0 = camber at 0% chord, 21 = 21% thickness
m1 = 0.00;   
p1 = 0.00;   
t1 = 0.21;   

% NACA 2421 
% Digits: 2 = 2% camber, 4 = camber at 40% chord, 21 = 21% thickness
m2 = 0.02; 
p2 = 0.40;   
t2 = 0.21; 

% Generate Airfoil Coordinates
[x_b1, y_b1, ~,   ~  ] = NACA_Airfoil(m1, p1, t1, c, N);   
[x_b2, y_b2, x_c, y_c] = NACA_Airfoil(m2, p2, t2, c, N);   

% Plot
figure('Units', 'inches', 'Position', [1, 1, 10, 7]);
hold on;

% NACA 0021: Airfoil surface line 
h1 = plot(x_b1, y_b1, '-', ...
    'Color', [0.12, 0.47, 0.71], ...
    'LineWidth', 1.8, ...
    'DisplayName', 'NACA 0021 Surface');

% NACA 0021: Panel boundary points
h2 = plot(x_b1, y_b1, 'o', ...
    'Color',           [0.12, 0.47, 0.71], ...
    'MarkerFaceColor', [0.12, 0.47, 0.71], ...
    'MarkerSize',       4.5, ...
    'DisplayName',     'NACA 0021 Panel Points');

% NACA 2421: Airfoil surface line
h3 = plot(x_b2, y_b2, '-', ...
    'Color', [0.84, 0.15, 0.16], ...
    'LineWidth', 1.8, ...
    'DisplayName', 'NACA 2421 Surface');

% NACA 2421: Panel boundary points 
h4 = plot(x_b2, y_b2, 's', ...
    'Color',           [0.84, 0.15, 0.16], ...
    'MarkerFaceColor', [0.84, 0.15, 0.16], ...
    'MarkerSize',       4.5, ...
    'DisplayName',     'NACA 2421 Panel Points');

% NACA 2421: Camber line 
h5 = plot(x_c, y_c, '--', ...
    'Color', [0.17, 0.63, 0.17], ...
    'LineWidth', 1.8, ...
    'DisplayName', 'NACA 2421 Camber Line');

% Chord line reference 
h6 = plot([0, c], [0, 0], ':', ...
    'Color', [0.5, 0.5, 0.5], ...
    'LineWidth', 1.2, ...
    'DisplayName', 'Chord Line');

% Formatting
hold off;
axis equal;
grid on;
box on;

% Axis labels and title
xlabel('x/c  [ - ]', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('y/c  [ - ]', 'FontSize', 14, 'FontWeight', 'bold');
title({'NACA 4-Digit Airfoil Panel Geometry', ...
       sprintf('N = %d panels per surface | Cosine (Equiangular) Spacing', N)}, ...
    'FontSize', 14, 'FontWeight', 'bold');

% Normalize axes to chord length for cleaner tick labels
ax = gca;
ax.XTick = 0:0.1:c;
ax.FontSize = 12;
ax.LineWidth = 1.0;

% Tighten axis limits with a small margin
x_margin = 0.05 * c;
y_margin = 0.15 * c;
xlim([-x_margin, c + x_margin]);
ylim([-0.20 * c - y_margin, 0.20 * c + y_margin]);

% Legend
legend([h1, h2, h3, h4, h5, h6], ...
    'Location', 'northeast', ...
    'FontSize',  11, ...
    'Box',       'on');

% Print geometry info to command window
fprintf('\n=== Task 1: NACA Airfoil Generator ===\n');
fprintf('Chord length      : %.2f m\n', c);
fprintf('Panels per surface: %d\n', N);
fprintf('Total panels      : %d\n', 2*N);
fprintf('\nNACA 0021 - Total boundary points : %d\n', length(x_b1));
fprintf('  Leading  edge : (%.4f, %.4f)\n', x_b1(N+1), y_b1(N+1));
fprintf('  Trailing edge : (%.4f, %.4f)\n', x_b1(1),   y_b1(1));
fprintf('\nNACA 2421 - Total boundary points : %d\n', length(x_b2));
fprintf('  Leading  edge : (%.4f, %.4f)\n', x_b2(N+1), y_b2(N+1));
fprintf('  Trailing edge : (%.4f, %.4f)\n', x_b2(1),   y_b2(1));
fprintf('  Max camber    : %.4f m at x/c = %.2f\n', max(y_c), p2);
fprintf('======================================\n\n');
