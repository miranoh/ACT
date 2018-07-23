function [xbar, ybar] = get_centroid(ROI);
% This code calculates the intensity-weighted centroid of the input ROi. 
% 
% Miran Oh
% 08-04-2017

    [n_rows, n_columns] = size(ROI);
    [X_mesh, Y_mesh] = meshgrid(1:n_columns, 1:n_rows);
        
    xbar = sum(sum(X_mesh.*double(ROI))) / sum(sum(double(ROI)));
    ybar = sum(sum(Y_mesh.*double(ROI))) / sum(sum(double(ROI)));
end