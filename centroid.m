function centroid();
% by Miran Oh
% 07-22-2018

%%% This code tracks horizontal/vertical centroids/mean intensity level

clc; close all; imtool close all; clear; workspace; fontSize = 22; mediumfont = 18;
addpath(genpath('../ARTiCenT')) %addpath(genpath('videos'));

%% Change video
vidPath = 'videos/velar_implosive.mp4'; % Change video file

v = VideoReader(vidPath); 
%'videos/uvular_implosive.mp4' 'videos/velar_ejective.mp4'
% W = v.Width; H = v.Height;

frameN = v.NumberOfFrames;

x_cent = []; y_cent = [];
x_raw = []; y_raw = [];
x_max = []; y_max = []; mean_int = [];

%while hasFrame(v)
for frame = 1:frameN
    % Extract the frame from the movie structure.
    thisFrame = read(v, frame);
    Image{frame} = thisFrame;

 %% Do either A or B (A: select a new ROI, B: load existing ROI)
    %% A. Choose an ROI from the video (if you don't alreay have an ROI)
    if frame == 1
        [x,y,w,h, point_x, point_y] = select_ROI(thisFrame);
    end

%    %% B. Set known coordinates for the ROI (to use an existing ROI)
%     if frame == 1
%         rect = [155 219 18 66]; % CHANGE HERE "[xmin ymin width height]" of the ROI
%         seed = [168 246]; % CHANGE HERE "[x y]" seed points of the object
%         point_x = seed(1); point_y = seed(2); 
%         x = rect(1); y = rect(2); w = rect(3); h = rect(4);
%         rect_region = sprintf('Loaded ROI: [xmin ymin width height] = [%.f %.f %.f %.f]\n', rect);
%         disp(rect_region);
%     end
     
    %% Get pixel intensity & centroid of a rectangular ROI
    for i = 1:w
        for j = 1:h
            ROI(j,i) = thisFrame(y,x);
            y = y+1;
        end
        y = y - h; x = x+1;
    end
    x = x - w;
    
    raw_ROI{frame} = ROI;
    
    [xraw, yraw] = get_centroid(raw_ROI{frame});
    x_raw = [x_raw xraw];      y_raw = [y_raw yraw];
    
    max_ROI = ROI == max(max(ROI));
    [xmax, ymax] = get_centroid(max_ROI);
    x_max = [x_max xmax];      y_max = [y_max ymax];
    
    if frame == 1
        OBJ = get_Obj(ROI);
        for i = 1:length(OBJ)
            TEMP{i} = double(ROI) .* double(OBJ{i});
            TEMP{i} = round(mat2gray(TEMP{i}, [0 255]).*256);
            TEMP{i} = uint8(TEMP{i});
            [a,b] = get_centroid(TEMP{i});
            CENT{i} = [a,b];
        end
        for i = 1:length(CENT)
            DIST{i} = sqrt((point_x-x - CENT{i}(1))^2 + (point_y-y - CENT{i}(2))^2);
        end
        MinDist = min([DIST{:}]);
        for i = 1:length(DIST)
            if MinDist == DIST{i}
                bs_ROI{frame} = TEMP{i};
                centroid = CENT{i};
                xbar = centroid(1); ybar = centroid(2);
            end
        end
        x_cent = [x_cent xbar];    y_cent = [y_cent ybar];
        TEMP = []; CENT = []; DIST = [];
    end
    
    if ~isequal(frame, 1)
        OBJ = get_Obj(ROI);
        for i = 1:length(OBJ)
            TEMP{i} = double(ROI) .* double(OBJ{i});
            TEMP{i} = round(mat2gray(TEMP{i}, [0 255]).*256);
            TEMP{i} = uint8(TEMP{i});
            [a,b] = get_centroid(TEMP{i});
            CENT{i} = [a,b];
        end
        for i = 1:length(CENT)
            DIST{i} = sqrt((xbar - CENT{i}(1))^2 + (ybar - CENT{i}(2))^2);
        end
        MinDist = min([DIST{:}]);
        for i = 1:length(DIST)
            if MinDist == DIST{i}
                bs_ROI{frame} = TEMP{i};
                centroid = CENT{i};
                xbar = centroid(1); ybar = centroid(2);
            end
        end
        x_cent = [x_cent xbar];    y_cent = [y_cent ybar];
        TEMP = []; CENT = []; DIST = [];
    end
end

%% DISPLAY THE PLOTS (comment in this for loop for faster calculation)
for frame = 1:frameN % for frame = 1:100 (to test on first 100 frames)

    % Display each frame
    hImage = subplot(2, 3, 1);
    imshow(Image{frame});
    if frame == 1
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    end
    rectangle('Position',[x y w h],...
          'Curvature',[0.1,0.1],...
          'EdgeColor', 'b',...
         'LineWidth',0.5,'LineStyle','-')
    caption = sprintf('Frame %4d of %d', frame, frameN);
    title(caption, 'FontSize', mediumfont);
    drawnow; % Force it to refresh the window.

    %% Plot centroid for each frame  
    hImage = subplot(2, 3, 2);
    imshow(bs_ROI{frame}(1:h, 1:w)); 
    %imagesc(thisFrame(y:y+h-1, x:x+w-1)); 
    title('ROI', 'FontSize', mediumfont);
    hold on
    plot(x_cent(1:frame), y_cent(1:frame), 'b.');
    hold on
    plot(x_cent(frame), y_cent(frame), 'ro');
    hold off

    %% Plot horizontal centroid over time
    %smoothing
    x_loess = smooth(x_cent, 50, 'loess'); %a span of 10% of the total number of data points
    
    hImage = subplot(2, 3, 4);
    hold off;
%     plot(x_cent(1:frame), '-b', 'LineWidth', 2); %raw data
    plot(x_loess(1:frame), '-b', 'LineWidth', 2); %smooth data
    title('Horizontal Centroid Movement', 'FontSize', mediumfont);
    axis([0 frame 0 w]);
    xlim([0 frameN]);
    hold on;
    grid on;
    view([90 90])

    %% Plot vertical centroid over time
    %smoothing
    y_loess = smooth(y_cent, 50, 'loess'); %a span of 10% of the total number of data points
    hImage = subplot(2, 3, 5);
    hold off;
    plot(y_cent(1:frame), '-b', 'LineWidth', 2); %raw data
%     plot(y_loess(1:frame), '-b', 'LineWidth', 2); %smoothed
    title('Vertical Centroid Movement', 'FontSize', mediumfont);
    axis([0 frame 0 h]); axis ij;
    xlim([0 frameN]);
    hold on;
    grid on;

% Plot smoothed vertical movement
    hImage = subplot(2, 3, 6);
    hold off;
    plot(y_loess(1:frame), '-b', 'LineWidth', 2); %smoothed
    title('Smoothed Vertical Movement', 'FontSize', mediumfont);
    axis([0 frame 0 h]); axis ij;
    xlim([0 frameN]);
    hold on;
    grid on;
    
    %% Plot brightest point in ROI
%     hImage = subplot(2, 3, 6);
%     hold off;
%     plot(y_max(1:frame), '-r', 'LineWidth', 2);
%     title('Maximum Intensity Movement', 'FontSize', mediumfont);
%     axis([0 frame 0 h]); axis ij;
%     xlim([0 frameN]);
%     grid on;

    %smoothing
%     y_smooth = smooth(y_max, 50, 'loess');
%     hImage = subplot(2, 3, 6);
%     plot(y_smooth(1:frame), '-b', 'LineWidth', 2);
%     title('Maximum Intensity Movement', 'FontSize', mediumfont);
%     axis([0 frame 0 h]); axis ij;
%     xlim([0 frameN]);
%     hold on;
%     grid on;

    %% Calculate the mean gray level of the ROI.
    %grayImage = rgb2gray(thisFrame);
    meanLevels(frame) = mean(raw_ROI{frame}(:));

    % Plot the mean intensity levels.
%     hPlot = subplot(2, 3, 3);
%     hold off;
%     plot(meanLevels, 'k-', 'LineWidth', 2);
%     xlim([0 frameN]);
%     hold on;
%     grid on;

    mean_int = [mean_int meanLevels(frame)];

    %smoothing
    smoothmean = smooth(mean_int, 50, 'loess');
    hPlot = subplot(2, 3, 3);
    hold off;
    plot(smoothmean, 'k-', 'LineWidth', 2);
    xlim([0 frameN]);
	hold on;
    grid on;

    %% Put title back because plot() erases the existing title.
    title('Mean Intensity Levels of ROI', 'FontSize', mediumfont);
    if frame == 1
        xlabel('Frame Number');
        ylabel('Gray Level');
        % Get size data later for preallocation if we read
        % the movie back in from disk.
        [rows, columns, numberOfColorChannels] = size(thisFrame);
    end
end

%% Save the files (in the 'results' folder with selected ROI and seed)
    newFolder = 'results';
    newFolder = sprintf('%s', newFolder);

    [newSubFolder, filename] = save_data(x, y, w, h, point_x, point_y, vidPath, newFolder);
    
    y_centroid = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder, filename, '_y_raw', '.mat'); %chagne file name
    y_smoothed = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder, filename, '_y_smth', '.mat');
    x_centroid = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder, filename, '_x_raw', '.mat');
    x_smoothed = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder, filename, '_x_smth', '.mat');
    mean_intensity = sprintf('%s/%s/%s%s%s', newFolder, newSubFolder, filename, '_int', '.mat');
    
    saveas(gcf,sprintf('%s/%s/%s%s%s', newFolder, newSubFolder, filename, '_fig', '.png'));
    
    % rescale values 
    y_cent = -y_cent'; y_loess = -y_loess'; % note there's a minus (if not, the values are reversed)
    x_cent = x_cent'; x_loess = x_loess'; mean_int = mean_int';
    
    save(y_centroid, 'y_cent');
    save(y_smoothed, 'y_loess');
    save(x_centroid, 'x_cent');
    save(x_smoothed, 'x_loess');
    save(mean_intensity, 'mean_int');

end
% hold off