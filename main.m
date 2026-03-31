clc;
clear;
close all;

%% Read in NACA files

% Defining NACA airfoil and turning it into a character
NACA = 2412;
digit_array = num2str(NACA);

% Turning Matrix into an array of each digit
for i = 1:4
    digit(i) = str2num(digit_array(i));
end

% Defining the airfoil parameters
m = digit(1);
p = digit(2);
t = digit(3) * 10 + digit(4);

% Airfoil function
[x_b,y_b] = NACA_Airfoils(m,p,t,c,N);

