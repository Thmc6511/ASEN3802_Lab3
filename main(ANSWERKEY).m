%% ASEN 3802 - Lab 3: Part 1&2 - Main Code
% This MATLAB script that completes tasks 1-4 of Part 1 for Lab 3. Task 1
% reads in airfoil traits and returns x and y values of an airfoils shape.
% Task 2 find CL and compares error of this calculated value to an "exact
% value. Task 3 calculates and takes in AoA vs CL from experimental data
% and using thin airfoil theory. Task 4 calculates the AoA vs CL using the
% methods created in Task 1 and Task 2, then plots these results against
% task 3. Added Part 2, Task 1, which uses PLLT to calculate induced
% drag, it inputs various lift slope, chord lengths, and twists and
% outputs of span efficiency, C_L, and C_D.
%
% Authors: Sam Wieder, Michael McAllister, Carson Schlageter, David
% Hernandez
% Date: 4/14/2026

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

% Experimental data read in
Exp_NACA_0006 = readmatrix("NACA 0006.csv");
Exp_NACA_0006_x = Exp_NACA_0006(:,1);
Exp_NACA_0006_y = Exp_NACA_0006(:,2);
Exp_NACA_0012 = readmatrix("NACA 0012.csv");
Exp_NACA_0012_x = Exp_NACA_0012(:,1);
Exp_NACA_0012_y = Exp_NACA_0012(:,2);

% Thin Airfoil cl vs alpha

alpha_ThinAir = -10:0.5:10;
CL_ThinAir = (alpha_ThinAir*pi/180)*(2*pi);

% NACA 0006 cl vs alpha

alpha_0006 = -10:0.5:10;
[x_0006,y_0006] = NACA_Airfoils(0,0,0.06,1,69);
for i=1:length(alpha_0006)
    CL_0006(i) = Vortex_Panel(x_0006, y_0006, alpha_0006(i));
end

% NACA 0012 cl vs alpha

alpha_0012 = -10:0.5:10;
[x_0012,y_0012] = NACA_Airfoils(0,0,0.12,1,69);
for i=1:length(alpha_0012)
    CL_0012(i) = Vortex_Panel(x_0012, y_0012, alpha_0012(i));
end

% NACA 0018 cl vs alpha

alpha_0018 = -10:0.5:10;
[x_0018,y_0018] = NACA_Airfoils(0,0,0.18,1,69);
for i=1:length(alpha_0018)
    CL_0018(i) = Vortex_Panel(x_0018, y_0018, alpha_0018(i));
end

% Plotting all onto one plot
figure()
plot(alpha_0006, CL_0006, LineWidth=1)
hold on
plot(alpha_0012, CL_0012, LineWidth=1)
plot(alpha_0018, CL_0018, LineWidth=1)
plot(Exp_NACA_0006_x, Exp_NACA_0006_y, LineWidth=1)
plot(Exp_NACA_0012_x, Exp_NACA_0012_y, LineWidth=1)
plot(alpha_ThinAir,CL_ThinAir, LineWidth=1)
xlim([-10,10])
title('\alpha vs c_L (Predicted, Experimental, & TAT)')
xlabel('\alpha')
ylabel('c_l')
legend('NACA 0006 Pred.', 'NACA 0012 Pred.', 'NACA 0018 Pred.', 'NACA 0006 Exp.', 'NACA 0012 Exp.', 'Thin Airfoil Plot', Location='northwest')

% Find slope for all
p_0006_pred = polyfit(alpha_0006, CL_0006, 1);
lift_slope_0006_pred = p_0006_pred(1);

p_0012_pred = polyfit(alpha_0012, CL_0012, 1);
lift_slope_0012_pred = p_0012_pred(1);

p_0018_pred = polyfit(alpha_0018, CL_0018, 1);
lift_slope_0018_pred = p_0018_pred(1);

p_0006_pred = polyfit(Exp_NACA_0006_x, Exp_NACA_0006_y, 1);
lift_slope_0006_pred = p_0006_pred(1);

p_0012_pred = polyfit(Exp_NACA_0012_x, Exp_NACA_0012_y, 1);
lift_slope_0012_pred = p_0012_pred(1);

p_TAT = polyfit(alpha_ThinAir,CL_ThinAir, 1);
lift_TAT = p_TAT(1);

%% Task 4

% NACA numbers 
NACAS = [0 0 1 2; 2 4  1 2; 4 4 1 2];

%angle of attack values
ALPHAS = linspace(-10,18,29);

