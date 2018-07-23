function centroid_2ROI(); % centroid_2ROI(vidPath); % 
% by Miran Oh
% 07-22-2018

%%% This code tracks horizontal/vertical centroids of selected objects in two ROIs

clc; close all; imtool close all; workspace; fontSize = 22; mediumfont = 18;
addpath(genpath('../ARTiCenT')) %addpath(genpath('videos'));

%% Change video
vidPath = 'videos/velar_implosive.mp4'; % Change video file

v = VideoReader(vidPath); 
%'videos/uvular_implosive.mp4' 'videos/velar_ejective.mp4' 'videos/velar_implosive.mp4'
% W = v.Width; H = v.Height; 

frameN = v.NumberOfFrames;

x_cent1 = []; y_cent1 = []; x_cent2 = []; y_cent2 = [];

avg = zeros([v.Height v.Width 3]);
for frame = 1:frameN
    avg = avg + (1/frameN).*im2double(read(v,frame));
end
    
% for frame = 1:100 %frameN
for frame = 1:frameN

    % Extract the frame from the movie structure.
    thisFrame = read(v, frame);
    Image{frame} = thisFrame;
    
 %% Do either A or B (A: select a new ROI, B: load existing ROI)
    %% A. Choose an ROI from the video (if you don't alreay have an ROI)
    if frame == 1
        [x1,y1,w1,h1, point_x1, point_y1] = select_ROI(avg);
    end
    % One more ROI
    if frame == 1
        [x2,y2,w2,h2, point_x2, point_y2] = select_ROI(avg);
    end
    
%    %% B. Set known coordinates for the ROI (to use an existing ROI)
%     if frame == 1
%         rect = [55 44 3 11]; % CHANGE HERE "[xmin ymin width height]" of the 1st ROI
%         x1 = rect(1); y1 = rect(2); w1 = rect(3); h1 = rect(4);
%         rect_region1 = sprintf('1st ROI: [xmin ymin width height] = [%.f %.f %.f %.f]', rect);
%         disp(rect_region1);
%         
%         rect = [42 27 5 7]; % CHANGE HERE "[xmin ymin width height]" of the 2nd ROI
%         x2 = rect(1); y2 = rect(2); w2 = rect(3); h2 = rect(4);
%         rect_region2 = sprintf('2nd ROI: [xmin ymin width height] = [%.f %.f %.f %.f]\n', rect);
%         disp(rect_region2);
%         
%         imshow(avg, []);
%         title('Averaged Frame', 'FontSize', 22);
%         set(gca,'pos',[0 0 1 1]);
%         set(gcf, 'Units', 'inches','Position',[5 5 5 5]);
%         hold on;
%         rectangle('Position',[x1 y1 w1 h1], 'Curvature',[0.1,0.1],...
%               'EdgeColor', 'b', 'LineWidth',0.8, 'LineStyle','-')
%         hold on
%         grid on
%         rectangle('Position',[x2 y2 w2 h2], 'Curvature',[0.1,0.1],...
%               'EdgeColor', 'g','LineWidth',0.8, 'LineStyle','-')
%         hold on
%         
% %         [point_x1, point_y1] = getpts; 
% %         [point_x2, point_y2] = getpts; 
%
%         seed = [57 49]; % CHANGE HERE "[x y]" seed points of the 1st object
%         point_x1 = seed(1); point_y1 = seed(2); 
%         
%         seed = [43 32]; % CHANGE HERE "[x y]" seed points of the 2nd object
%         point_x2 = seed(1); point_y2 = seed(2); 
%         
%         selected_seed = sprintf('1st seed: [x y] = [%.f %.f]\n2nd seed: [x y] = [%.f %.f]', [point_x1, point_y1], [point_x2, point_y2]);
%         disp(selected_seed);
%     end
    
    %% Get pixel intensity & centroid of the 1st ROI
    for i = 1:w1
        for j = 1:h1
            ROI1(j,i) = thisFrame(y1,x1);
            y1 = y1+1;
        end
        y1 = y1 - h1; x1 = x1+1;
    end
    x1 = x1 - w1;
    
    if frame == 1
        OBJ1 = get_Obj(ROI1);
        for i = 1:length(OBJ1)
            TEMP{i} = double(ROI1) .* double(OBJ1{i});
            TEMP{i} = round(mat2gray(TEMP{i}, [0 255]).*256);
            TEMP{i} = uint8(TEMP{i});
            [a,b] = get_centroid(TEMP{i});
            CENT{i} = [a,b];
        end
        for i = 1:length(CENT)
            DIST{i} = sqrt((point_x1-x1 - CENT{i}(1))^2 + (point_y1-y1 - CENT{i}(2))^2);
        end
        MinDist = min([DIST{:}]);
        for i = 1:length(DIST)
            if MinDist == DIST{i}
                bs_ROI1{frame} = TEMP{i};
                centroid = CENT{i};
                xbar1 = centroid(1); ybar1 = centroid(2);
            end
        end
        x_cent1 = [x_cent1 xbar1];    y_cent1 = [y_cent1 ybar1];
        TEMP = []; CENT = []; DIST = [];
    end
    
    if ~isequal(frame, 1)
        OBJ1 = get_Obj(ROI1);
        for i = 1:length(OBJ1)
            TEMP{i} = double(ROI1) .* double(OBJ1{i});
            TEMP{i} = round(mat2gray(TEMP{i}, [0 255]).*256);
            TEMP{i} = uint8(TEMP{i});
            [a,b] = get_centroid(TEMP{i});
            CENT{i} = [a,b];
        end
        for i = 1:length(CENT)
            DIST{i} = sqrt((xbar1 - CENT{i}(1))^2 + (ybar1 - CENT{i}(2))^2);
        end
        MinDist = min([DIST{:}]);
        for i = 1:length(DIST)
            if MinDist == DIST{i}
                bs_ROI1{frame} = TEMP{i};
                centroid = CENT{i};
                xbar1 = centroid(1); ybar1 = centroid(2);
            end
        end
        x_cent1 = [x_cent1 xbar1];    y_cent1 = [y_cent1 ybar1];
        TEMP = []; CENT = []; DIST = [];
    end

    %% Get pixel intensity & centroid of the 2nd ROI
    for i = 1:w2
        for j = 1:h2
            ROI2(j,i) = thisFrame(y2,x2);
            y2 = y2+1;
        end
        y2 = y2 - h2; x2 = x2+1;
    end
    x2 = x2 - w2;
    
    if frame == 1
        OBJ2 = get_Obj(ROI2);
        for i = 1:length(OBJ2)
            TEMP{i} = double(ROI2) .* double(OBJ2{i});
            TEMP{i} = round(mat2gray(TEMP{i}, [0 255]).*256);
            TEMP{i} = uint8(TEMP{i});
            [a,b] = get_centroid(TEMP{i});
            CENT{i} = [a,b];
        end
        for i = 1:length(CENT)
            DIST{i} = sqrt((point_x2-x2 - CENT{i}(1))^2 + (point_y2-y2 - CENT{i}(2))^2);
        end
        MinDist = min([DIST{:}]);
        for i = 1:length(DIST)
            if MinDist == DIST{i}
                bs_ROI2{frame} = TEMP{i};
                centroid = CENT{i};
                xbar2 = centroid(1); ybar2 = centroid(2);
            end
        end
        x_cent2 = [x_cent2 xbar2];    y_cent2 = [y_cent2 ybar2];
        TEMP = []; CENT = []; DIST = [];
    end
    
    if ~isequal(frame, 1)
        OBJ2 = get_Obj(ROI2);
        for i = 1:length(OBJ2)
            TEMP{i} = double(ROI2) .* double(OBJ2{i});
            TEMP{i} = round(mat2gray(TEMP{i}, [0 255]).*256);
            TEMP{i} = uint8(TEMP{i});
            [a,b] = get_centroid(TEMP{i});
            CENT{i} = [a,b];
        end
        for i = 1:length(CENT)
            DIST{i} = sqrt((xbar2 - CENT{i}(1))^2 + (ybar2 - CENT{i}(2))^2);
        end
        MinDist = min([DIST{:}]);
        for i = 1:length(DIST)
            if MinDist == DIST{i}
                bs_ROI2{frame} = TEMP{i};
                centroid = CENT{i};
                xbar2 = centroid(1); ybar2 = centroid(2);
            end
        end
        x_cent2 = [x_cent2 xbar2];    y_cent2 = [y_cent2 ybar2];
        TEMP = []; CENT = []; DIST = [];
    end
end

%% Smoothing
x_loess1 = smooth(x_cent1, 30, 'loess'); % a span of '30' data points
x_loess2 = smooth(x_cent2, 30, 'loess');
y_loess1 = smooth(y_cent1, 30, 'loess');
y_loess2 = smooth(y_cent2, 30, 'loess');

%% DISPLAY THE PLOTS (comment in this for loop for faster calculation)
for frame = 1:frameN % for frame = 1:100 (to test on first 100 frames) % frameN
    
    % Display each frame
    hImage = subplot(2, 3, 1);
    imshow(Image{frame});
    if frame == 1
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    end
    rectangle('Position',[x1 y1 w1 h1],...
          'Curvature',[0.1,0.1],...
          'EdgeColor', 'b',...
         'LineWidth',0.8,'LineStyle','-')
    hold on
    grid on
    rectangle('Position',[x2 y2 w2 h2],...
          'Curvature',[0.1,0.1],...
          'EdgeColor', 'g',...
         'LineWidth',0.8,'LineStyle','-')
    caption = sprintf('Frame %4d of %d', frame, frameN);
    title(caption, 'FontSize', mediumfont);
    drawnow; % Force it to refresh the window.

    %% Plot first centroid for each frame  
    hImage = subplot(2, 3, 2);
    imshow(bs_ROI1{frame}(1:h1, 1:w1)); 
    title('1st ROI', 'FontSize', mediumfont);
    hold on;
    plot(x_cent1(1:frame), y_cent1(1:frame), 'b.');
    hold on;
    plot(x_cent1(frame), y_cent1(frame), 'ro');
    hold off;
    
    %% Plot second centroid 
    hImage = subplot(2, 3, 3);
    imshow(bs_ROI2{frame}(1:h2, 1:w2));  
    title('2nd ROI', 'FontSize', mediumfont);
    hold on
    plot(x_cent2(1:frame), y_cent2(1:frame), 'g.');
    hold on
    plot(x_cent2(frame), y_cent2(frame), 'ro');
    hold off

    %% Plot horizontal centroid over time
    hImage = subplot(2, 3, 4);
%     plot(x_cent1(1:frame), '-b', 'LineWidth', 2); %raw data
    plot(x_loess1(1:frame), '-b', 'LineWidth', 2); %smooth data
    title('Horizontal Centroid (1st ROI)', 'FontSize', mediumfont);
    axis([0 frame 0 w1]);
    xlim([0 frameN]);
    hold on;
    grid on;
    view([90 90])

    %% Plot vertical centroid over time
    hImage = subplot(2, 3, 5);
    hold off;
    %     plot(y_cent1(1:frame), '-b', 'LineWidth', 2); %raw data
    plot(y_loess1(1:frame), '-b', 'LineWidth', 2); %smoothed
    title('Vertical Centroid (1st ROI)', 'FontSize', mediumfont);
    axis([0 frame 0 h1]); axis ij;
    xlim([0 frameN]);
    hold on;
    grid on;

    %% Plot vertical centroid (2nd ROI)
    hImage = subplot(2, 3, 6);
    hold off;
    %     plot(y_cent2(1:frame), '-b', 'LineWidth', 2); %raw data
    plot(y_loess2(1:frame), '-k', 'LineWidth', 2); %smoothed
    title('Vertical Centroid (2nd ROI)', 'FontSize', mediumfont);
    axis([0 frame 0 h2]); axis ij;
    xlim([0 frameN]);
    hold on;
    grid on;
end

%% Save the files (in the 'results' folder with selected ROI and seed)
    newFolder = 'results';
    newFolder = sprintf('%s', newFolder);
    
    [newSubFolder1, filename] = save_data(x1, y1, w1, h1, point_x1, point_y1, vidPath, newFolder);
    [newSubFolder2, filename2] = save_data(x2, y2, w2, h2, point_x2, point_y2, vidPath, newFolder);
    
    %% 1st ROI
    y_centroid1 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder1, filename, '_y_raw1', '.mat'); %change file name
    y_smoothed1 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder1, filename, '_y_smth1', '.mat');
    x_centroid1 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder1, filename, '_x_raw1', '.mat');
    x_smoothed1 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder1, filename, '_x_smth1', '.mat');
    
    % rescale values 
    % note there's a minus (if not, the values are reversed)
    y_cent1 = -y_cent1'; %y_cent1 = y_cent1 - min(y_cent1); % (set minimum to 0, and rescale range from 0 to max)
    y_loess1 = -y_loess1'; %y_loess1 = y_loess1 - min(y_loess1);
    x_cent1 = x_cent1'; %x_cent1 = x_cent1 - min(x_cent1); 
    x_loess1 = x_loess1'; %x_loess1 = x_loess1 - min(x_loess1);
    
    save(y_centroid1, 'y_cent1');
    save(y_smoothed1, 'y_loess1');
    save(x_centroid1, 'x_cent1');
    save(x_smoothed1, 'x_loess1');
    saveas(gcf,sprintf('%s/%s/%s%s%s', newFolder, newSubFolder1, filename, '_fig', '.png'));
    
    %% 2nd ROI
    y_centroid2 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder2, filename, '_y_raw2', '.mat'); %change file name
    y_smoothed2 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder2, filename, '_y_smth2', '.mat');
    x_centroid2 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder2, filename, '_x_raw2', '.mat');
    x_smoothed2 = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder2, filename, '_x_smth2', '.mat');
    
    % rescale values 
    y_cent2 = -y_cent2'; %y_cent2 = y_cent2 - min(y_cent2); 
    y_loess2 = -y_loess2'; %y_loess2 = y_loess2 - min(y_loess2);
    x_cent2 = x_cent2'; %x_cent2 = x_cent2 - min(x_cent2); 
    x_loess2 = x_loess2'; %x_loess2 = x_loess2 - min(x_loess2);
    
    save(y_centroid2, 'y_cent2');
    save(y_smoothed2, 'y_loess2');
    save(x_centroid2, 'x_cent2');
    save(x_smoothed2, 'x_loess2');
    
    saveas(gcf,sprintf('%s/%s/%s%s%s', newFolder, newSubFolder2, filename, '_fig', '.png'));
end
% hold off