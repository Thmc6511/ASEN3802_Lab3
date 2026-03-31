clc
clear
close all

c = 3; %m

theta = linspace(0,360, 100);

r = c/2;

x = r + cosd(theta);

figure()
scatter(x, 1)