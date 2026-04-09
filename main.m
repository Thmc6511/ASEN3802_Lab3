%% ASEN 3802 - Lab 3 - Main Code
% Provide a breif summary of the problem statement and code so that
% you or someone else can later understand what you attempted to do
% it doesn’t have to be that long.
%
% Author: {Sam Wieder}
% Collaborators: J. Doe, J. Smith {acknowledge whomever you worked with}
% Date: {should include the date last revised}
% Then start your code, i.e.

clc;
clear;
close all

%% Read in NACA files

% Defining NACA airfoil for 0021
NACA_1 = '0021';

% Turning Matrix into an array of each digit
for i = 1:4
    digit_1(i) = str2num(NACA_1(i));
end

% Defining the airfoil parameters
m_1 = digit_1(1) / 100;
p_1 = digit_1(2) / 10;
t_1 = (digit_1(3) * 10 + digit_1(4)) / 100;
c = 1;
N = 50;

% Airfoil function
[x_b1,y_b1,~,~] = NACA_Airfoils(m_1,p_1,t_1,c,N);

% Defining NACA airfoil for 2421
NACA_2 = '2421';

% Turning Matrix into an array of each digit
for i = 1:4
    digit_2(i) = str2num(NACA_2(i));
end

% Defining the airfoil parameters
m_2 = digit_2(1) / 100;
p_2 = digit_2(2) / 10;
t_2 = (digit_2(3) * 10 + digit_2(4)) / 100;

