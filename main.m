clc;
clear;
close all;

%% Read in NACA files

NACA = 2412;
digit_array = num2str(NACA);

for i = 1:4
    digit(i) = str2num(digit_array(i));
end

m = digit(1);
p = digit(2);
t = digit(3) * 10 + digit(4);