function [x,y,w,h, point_x, point_y] = select_ROI(thisFrame);
% This code opens up an image, lets the users manually select a
% rectangular region, and gives xmin, ymin, width, and height of the ROI.
% 
% Miran Oh
% 08-04-2017

    firstFrame = thisFrame;

    % Display the first frame.
    imshow(firstFrame, []);
    title('First Frame', 'FontSize', 22);
    set(gca,'pos',[0 0 1 1]);
    set(gcf, 'Units', 'inches','Position',[5 5 5 5]);
    % set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); %Maximize window
    hold on;

    %%drag rectangle
    drawroi = sprintf('Click and drag on the image to draw a rectangular ROI.');
    disp(drawroi);
    h = imrect;
    setColor(h,'w');
    editroi = sprintf('Use the cursor to edit the rectangle.');
    disp(editroi);
    addNewPositionCallback(h,@(p) title(mat2str(p,3)));
    %addNewPositionCallback(h,@(p) xlabel(mat2str(p,3),'Color','k','fontweight','bold','FontSize', fontSize));
    fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),get(gca,'YLim'));
    setPositionConstraintFcn(h,fcn);

    endselection = sprintf('Double-click on the rectangle when you are done editing.');
    disp(endselection);
    rect = wait(h); %[xmin ymin width height]  %pos = wait(h) or %getPosition(h)
    rect = round(rect, 0); 
    rect_region = sprintf('Selected ROI: [xmin ymin width height] = [%.f %.f %.f %.f]\n', rect);
    disp(rect_region);
    x = rect(1); y = rect(2); w = rect(3); h = rect(4);

    select_point = sprintf('Click a point in the object you want to track.\nPress Enter to continue.\n');
    disp(select_point);
    [point_x, point_y] = getpts; 
    selected_seed = sprintf('Selected seed: [x y] = [%.f %.f]\n', [point_x, point_y]);
    disp(selected_seed);
end