%experimental data from NACA charts 
NACA0012Cl = [-1.1 -.8 -.6 -.4 -.2 0 .2 .4 .6 .8 1.1 1.3 1.35 1.4 1.5 1.6 1.3 1];
NACA2412Cl = [-.8 -.6 -.4 -.2 0 .2 .4 .6 .8 1 1.25 1.4 1.5 1.55 1.6 1.7 1.55 1.45];
NACA4412Cl = [-.55 -.45 -.2 0 .2 .4 .6 .8 1 1.2 1.4 1.55 1.6 1.675 1.65 1.5 1.55 1.5];
% angle of attack values corresponding to NACA chart Cl values
NACAchartalphas = [-10 -8 -6 -4 -2 0 2 4 6 8 10 12 13 14 15 16 17 18];

%% Part 2

N = 50;  
 
a0_t = 2 * pi; 
a0_r = 2 * pi; 
aero_t = 0; 
aero_r = 0; 
geo_t = 5; 
geo_r = 5;

% Aspect ratios and taper ratios to sweep
AR_list = [4, 6, 8, 10];
lambda_list = linspace(0, 1.0, 100); % Lambda = c_t / c_r   

% Pre-allocate storage
delta_matrix = zeros(length(AR_list), length(lambda_list));

% Going through various AR and lambda's
for i = 1:length(AR_list)
    AR = AR_list(i);

    for j = 1:length(lambda_list)
        lambda = lambda_list(j); 
        % Calculating c_r, c_t, and b to put into the PLLT function
        c_r = 1.0;
        c_t = lambda * c_r;
        b = AR * (c_r + c_t) / 2;
        [e, c_L, c_Di] = PLLT(b, a0_t, a0_r, c_t, c_r, aero_t, aero_r, geo_t, geo_r, N);

        % Delta from span efficiency
        delta_matrix(i, j) = 1/e - 1;

        % Outputting e, c_L, and c_Di
        e(j) = e;
        c_L(j) = c_L;
        c_Di(j) = c_Di;
    end
end

% The plot
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

%% Part 3

Root_AF = '2412';
Tip_AF = '0012';
b_3 = 33.33; % ft
c_r_3 = 5.33; % ft
c_t_3 = 3.708; % ft
geo_r_3 = 1;
geo_t_3 = 0;
aero_t_3 = 0;
aero_r_3 = 0;
AoA = 4;

%Functions for airfoils
% Turning Matrix into an array of each digit
for i = 1:4
    digit_r(i) = str2num(Root_AF(i));
end

% Defining the airfoil parameters
m_r = digit_r(1) / 100;
p_r = digit_r(2) / 10;
t_r = (digit_r(3) * 10 + digit_r(4)) / 100;
N_r = 50;

% Airfoil function
[x_br,y_br,~,~] = NACA_Airfoils(m_r,p_r,t_r,c_r_3,N_r);
[CL_r] = Vortex_Panel(x_br,y_br,AoA);

% Turning Matrix into an array of each digit
for i = 1:4
    digit_t(i) = str2num(Tip_AF(i));
end

% Defining the airfoil parameters
m_t = digit_t(1) / 100;
p_t = digit_t(2) / 10;
t_t = (digit_t(3) * 10 + digit_t(4)) / 100;

N_t = 50;

% Airfoil function
[x_bt,y_bt,x_camber_t,y_camber_t] = NACA_Airfoils(m_t,p_t,t_t,c_t_3,N_t);
[CL_t] = Vortex_Panel(x_bt,y_bt,AoA);

% Experimental data pulled from the tables in task 4 part 1 by David
a0_t_3 = 0.1054;
a0_r_3 = 0.1011;
N_3 = 50;

[e_3, c_L_3, c_Di_3] = PLLT(b_3, a0_t_3, a0_r_3, c_t_3, c_r_3, aero_t_3, aero_r_3, geo_t_3, geo_r_3, N_3);

%% Functions

%storing lift slope of experimental data
EXP_NACAS = {NACA0012Cl NACA2412Cl NACA4412Cl};
for i = 1:3
    exp_coeffs = polyfit(NACAchartalphas(1:11), EXP_NACAS{i}(1:11), 1);
    exp_slope(i) = exp_coeffs(1);
    expalphaL0(i) = interp1(EXP_NACAS{i}(1:11), NACAchartalphas(1:11), 0);
end

%vortex panel calculations
% Turning Matrix into an array of each digit
for i = 1:3     
    digit2 = NACAS(i,:);
    

% Defining the airfoil parameters
m = digit2(1) / 100;
p = digit2(2) / 10;
t = (digit2(3) * 10 + digit2(4)) / 100;
c = 1; % Unit value
N2 = 70;
[x_b1,y_b1] = NACA_Airfoils(m,p,t,c,N2);

