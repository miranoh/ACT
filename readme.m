%% Running centroide_3.m
% copy FILENAME(.avi) and paste it on line 6 (v=...)
% result files: "mean_int.mat", "x_cent.mat", "y_cent.mat"
% to view results
% load('y_cent.mat')
% plot(-y_cent) %+c
% to save the values as csv file
% csvwrite('vert.csv',-y_cent)


% v.Duration/v.NumberOfFrames*1000
% 12ms per frame


%% Set known coordinates for the ROI 
% uncomment this to apply to other videos of the same speaker
%      rect = [40 56 4 12]; % [41 56 2 11] change here
%      x = rect(1); y = rect(2); w = rect(3); h = rect(4);    