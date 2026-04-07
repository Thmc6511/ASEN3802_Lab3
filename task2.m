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