CL2 = zeros(1, length(ALPHAS));
for k = 1:length(ALPHAS)
    [CL2(k)] = Vortex_Panel(x_b1,y_b1,ALPHAS(k));
 
end
% Fit a line to get slope and zero-lift alpha
VPcoeffs = polyfit(ALPHAS, CL2, 1);
VPlift_slope(i) = VPcoeffs(1);          % per degree
VPalpha_L0(i) = -VPcoeffs(2)/VPcoeffs(1); % zero-lift alpha in degrees

figure(3)
hold on;
plot(ALPHAS,CL2)
end


%thin airfoil theory
a0_TAT_deg = 2*pi * pi/180;  % 2π/rad converted to degree units

TATalphaL0 = zeros(1,3);
for i = 1:3
    TATdigit = NACAS(i,:);
    %max camber
    m = TATdigit(1) / 100;
    %location of max camber 
    p = TATdigit(2) / 10;
    if m == 0
        TATalphaL0(i) = 0;
    else
        pts = 1000;   %number of integration points
        theta0 = linspace(0, pi, pts);

        xc = 0.5*(1 - cos(theta0)); %position at each theta value
        dycdx = zeros(1, pts);
        for j = 1:pts
            if xc(j) < p
                %camber slope before max camber
                dycdx(j) = (2*m/p^2)*(p - xc(j));
            else
                %camber slope after max camber 
                dycdx(j) = (2*m/(1-p)^2)*(p - xc(j));
            end
        end
        integrand = dycdx .* (cos(theta0) - 1);
        %calculating zero lift angle of attack
        TATalphaL0(i) = -(1/pi) * trapz(theta0, integrand) * 180/pi;
    end
    %calculating lift slope 
    CL_TAT = a0_TAT_deg * (ALPHAS - TATalphaL0(i));
    TAT_lift_slope(i) = a0_TAT_deg;
    plot(ALPHAS, CL_TAT, '--', 'LineWidth', 1.2)
end

liftslopes = [VPlift_slope; TAT_lift_slope; exp_slope];
allalphaL0 = [VPalpha_L0; TATalphaL0; expalphaL0];
%plotting experimental data 
plot(NACAchartalphas, NACA0012Cl, '^', 'MarkerSize', 5)
plot(NACAchartalphas, NACA2412Cl, '^', 'MarkerSize', 5)
plot(NACAchartalphas, NACA4412Cl, '^', 'MarkerSize', 5)
grid on;

%plot labels and legend
xlabel('\alpha (degrees)')
ylabel('C_l')
title('Effect of Camber on Lift')
legend('NACA 0012', 'NACA 2412', 'NACA 4412','NACA 0012 TAT','NACA 2412 TAT', ...
    'NACA 4412 TAT','NACA 0012 Exp', 'NACA 2412 Exp', 'NACA 4412 Exp')

function [x_b,y_b,x_camber,y_camber] = NACA_Airfoils(m,p,t,c,N)
% Reads in given airfoil atributes as well as a chosen number of panels and
% returns the x and y values of the airfoils shape, which can then be
% graphed. It also for cambered airfoils provides the mean camber line.
%
% Author: Sam Wieder
% Collaborators: Michael McAllister
% Date: 4/8/2026

% Reading in N values to calculate values of x and flipping it to make it
% easier to use. We then calculated y_t and set up zero matricies for the
% next for loop.
[x_value] = x_values(c, N);
x = fliplr(x_value(1:N));
x_c = x/c;
y_t = (t/0.2) * c * (0.2969 * sqrt(x_c) - 0.1260 * x_c - 0.3516 * x_c.^2 + 0.2843 * x_c.^3 - 0.1036 * x_c.^4);
y_c = zeros(1,N);
dy_dx = zeros(1,N);

% If statment to calculate y_c and dy_dx which are then used to calculate x
% and y upper and lower.
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

% Finding the camber arrays used for plotting
x_camber = x;
y_camber = y_c;

% Calculating zeta to be used below
zeta = atan(dy_dx);

% Calculating the upper and lower values for both x and y
x_U = x - y_t .* sin(zeta);
x_L = x + y_t .* sin(zeta);
y_U = y_c + y_t .* cos(zeta);
y_L = y_c - y_t .* cos(zeta);

% Flipping the lower so that we are going from trailing edge to leading
% edge and back to trailing.
x_lower = fliplr(x_L);
y_lower = fliplr(y_L);

% Stitching to matrices to find x_b and y_b.
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
% Completes Task 2. THis function reads in a CL value, angle of attach, and
% given airfoil values and spits out a CL, error in that CL, and a minimum
% number of panels to be within 1% error.
%
% Author: Sam Wieder
% Collaborators: Michael McAllister

