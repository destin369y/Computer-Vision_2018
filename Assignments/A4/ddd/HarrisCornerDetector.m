
function HarrisCornerDetector(image, epsilon, sigma, threshold)
	%% 1. "Cornerness" measure
	%Convert to gray scale
    figure(1);
    subplot 121; imshow(image);
    imGray = rgb2gray(image);
    subplot 122; imshow(imGray);
	%Compute Ix and Iy using central difference x-gradient and y-gradient filters respectively
	imGray = double(imGray);
    difx = 0.5 * [-1, 0, 1];
	dify = 0.5 * [-1; 0; 1];
	Ix = imfilter(imGray, difx, 'symmetric');
	Iy = imfilter(imGray, dify, 'symmetric');
    figure(2);
    subplot 121; imshow(uint8(Ix));
    subplot 122; imshow(uint8(Iy));
	%Compute Ix^2, Iy^2 and IxIy
	Ixx = Ix.^2;
	Iyy = Iy.^2;
	Ixy = Ix .* Iy;
    figure(3);
    subplot 131; imshow(uint8(Ixx));
    subplot 132; imshow(uint8(Iyy));
    subplot 133; imshow(uint8(Ixy));
	%Create a Gaussian smoothing filter
	gau = fspecial('gaussian', 4 * sigma, sigma);
    figure(4);
    surf(gau);
	%Apply the Gaussian filter to Ix^2, Iy^2 and IxIy
	gIxx = imfilter(Ixx, gau, 'symmetric');
	gIyy = imfilter(Iyy, gau, 'symmetric');
	gIxy = imfilter(Ixy, gau, 'symmetric');
    figure(5);
    subplot 131; imshow(uint8(gIxx));
    subplot 132; imshow(uint8(gIyy));
    subplot 133; imshow(uint8(gIxy));
	%Compute the cornerness measure M
	determinantH = gIxx .* gIyy - gIxy.^2;
	traceH = gIxx + gIyy;
	M = determinantH ./ (traceH + epsilon);
    figure(6);
    imshow(uint8(M));

	%% 2. Corner extraction
	%Perform non-maximal suppression on M to find local maximas.
	M(isnan(M)) = 0;
	M(M < threshold) = 0;
	corners = imregionalmax(M);
    figure(7);
    imshow(corners); 
    title(['Harris Corner with sigma = ', num2str(sigma), ', threshold = ', num2str(threshold)]);
    %Find the coordinates of the corner points.
    [x, y] = find(corners == 1);
    %{
    for i = 1 : length(x)      
        fprintf('(%d, %d);', y(i), x(i));
    end
    %}
    %Display the image and superimpose the corners.
    figure(8)
    imshow(image); hold on;
    for i = 1 : length(x)
        plot(y(i), x(i), 'b+');
    end 
    hold off;
end

