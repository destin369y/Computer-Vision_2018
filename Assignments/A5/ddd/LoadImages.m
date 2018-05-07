function [imSet, imGray, mask] = LoadImages(imCategory, imDirectory, imNum)
    figure(1);
    mask = imread(strcat(imDirectory, imCategory, '.mask.png'));
    %mask = im2bw(mask);
    mask = imbinarize(mask);
    mask = (mask > 0);
    [m, n, d] = size(mask);
    mask = mask(:, :, 1);
    
    imSet = zeros(m, n, d, imNum);
    imGray = zeros(m, n, imNum);
    for i = 1:imNum
        im = imread(strcat(imDirectory, imCategory, '.', int2str(i - 1), '.png'));
        subplot(3, 4, i), imshow(im);
        imSet(:, :, :, i) = im;
        imGray(:, :, i) = rgb2gray(im);
    end
end
