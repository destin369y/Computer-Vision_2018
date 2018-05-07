echo off
clear all
home
echo on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comp546
% Assignment2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chengyin Liu, cl93
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Canny Edge detection

%
%% Read image 'cameraman.tif'
%
im1 = imread('cameraman.tif');
im1_double = double(im1);
imshow(uint8(im1));
pause

%
%% (a) Noise Reduction
%
nrFilter = 1.0 / 159 * [2 4 5 4 2; 
                        4 9 12 9 4; 
                        5 12 15 12 5; 
                        4 9 12 9 4; 
                        2 4 5 4 2];
im1_nr = imfilter(im1_double, nrFilter);
imshow(uint8(im1_nr));
pause

%
%% (b) Gradient Magnitude and Angle
%Compute the derivatives ( Dx(x, y) and Dy(x, y) )
Dx = [-1 0 1; -2 0 2; -1 0 1];
Dy = [1 2 1; 0 0 0; -1 -2 -1];
%Dy = [-1 -2 -1; 0 0 0; 1 2 1];
im1_Dx = imfilter(im1_nr, Dx);
im1_Dy = imfilter(im1_nr, Dy);
subplot 121, imshow(uint8(im1_Dx)); title('Dx');
subplot 122, imshow(uint8(im1_Dy)); title('Dy');
pause

clf;
%Compute the gradient magnitude
im1_mag = sqrt(im1_Dx.^2 + im1_Dy.^2);
imshow(uint8(im1_mag));
pause

%the angle of the gradient
im1_ang = atan2(im1_Dy, im1_Dx);
%im1_ang = atan2(im1_Dx, im1_Dy);
%Compute ¦È¡¯ by rounding the angle ¦È to one of four directions 0, 45, 90, or 135.
im1_ang_rou = im1_ang .* 180 ./ pi;
im1_ang_rou(im1_ang_rou < 0) = im1_ang_rou(im1_ang_rou < 0) + 180;
im1_ang_rou = round(im1_ang_rou ./ 45) .* 45;
im1_ang_rou(im1_ang_rou >= 180) = im1_ang_rou(im1_ang_rou >= 180) - 180;

%
%% (c) Non-Maximum Suppression
%
im1_mag_nms = im1_mag;
[m, n] = size(im1_mag_nms);
for i = 2 : m - 1
	for j = 2 : n -1
		if im1_ang_rou(i, j) == 90
			if (im1_mag(i, j) < im1_mag(i + 1, j) || im1_mag(i, j) < im1_mag(i - 1, j))
				im1_mag_nms(i, j) = 0;
			end
		elseif im1_ang_rou(i, j) == 0
			if (im1_mag(i, j) < im1_mag(i, j + 1) || im1_mag(i, j) < im1_mag(i, j - 1))
				im1_mag_nms(i, j) = 0;
			end
        elseif im1_ang_rou(i, j) == 45
			if (im1_mag(i, j) < im1_mag(i + 1, j - 1) || im1_mag(i, j) < im1_mag(i - 1, j + 1))
				im1_mag_nms(i, j) = 0;
			end
		elseif im1_ang_rou(i, j) == 135
			if (im1_mag(i, j) < im1_mag(i + 1, j + 1) || im1_mag(i, j) < im1_mag(i - 1, j - 1))
				im1_mag_nms(i, j) = 0;
			end
		end
	end
end

imshow(uint8(im1_mag_nms));
pause

%
%% (d) Hysteresis Thresholding
%
clf;
im1_max = max(max(im1_mag_nms));
im1_edge = im1_mag_nms;
[m, n] = size(im1_edge);
% thr_high = im1_max * 0.2;
% thr_low = im1_max * 0.06;
% im1_edge(im1_mag_nms < thr_low) = 0;
% im1_edge(im1_mag_nms > thr_high) = 1;

index = 0;
for h = 0.1 : 0.1 : 0.3
    for l = 0.02 : 0.02 : 0.08
        thr_high = im1_max * h;
        thr_low = im1_max * l;
        im1_edge(im1_mag_nms < thr_low) = 0;
        im1_edge(im1_mag_nms > thr_high) = 1;
        for i = 3 : m - 2
            for j = 3 : n - 2
                if im1_mag_nms(i, j) >= thr_low && im1_mag_nms(i, j) <= thr_high
                    im1_edge(i, j) = 0;
                    sum3_high = sum(sum(im1_mag_nms(i - 1:i + 1, j - 1:j + 1) > thr_high));
                    if sum3_high >= 1
                        im1_edge(i, j) = 1;
                    else
                        sum3_low = sum(sum(im1_mag_nms(i - 1:i + 1, j - 1:j + 1) >= thr_low));
                        if sum3_low >= 1
                            sum5_high = sum(sum(im1_mag_nms(i - 2:i + 2, j - 2:j + 2) > thr_high));
                            if sum5_high >= 1
                                im1_edge(i, j) = 1;
                            end
                        end
                    end
                end
            end
        end
        index = index + 1;
        subplot (3, 4, index);
        imshow(im1_edge); 
        title(['High = ', num2str(h), ', Low = ', num2str(l)]);
    end
end

pause

%
%% Grad Credits: Hybrid Images
%
clf;
hybridimg('cat.jpg', 'dog.jpg', 'cat_dog.jpg');
im2_ori1 = imread('cat.jpg');
im2_ori2 = imread('dog.jpg');
im2_hyb1 = imread('cat_dog.jpg');
subplot 131; imshow(im2_ori1); 
subplot 132; imshow(im2_ori2); 
subplot 133; imshow(im2_hyb1); 
pause

clf;
hybridimg('surprise.jpg', 'happy.jpg', 'surprise_happy.jpg');
im3_ori1 = imread('surprise.jpg');
im3_ori2 = imread('happy.jpg');
im3_hyb1 = imread('surprise_happy.jpg');
subplot 131; imshow(im3_ori1); 
subplot 132; imshow(im3_ori2); 
subplot 133; imshow(im3_hyb1); 
pause
%
%% D

