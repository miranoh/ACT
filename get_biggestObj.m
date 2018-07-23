function BW = get_biggestObj(ROI);
% This code generates a binary matrix of the biggest connected object in
% the input matrix. 
% 
% Miran Oh
% 08-04-2017

Z = double(ROI-mean2(ROI))/double(std2(ROI)); %no abs (we want brighter intensities than mean, not darker ones)

BW = Z > 0.8225; %binary matrix to get connected components (with confidence interval of 90% (95%: 0.98))

CC=bwconncomp(BW); %get connected objects (flood-fill algorithm)
numPixels = cellfun(@numel,CC.PixelIdxList); % get number of pixels for each object
[biggest,idx] = max(numPixels); % find the biggest object

    for i = 1:CC.NumObjects % convert all other smaller objects' value to 0
        if ~isequal(i, idx)
            BW(CC.PixelIdxList{i}) = 0;
        end
    end

end