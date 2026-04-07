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

