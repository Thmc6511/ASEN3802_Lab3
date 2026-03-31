clc
clear
close all

c = 3; % Temp arbitrary number

theta = linspace(0,360, 100);

r = c/2;

x = r + r* cosd(theta);

figure()
scatter(x, 1)