% Airfoil function
[x_b2,y_b2,x_camber,y_camber] = NACA_Airfoils(m_2,p_2,t_2,c,N);

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
% Labels, titles, and tidying
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
% Labels, titles, and tidying
xlabel('x/c', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('y/c ', 'FontSize', 14, 'FontWeight', 'bold');
title('NACA 2421 Panel Geometry', 'FontSize', 14, 'FontWeight', 'bold');
x_margin = 0.05 * c;
y_margin = 0.15 * c;
xlim([-x_margin, c + x_margin]);
ylim([-0.20*c - y_margin, 0.20*c + y_margin]);
legend([h4, h5, h6, h7], ...
    'Location', 'northeast', 'FontSize', 11, 'Box', 'on');

%% Task 2

% Defining the '0012' Airfoil for Task 2 calculations
NACA_3 = '0012';

% Turning Matrix into an array of each digit
for i = 1:4
    digit_3(i) = str2num(NACA_3(i));
end

% Defining the airfoil parameters
m_3 = digit_3(1) / 100;
p_3 = digit_3(2) / 10;
t_3 = (digit_3(3) * 10 + digit_3(4)) / 100;

% Defining Alpha
ALPHA = 12;

% Using a very large number of N to calculate for Cl_exact
[x_exact,y_exact] = NACA_Airfoils(m_3,p_3,t_3,c,1000);
[CL_exact] = Vortex_Panel(x_exact,y_exact,ALPHA);

% Printing our Exact Cl value to Command Window
fprintf('Exact Cl value: %f \n',CL_exact)

% Function to calculate N vs Cl
[N_min,CL_error,N_array,CL] = task2(CL_exact,ALPHA,m_3,p_3,t_3,c);

% Plotting for Task 2
figure()
plot(2 * N_array,CL)
hold on;
yline(CL_exact, 'k')
yline(CL_exact + 0.01 * CL_exact,'r--')
yline(CL_exact - 0.01 * CL_exact,'r--')
xlim([0,400])
grid on;
title('Number of Panels vs Coefficient of Lift for NACA 0012')
xlabel('Number of Panels (N)')
ylabel('Coefficient of Lift (C_L)')
legend('Calculated C_L','C_L Exact','1% Error Bounds')

%% Task 3




%% Task 4

%% Functions

function [x_b,y_b,x_camber,y_camber] = NACA_Airfoils(m,p,t,c,N)
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

x_camber = x;
y_camber = y_c;

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

function [x_values] = x_values(chord_length, number_of_panels_per_surface)
%Summary
% This function uses equiangular rays fro the center fo the airfoil to a
% circle which fits the entire airfoil. The purpose of this function is to
% generate the x-values of our airfoil plot in a way which plots more
% values towards the curved points of the airfoil.
%
% Author: Carson Schlageter
% Collaborators: 
% Date: 3/31/2026
number_of_values = number_of_panels_per_surface * 2;
theta = linspace(0,360, number_of_values);

r = chord_length/2;

x_values = r + r * cosd(theta);
end

function [CL] = Vortex_Panel(XB,YB,ALPHA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:                           %
%                                  %
% XB  = Boundary Points x-location %
% YB  = Boundary Points y-location %
% VINF  = Free-stream Flow Speed   %
% ALPHA = AOA                      %
%                                  %
% Output:                          %
%                                  %
% CL = Sectional Lift Coefficient  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% Convert to Radians %
%%%%%%%%%%%%%%%%%%%%%%

ALPHA = ALPHA*pi/180;

%%%%%%%%%%%%%%%%%%%%%
% Compute the Chord %
%%%%%%%%%%%%%%%%%%%%%

CHORD = max(XB)-min(XB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine the Number of Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = max(size(XB,1),size(XB,2))-1;
MP1 = M+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Intra-Panel Relationships:                                  %
%                                                             %
% Determine the Control Points, Panel Sizes, and Panel Angles %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    IP1 = I+1;
    X(I) = 0.5*(XB(I)+XB(IP1));
    Y(I) = 0.5*(YB(I)+YB(IP1));
    S(I) = sqrt( (XB(IP1)-XB(I))^2 +( YB(IP1)-YB(I))^2 );
    THETA(I) = atan2( YB(IP1)-YB(I), XB(IP1)-XB(I) );
    SINE(I) = sin( THETA(I) );
    COSINE(I) = cos( THETA(I) );
    RHS(I) = sin( THETA(I)-ALPHA );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-Panel Relationships:             %
%                                        %
% Determine the Integrals between Panels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    for J = 1:M
        if I == J
            CN1(I,J) = -1.0;
            CN2(I,J) = 1.0;
            CT1(I,J) = 0.5*pi;
            CT2(I,J) = 0.5*pi;
        else
            A = -(X(I)-XB(J))*COSINE(J) - (Y(I)-YB(J))*SINE(J);
            B = (X(I)-XB(J))^2 + (Y(I)-YB(J))^2;
            C = sin( THETA(I)-THETA(J) );
            D = cos( THETA(I)-THETA(J) );
            E = (X(I)-XB(J))*SINE(J) - (Y(I)-YB(J))*COSINE(J);
            F = log( 1.0 + S(J)*(S(J)+2*A)/B );
            G = atan2( E*S(J), B+A*S(J) );
            P = (X(I)-XB(J)) * sin( THETA(I) - 2*THETA(J) ) ...
              + (Y(I)-YB(J)) * cos( THETA(I) - 2*THETA(J) );
            Q = (X(I)-XB(J)) * cos( THETA(I) - 2*THETA(J) ) ...
              - (Y(I)-YB(J)) * sin( THETA(I) - 2*THETA(J) );
            CN2(I,J) = D + 0.5*Q*F/S(J) - (A*C+D*E)*G/S(J);
            CN1(I,J) = 0.5*D*F + C*G - CN2(I,J);
            CT2(I,J) = C + 0.5*P*F/S(J) + (A*D-C*E)*G/S(J);
            CT1(I,J) = 0.5*C*F - D*G - CT2(I,J);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inter-Panel Relationships:           %
%                                      %
% Determine the Influence Coefficients %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    AN(I,1) = CN1(I,1);
    AN(I,MP1) = CN2(I,M);
    AT(I,1) = CT1(I,1);
    AT(I,MP1) = CT2(I,M);
    for J = 2:M
        AN(I,J) = CN1(I,J) + CN2(I,J-1);
        AT(I,J) = CT1(I,J) + CT2(I,J-1);
    end
end
AN(MP1,1) = 1.0;
AN(MP1,MP1) = 1.0;
for J = 2:M
    AN(MP1,J) = 0.0;
end
RHS(MP1) = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for the gammas %
%%%%%%%%%%%%%%%%%%%%%%%%

GAMA = AN\RHS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for Tangential Veloity and Coefficient of Pressure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for I = 1:M
    V(I) = cos( THETA(I)-ALPHA );
    for J = 1:MP1
        V(I) = V(I) + AT(I,J)*GAMA(J);
    end
    CP(I) = 1.0 - V(I)^2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve for Sectional Coefficient of Lift %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CIRCULATION = sum(S.*V);
CL = 2*CIRCULATION/CHORD;
end

function [N_min,CL_error,N_array,CL] = task2(CL_exact,ALPHA,m,p,t,c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N_array = linspace(2,251,250);

for i = 1:length(N_array)
    [x_b1,y_b1] = NACA_Airfoils(m,p,t,c,N_array(i));
    [CL(i)] = Vortex_Panel(x_b1,y_b1,ALPHA);
end

CL_error = abs(((CL - CL_exact) ./ (CL + CL_exact)) * 200);

N_min = 2 * 35; % By visual inspection of indexing

end


