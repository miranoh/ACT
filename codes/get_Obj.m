function OBJ = get_Obj(ROI);
% This code generates a binary matrix of all of the connected objects in
% the input matrix. 
% 
% Miran Oh
% 02-08-2018

    Z = double(ROI-mean2(ROI))/double(std2(ROI)); %no abs (we want brighter intensities than mean, not darker ones)

    BW = Z > 0.8225; %binary matrix to get connected components (with confidence interval of 95% (one-sided) (90%: 0.64))

    CC=bwconncomp(BW); %get connected objects (flood-fill algorithm)
    numPixels = cellfun(@numel,CC.PixelIdxList); % get number of pixels for each object
    [biggest,idx] = max(numPixels); % find the biggest object

    if CC.NumObjects == 0
        BW = Z > 0.64;  % confidence interval of 90% (one-sided)
        noObj = sprintf('CI of 90 percent is used.');
        disp(noObj);
    end
    
    bw = BW;
    CC=bwconncomp(BW);
    for i = 1:CC.NumObjects % get binary matrix for each object
        for j = 1:CC.NumObjects
            if ~isequal(i, j)
                bw(CC.PixelIdxList{j}) = 0;
            end
        end
        OBJ{i} = bw;
        bw = BW;
    end
end