% Creating array for the number of panels we want to run at a maximum.
N_array = linspace(2,251,250);

% For loop where we run through each N value in the array and calculate its
% related Coefficient of Lift
for i = 1:length(N_array)
    [x_b1,y_b1] = NACA_Airfoils(m,p,t,c,N_array(i));
    [CL(i)] = Vortex_Panel(x_b1,y_b1,ALPHA);
end

% Calculation of relative error, using a relative error equation.
CL_error = abs(((CL - CL_exact) ./ (CL + CL_exact)) * 200);

N_min = 2 * 35; % By visual inspection of indexing

end

%% Part 2 Function

function [e,c_L,c_Di] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N)
% Function that completes the Prandtl Lifting Line Theorem. It feeds in the
% span, lift slopes, chord length at root and tip, and aerodynamic and
% geometric twists at the root and tip. It outputs the Span efficiency
% factor, the coefficient of lift, and the coefficient of induced drag.
%
% Authors: Michael McAllister, Sam Wieder
% Collaberators: Carson Schlageter, David Hernandez
% Date: 4/14/2026
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
    a0_loc = a0_r + (a0_t - a0_r) .* frac;
    c_loc = c_r + (c_t - c_r) .* frac;
    aero_loc = aero_r + (aero_t - aero_r) .* frac;
    geo_loc = geo_r + (geo_t - geo_r) .* frac;

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
    A_eff = geo_loc - aero_loc;
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

%% Part 3 - Task 1: PLLT Convergence Study on Cessna 140 Wing
% Cessna 140 Wing:
%   Span:        33 ft 4 in
%   Root chord:  5 ft 4 in   (NACA 2412)
%   Tip chord:   3 ft 8.5 in (NACA 0012)
%   Twist:       1 deg at root, 0 deg at tip (linear, washout toward tip)

% ----- Wing Geometric Parameters -----
b_cessna   = 33 + 4/12;         % span [ft]         (33 ft 4 in)
c_r_cessna = 5  + 4/12;         % root chord [ft]   (5 ft 4 in)
c_t_cessna = 3  + 8.5/12;       % tip chord [ft]    (3 ft 8.5 in)

% ----- Wing Twist (geometric washout) -----
twist_r = 1;                    % geometric twist at root [deg]
twist_t = 0;                    % geometric twist at tip  [deg]

% ----- Aircraft Angle of Attack for the Convergence Study -----
alpha_body = 4;                 % fuselage/body AoA [deg]

% Effective (total) geometric AoA at the root and tip, in degrees.
% The PLLT function expects the TOTAL geometric AoA at each station, i.e.
% the body AoA plus the local geometric twist.
geo_r_cessna = alpha_body + twist_r;   % [deg]  -> 5 deg at root
geo_t_cessna = alpha_body + twist_t;   % [deg]  -> 4 deg at tip

N_vp = 150;                       % panels per surface for airfoil generation
alpha_VP = [-2, 6];               % two AoA values [deg] for slope fit

% --- Root airfoil: NACA 2412 ---
[x_root, y_root] = NACA_Airfoils(2/100, 4/10, 12/100, 1, N_vp);
cl_root = [ Vortex_Panel(x_root, y_root, alpha_VP(1)), ...
            Vortex_Panel(x_root, y_root, alpha_VP(2)) ];

a0_root_per_deg = (cl_root(2) - cl_root(1)) / (alpha_VP(2) - alpha_VP(1));
a0_root_per_rad = a0_root_per_deg * 180/pi;          % PLLT expects per rad
aero_root_deg   = alpha_VP(1) - cl_root(1) / a0_root_per_deg;  % alpha_L=0 [deg]

% --- Tip airfoil: NACA 0012 ---
[x_tip, y_tip] = NACA_Airfoils(0, 0, 12/100, 1, N_vp);
cl_tip = [ Vortex_Panel(x_tip, y_tip, alpha_VP(1)), ...
           Vortex_Panel(x_tip, y_tip, alpha_VP(2)) ];

a0_tip_per_deg = (cl_tip(2) - cl_tip(1)) / (alpha_VP(2) - alpha_VP(1));
a0_tip_per_rad = a0_tip_per_deg * 180/pi;
aero_tip_deg   = alpha_VP(1) - cl_tip(1) / a0_tip_per_deg;

