%% ASEN 3802 - Lab 3: Part 1 - Main Code
% This MATLAB script that completes tasks 1-4 of Part 1 for Lab 3. Task 1
% reads in airfoil traits and returns x and y values of an airfoils shape.
% Task 2 find CL and compares error of this calculated value to an "exact
% value. Task 3 calculates and takes in AoA vs CL from experimental data
% and using thin airfoil theory. Task 4 calculates the AoA vs CL using the
% methods created in Task 1 and Task 2, then plots these results against
% task 3.
%
% Authors: Sam Wieder, Michael McAllister, Carson Schlageter, David
% Hernandez
% Date: 4/8/2026

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
lift_slope_0006_pred = p_0006_pred(1)

p_0012_pred = polyfit(alpha_0012, CL_0012, 1);
lift_slope_0012_pred = p_0012_pred(1)

p_0018_pred = polyfit(alpha_0018, CL_0018, 1);
lift_slope_0018_pred = p_0018_pred(1)

p_0006_pred = polyfit(Exp_NACA_0006_x, Exp_NACA_0006_y, 1);
lift_slope_0006_pred = p_0006_pred(1)

p_0012_pred = polyfit(Exp_NACA_0012_x, Exp_NACA_0012_y, 1);
lift_slope_0012_pred = p_0012_pred(1)

p_TAT = polyfit(alpha_ThinAir,CL_ThinAir, 1);
lift_TAT = p_TAT(1)

%% Task 4

% NACA numbers 
NACAS = [0 0 1 2; 2 4 1 2; 4 4 1 2];

%angle of attack values
ALPHAS = linspace(-10,18,29);

%experimental data from NACA charts 
NACA0012Cl = [-1.1 -.8 -.6 -.4 -.2 0 .2 .4 .6 .8 1.1 1.3 1.35 1.4 1.5 1.6 1.3 1];
NACA2412Cl = [-.8 -.6 -.4 -.2 0 .2 .4 .6 .8 1 1.25 1.4 1.5 1.55 1.6 1.7 1.55 1.45];
NACA4412Cl = [-.55 -.45 -.2 0 .2 .4 .6 .8 1 1.2 1.4 1.55 1.6 1.675 1.65 1.5 1.55 1.5];
%angle of attack values corresponding to NACA chart Cl values
NACAchartalphas = [-10 -8 -6 -4 -2 0 2 4 6 8 10 12 13 14 15 16 17 18];

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
N2 = 34;
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
plot(NACAchartalphas, NACA0012Cl, 'o', 'MarkerSize', 5)
plot(NACAchartalphas, NACA2412Cl, 's', 'MarkerSize', 5)
plot(NACAchartalphas, NACA4412Cl, '^', 'MarkerSize', 5)
grid on;

%plot labels and legend
xlabel('\alpha (degrees)')
ylabel('C_l')
title('Effect of Camber on Lift')
legend('NACA 0012', 'NACA 2412', 'NACA 4412','NACA 0012 TAT','NACA 2412 TAT', ...
    'NACA 4412 TAT','NACA 0012 Exp', 'NACA 2412 Exp', 'NACA 4412 Exp')

%% Functions

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


