function [newSubFolder, filename] = save_data(x, y, w, h, point_x, point_y, vidPath, newFolder);

    if ~exist(newFolder, 'dir')
        mkdir(newFolder);
    end
    
    % A subfolder will be created with the selected ROI and seed e.g.'54 43 4 15_58 48
    newSubFolder = sprintf('%.f %.f %.f %.f_%.f %.f', x, y, w, h, round(point_x), round(point_y));
    if ~exist(newSubFolder, 'dir')
        sub_directory = strcat(newFolder, '/', newSubFolder);
        mkdir(sub_directory);
    end 
    
    addpath(genpath(newFolder)); %add folder and subfolders to search path
    
    file = strfind(vidPath,'/');
    fstart = file(length(file)); % the last "/" in the vidPath
    file = strfind(vidPath,'.');
    fend = file(length(file)); % the last "." in the vidPath
    filename = vidPath(fstart+1:fend-1);
end