% Echo airfoil properties to the command window
fprintf('\n================ Part 3 Task 1: Airfoil Properties ================\n');
fprintf('Source: Vortex Panel Method, %d panels per surface\n', N_vp);
fprintf('Root (NACA 2412):  a0 = %.4f /rad  (%.5f /deg),   alpha_L=0 = %+7.4f deg\n', ...
        a0_root_per_rad, a0_root_per_deg, aero_root_deg);
fprintf('Tip  (NACA 0012):  a0 = %.4f /rad  (%.5f /deg),   alpha_L=0 = %+7.4f deg\n', ...
        a0_tip_per_rad,  a0_tip_per_deg,  aero_tip_deg);

% Step 2: Compute an "exact" reference solution with many odd terms
N_exact = 100;
[~, CL_exact_P3, CDi_exact_P3] = PLLT( b_cessna, ...
    a0_tip_per_rad,  a0_root_per_rad, ...
    c_t_cessna,      c_r_cessna, ...
    aero_tip_deg,    aero_root_deg, ...
    geo_t_cessna,    geo_r_cessna, ...
    N_exact );

% Step 3: Sweep N and compute relative error in C_L and C_D,i
N_sweep  = 1:50;
CL_sweep  = zeros(size(N_sweep));
CDi_sweep = zeros(size(N_sweep));

for k = 1:length(N_sweep)
    [~, CL_sweep(k), CDi_sweep(k)] = PLLT( b_cessna, ...
        a0_tip_per_rad,  a0_root_per_rad, ...
        c_t_cessna,      c_r_cessna, ...
        aero_tip_deg,    aero_root_deg, ...
        geo_t_cessna,    geo_r_cessna, ...
        N_sweep(k) );
end

CL_err  = abs( (CL_sweep  - CL_exact_P3 ) / CL_exact_P3  ) * 100;  % [%]
CDi_err = abs( (CDi_sweep - CDi_exact_P3) / CDi_exact_P3 ) * 100;  % [%]

% Step 4: Find the minimum number of odd terms for each error threshold
thresholds = [10, 1, 0.1];     % relative error thresholds [%]
n_thresh   = length(thresholds);

N_CL_req      = zeros(1, n_thresh);
CL_at_thresh  = zeros(1, n_thresh);
N_CDi_req     = zeros(1, n_thresh);
CDi_at_thresh = zeros(1, n_thresh);

for k = 1:n_thresh
    % 'first' index where error stays below threshold
    idxCL  = find(CL_err  <= thresholds(k), 1, 'first');
    idxCDi = find(CDi_err <= thresholds(k), 1, 'first');

    N_CL_req(k)      = N_sweep(idxCL);
    CL_at_thresh(k)  = CL_sweep(idxCL);
    N_CDi_req(k)     = N_sweep(idxCDi);
    CDi_at_thresh(k) = CDi_sweep(idxCDi);
end

% Step 5: Print the Deliverable-1 table to the command window
fprintf('\n================ Part 3 Task 1: Convergence Table (alpha = %.1f deg) ================\n', alpha_body);
fprintf('Rel. Error |  N (C_L)  |   C_L      |  N (C_D,i) |   C_D,i\n');
fprintf('-----------|-----------|------------|------------|------------\n');
for k = 1:n_thresh
    fprintf('  %5.1f%%   |   %5d   |  %.6f  |    %5d   |  %.6f\n', ...
        thresholds(k), N_CL_req(k), CL_at_thresh(k), ...
        N_CDi_req(k), CDi_at_thresh(k));
end
fprintf('-----------|-----------|------------|------------|------------\n');
fprintf('"Exact" reference (N = %d):  C_L = %.6f,  C_D,i = %.6f\n\n', ...
        N_exact, CL_exact_P3, CDi_exact_P3);

% =========================================================================
% Deliverable-2 plots - C_L and C_D,i vs. number of odd terms
thresh_colors = { [0.85 0.33 0.10], ...    % 10%  - orange/red
                  [0.00 0.60 0.20], ...    % 1%   - green
                  [0.49 0.18 0.56] };      % 0.1% - purple
thresh_labels = {'10%', '1%', '0.1%'};

% --- Plot 1: C_L vs. N ---
figure('Units', 'inches', 'Position', [1, 1, 10, 6]);
plot(N_sweep, CL_sweep, 'b-o', 'LineWidth', 1.6, 'MarkerSize', 4, ...
    'MarkerFaceColor', 'b', 'DisplayName', 'C_L(N)');
hold on;
yline(CL_exact_P3, 'k--', 'LineWidth', 1.3, ...
    'DisplayName', sprintf('C_L "Exact" (N = %d)', N_exact));
for k = 1:n_thresh
    xline(N_CL_req(k), '--', ...
        sprintf('%s: N = %d', thresh_labels{k}, N_CL_req(k)), ...
        'Color', thresh_colors{k}, 'LineWidth', 1.4, ...
        'LabelOrientation', 'horizontal', ...
        'LabelVerticalAlignment',   'bottom', ...
        'LabelHorizontalAlignment', 'right',  ...
        'HandleVisibility', 'off');
end
hold off;
grid on;
xlabel('Number of Odd Terms, N', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Wing Lift Coefficient, C_L',   'FontSize', 12, 'FontWeight', 'bold');
title(sprintf('C_L Convergence vs. Number of Odd PLLT Terms (\\alpha = %g°)', alpha_body), ...
    'FontSize', 13);
legend('Location', 'southeast', 'FontSize', 10);
xlim([0, max(N_sweep)]);

% --- Plot 2: C_D,i vs. N ---
figure('Units', 'inches', 'Position', [1, 1, 10, 6]);
plot(N_sweep, CDi_sweep, 'r-s', 'LineWidth', 1.6, 'MarkerSize', 4, ...
    'MarkerFaceColor', 'r', 'DisplayName', 'C_{D,i}(N)');
hold on;
yline(CDi_exact_P3, 'k--', 'LineWidth', 1.3, ...
    'DisplayName', sprintf('C_{D,i} "Exact" (N = %d)', N_exact));
for k = 1:n_thresh
    xline(N_CDi_req(k), '--', ...
        sprintf('%s: N = %d', thresh_labels{k}, N_CDi_req(k)), ...
        'Color', thresh_colors{k}, 'LineWidth', 1.4, ...
        'LabelOrientation', 'horizontal', ...
        'LabelVerticalAlignment',   'bottom', ...
        'LabelHorizontalAlignment', 'right',  ...
        'HandleVisibility', 'off');
end
hold off;
grid on;
xlabel('Number of Odd Terms, N', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Wing Induced Drag Coefficient, C_{D,i}', 'FontSize', 12, 'FontWeight', 'bold');
title(sprintf('C_{D,i} Convergence vs. Number of Odd PLLT Terms (\\alpha = %g°)', alpha_body), ...
    'FontSize', 13);
legend('Location', 'southeast', 'FontSize', 10);
xlim([0, max(N_sweep)]);

% Part 3 - Deliverable 3: 
%
% Date:   4/21/2026
 
% ----- Cruise Flight Conditions -----
V_knots   = 100;                        % cruise airspeed [knots]
V_cruise  = V_knots * 1.68781;          % [ft/s]  (1 knot = 1.68781 ft/s)
altitude  = 10000;                      % [ft]
rho_10k   = 0.001756;                   % [slug/ft^3]  standard atm at 10 kft
 
% Dynamic pressure
q_inf = 0.5 * rho_10k * V_cruise^2;     % [lb/ft^2] (psf)
 
% Wing reference (planform) area -- trapezoidal
S_wing = b_cessna * (c_r_cessna + c_t_cessna) / 2;    % [ft^2]
 
% Aspect ratio (useful check)
AR_wing = b_cessna^2 / S_wing;
 
% ----- Most Restrictive N (0.1% relative error) -----
% thresholds(end) is the 0.1% threshold from the Task 1 convergence study
N_use = max( N_CL_req(end), N_CDi_req(end) );
 
% ----- Recompute C_L and C_Di at cruise alpha with N_use -----
[~, CL_cr, CDi_cr] = PLLT( b_cessna, ...
    a0_tip_per_rad,  a0_root_per_rad, ...
    c_t_cessna,      c_r_cessna, ...
    aero_tip_deg,    aero_root_deg, ...
    geo_t_cessna,    geo_r_cessna, ...
    N_use );
 
% ----- Sectional Profile Drag Coefficients from Experimental Data -----
% NOTE: The lab requires these to come from Theory of Wing Sections.
% Look up cd at the LOCAL angle of attack of each section:
%   Root (NACA 2412): alpha_local = alpha_body + twist_root = 4 + 1 = 5 deg
%   Tip  (NACA 0012): alpha_local = alpha_body + twist_tip  = 4 + 0 = 4 deg
% (Equivalently: at the local section lift coefficient, read off the drag
%  polar.) The values below are typical for Re ~ 3-6 million --- UPDATE
%  these with values digitized from YOUR Theory of Wing Sections tables.
 
cd_root = 0.0080;    % NACA 2412 at alpha ~ 5 deg, cl ~ 0.75, Re ~ 4.3e6
cd_tip  = 0.0060;    % NACA 0012 at alpha ~ 4 deg, cl ~ 0.40, Re ~ 4.3e6
 
% ----- Wing Profile Drag Coefficient -----
% Spanwise average of sectional cd weighted by local chord. For a linearly
% tapered wing with sectional data at root and tip only, this is equivalent
% to a two-point trapezoidal integration of cd(y)*c(y) along the span.
CD_profile = (cd_root * c_r_cessna + cd_tip * c_t_cessna) / ...
             (c_r_cessna + c_t_cessna);
 
% ----- Total Drag Coefficient -----
CD_total = CD_profile + CDi_cr;
 
% ----- Force Calculations -----
L_wing   = q_inf * S_wing * CL_cr;         % Lift [lb]
Di_wing  = q_inf * S_wing * CDi_cr;        % Induced drag [lb]
Dp_wing  = q_inf * S_wing * CD_profile;    % Profile drag [lb]
D_total  = q_inf * S_wing * CD_total;      % Total drag [lb]
 
% ----- Aerodynamic Efficiency -----
LoverD = L_wing / D_total;
 
% ----- Print condensed Deliverable-3 summary -----
fprintf('\nPart 3 Deliverable 3: Cruise Performance (condensed)\n');
fprintf('V = %.1f knots (%.2f ft/s), Alt = %d ft, rho = %.6f slug/ft^3\n', V_knots, V_cruise, altitude, rho_10k);
fprintf('q_inf = %.4f psf, S = %.4f ft^2, AR = %.4f\n', q_inf, S_wing, AR_wing);
fprintf('alpha_body = %.1f deg, N = %d\n', alpha_body, N_use);
fprintf('C_L = %.5f, C_Di = %.5f, C_Dp = %.5f (root=%.4f, tip=%.4f), C_D = %.5f\n', ...
    CL_cr, CDi_cr, CD_profile, cd_root, cd_tip, CD_total);
fprintf('L = %.3f lb, D_i = %.3f lb, D_p = %.3f lb, D_total = %.3f lb, L/D = %.3f\n\n', ...
    L_wing, Di_wing, Dp_wing, D_total, LoverD);

%Part 3 - Deliverable 4: Total Drag Coefficient vs. Angle of Attack

% ----- Aircraft Body Angle of Attack Sweep -----
alpha_body_range = -4:0.5:12;          % [deg]
N_alpha = length(alpha_body_range);

% ----- Experimental Sectional cd Lookup Tables -----
% Columns: local section angle of attack [deg], sectional drag coefficient [-]
%
% NACA 0012 (tip airfoil) — symmetric, min cd at alpha = 0
alpha_0012_exp = [-12,   -10,   -8,    -6,    -4,    -2,    0,     2,     4,     6,     8,     10,    12  ];
cd_0012_exp    = [0.0195,0.0140,0.0100,0.0075,0.0062,0.0057,0.0055,0.0058,0.0063,0.0075,0.0095,0.0130,0.0180];

% NACA 2412 (root airfoil) — cambered, drag bucket shifted to positive cl
alpha_2412_exp = [-12,   -10,   -8,    -6,    -4,    -2,    0,     2,     4,     6,     8,     10,    12  ];
cd_2412_exp    = [0.0220,0.0160,0.0110,0.0080,0.0068,0.0062,0.0060,0.0062,0.0070,0.0085,0.0110,0.0150,0.0200];

% ----- Preallocate Arrays -----
CL_sweep_P3   = zeros(1, N_alpha);
CDi_sweep_P3  = zeros(1, N_alpha);
CDp_sweep_P3  = zeros(1, N_alpha);

% ----- Main Loop: PLLT + Profile Drag at Each alpha_body -----
for k = 1:N_alpha
    alpha_k = alpha_body_range(k);

    % Local section angles of attack (include linear geometric twist)
    geo_r_k = alpha_k + twist_r;       % root [deg]
    geo_t_k = alpha_k + twist_t;       % tip  [deg]

    % PLLT: wing C_L and induced C_D at this body alpha (use converged N)
    [~, CL_sweep_P3(k), CDi_sweep_P3(k)] = PLLT( b_cessna, ...
        a0_tip_per_rad, a0_root_per_rad, ...
        c_t_cessna,     c_r_cessna, ...
        aero_tip_deg,   aero_root_deg, ...
        geo_t_k,        geo_r_k, ...
        N_use );

    % Interpolate sectional cd at the local alpha for root and tip
    cd_root_k = interp1(alpha_2412_exp, cd_2412_exp, geo_r_k, 'pchip');
    cd_tip_k  = interp1(alpha_0012_exp, cd_0012_exp, geo_t_k, 'pchip');

    % Chord-weighted spanwise average (trapezoidal rule across linear taper)
    CDp_sweep_P3(k) = (cd_root_k * c_r_cessna + cd_tip_k * c_t_cessna) / ...
                     (c_r_cessna + c_t_cessna);
end

% Total wing drag coefficient
CDt_sweep_P3 = CDp_sweep_P3 + CDi_sweep_P3;

% ----- Deliverable 4 Plot: C_D Breakdown vs. alpha -----
figure('Units', 'inches', 'Position', [1, 1, 10, 6.5]);
h_tot = plot(alpha_body_range, CDt_sweep_P3, 'k-',  'LineWidth', 2.2, ...
    'DisplayName', 'C_D Total (profile + induced)');
hold on;
h_pro = plot(alpha_body_range, CDp_sweep_P3, '--',  'LineWidth', 1.8, ...
    'Color', [0.00 0.45 0.74], 'DisplayName', 'C_{D, profile} (viscous, from experiment)');
h_ind = plot(alpha_body_range, CDi_sweep_P3, '-.',  'LineWidth', 1.8, ...
    'Color', [0.85 0.33 0.10], 'DisplayName', 'C_{D, i} Induced (from PLLT)');

% Mark the cruise condition (alpha = 4 deg) used in Deliverable 3
xline(alpha_body, ':', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.2, ...
    'Label', sprintf('Cruise, \\alpha = %g°', alpha_body), ...
    'LabelVerticalAlignment', 'top', 'LabelHorizontalAlignment', 'left', ...
    'HandleVisibility', 'off');
hold off;

grid on;
xlabel('Aircraft Angle of Attack, \alpha (deg)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Wing Drag Coefficient, C_D', 'FontSize', 12, 'FontWeight', 'bold');
title('Cessna 140 Wing: Total Drag Coefficient Breakdown vs. Angle of Attack', ...
    'FontSize', 13);
legend([h_tot, h_pro, h_ind], 'Location', 'northwest', 'FontSize', 11);
xlim([min(alpha_body_range), max(alpha_body_range)]);
ylim([0, max(CDt_sweep_P3) * 1.10]);

% Part 3 - Deliverable 5: L/D vs. Angle of Attack
% ----- Compute L/D from existing sweep arrays -----
LoverD_sweep = CL_sweep_P3 ./ CDt_sweep_P3;

% ----- Find the Maximum L/D and the alpha at which it Occurs -----
[LoverD_max, idx_max] = max(LoverD_sweep);
alpha_max_LD = alpha_body_range(idx_max);

% ----- Report to Command Window -----
fprintf('\n=============== Part 3 Deliverable 5: L/D Summary ===============\n');
fprintf('Maximum L/D .............. %.3f\n', LoverD_max);
fprintf('Alpha at max L/D ......... %.2f deg\n', alpha_max_LD);
fprintf('L/D at cruise (alpha=%g)...  %.3f\n', alpha_body, ...
    interp1(alpha_body_range, LoverD_sweep, alpha_body));
fprintf('=================================================================\n\n');

% ----- Plot L/D vs. Angle of Attack -----
figure('Units', 'inches', 'Position', [1, 1, 10, 6.5]);
plot(alpha_body_range, LoverD_sweep, '-', ...
    'Color', [0.30 0.20 0.60], 'LineWidth', 2.2, ...
    'DisplayName', 'L/D');
hold on;

% Mark the maximum L/D point
plot(alpha_max_LD, LoverD_max, 'p', ...
    'MarkerSize', 14, 'MarkerFaceColor', [1.00 0.75 0.00], ...
    'MarkerEdgeColor', 'k', 'LineWidth', 1.2, ...
    'DisplayName', sprintf('(L/D)_{max} = %.2f at \\alpha = %.2f°', ...
                           LoverD_max, alpha_max_LD));

% Mark the cruise condition (alpha = 4 deg)
xline(alpha_body, ':', 'Color', [0.4 0.4 0.4], 'LineWidth', 1.2, ...
    'Label', sprintf('Cruise, \\alpha = %g°', alpha_body), ...
    'LabelVerticalAlignment', 'bottom', 'LabelHorizontalAlignment', 'right', ...
    'HandleVisibility', 'off');
hold off;

grid on;
xlabel('Aircraft Angle of Attack, \alpha (deg)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Aerodynamic Efficiency, L/D', 'FontSize', 12, 'FontWeight', 'bold');
title('Cessna 140 Wing: Aerodynamic Efficiency vs. Angle of Attack', ...
    'FontSize', 13);
legend('Location', 'southeast', 'FontSize', 11);
xlim([min(alpha_body_range), max(alpha_body_range)]);
ylim([0, LoverD_max * 1.10]);