clear all
home

%%
%COMP 546
%Assignment 1: Filtering and Smoothing
%Part II

%% Filtering
%%
% Filter the following matrices I1 and I2 without using built-in MATLAB functions.
I1 = [  120 110 90 115 40;
        145 135 135 65 35;
        125 115 55 35 25;
        80 45 45 20 15;
        40 35 25 10 10 ]
I2 = [  125 130 135 110 125;
        145 135 135 155 125;
        65 60 55 45 40;
        40 35 40 25 15;
        15 15 20 15 10 ]
%Assumption: for boundary condition handling, we use the symmetric option,
%which will extend the boundaries by mirroring itself.
%Using:
% 1.
f1 = fspecial('average', [1, 3]);
I1f1 = imfilter(I1, f1, 'symmetric')
I2f1 = imfilter(I2, f1, 'symmetric')
% 2.
f2 = fspecial('average', [3, 1]);
I1f2 = imfilter(I1, f2, 'symmetric')
I2f2 = imfilter(I2, f2, 'symmetric')
% 3.
f3 = fspecial('average', [3, 3]);
I1f3 = imfilter(I1, f3, 'symmetric')
I2f3 = imfilter(I2, f3, 'symmetric')
pause

%%
% Apply following filters on the gray scale image of barbara from Part I.
im1 = imread('barbara.jpg'); 
grIm1 = rgb2gray(im1);
imshow(grIm1)
pause

% 1. Central difference Gradient filter
fCenDif_x = [-1 0 1];
fCenDif_y = [-1; 0; 1];
g1fCenDif_x = imfilter(grIm1, fCenDif_x, 'symmetric');
g1fCenDif_y = imfilter(grIm1, fCenDif_y, 'symmetric');
g1fCenDif_mag = sqrt(double(g1fCenDif_x.^2 + g1fCenDif_y.^2));
g1fCenDif_mag = uint8(g1fCenDif_mag);
clf;
subplot 131, imshow(g1fCenDif_x); title('emphasizes vertical edges')
subplot 132, imshow(g1fCenDif_y); title('emphasizes horizontal edges')
subplot 133, imshow(g1fCenDif_mag); title('Gradient magnitude')
pause

% 2. Sobel filter
fSobel_y = fspecial('sobel');
fSobel_x = fSobel_y';
g1fSobel_x = imfilter(grIm1, fSobel_x, 'symmetric');
g1fSobel_y = imfilter(grIm1, fSobel_y, 'symmetric');
g1fSobel_mag = sqrt(double(g1fSobel_x.^2 + g1fSobel_y.^2));
g1fSobel_mag = uint8(g1fSobel_mag);
clf;
subplot 131, imshow(g1fSobel_x); title('emphasizes vertical edges')
subplot 132, imshow(g1fSobel_y); title('emphasizes horizontal edges')
subplot 133, imshow(g1fSobel_mag); title('Gradient magnitude')
pause

% 3. Mean filter
fMean = fspecial('average', [3 3]);
g1fMean = imfilter(grIm1, fMean, 'symmetric');
clf;
imshow(g1fMean)
pause

% 4. Median filter
g1fMedian = medfilt2(grIm1, [3 3], 'symmetric');
clf;
imshow(g1fMedian)
pause

% Note: You can use fspecial, imfilter functions in Matlab to accomplish the above
% and below tasks. Do not use imgradient.


%% Smoothing
%%
% Read the image ¡®camera_man_noisy.png¡¯ and filter using following filters:
im2 = imread('camera_man_noisy.png'); 
size(im2)
imshow(im2)
pause

% 1. Averaging filters of sizes 2 ¡Á 2; 4 ¡Á 4; 8 ¡Á 8; 16 ¡Á 16.
fAve2 = fspecial('average', [2, 2]);
g2fAve2 = imfilter(im2, fAve2, 'symmetric');
fAve4 = fspecial('average', [4, 4]);
g2fAve4 = imfilter(im2, fAve4, 'symmetric');
fAve8 = fspecial('average', [8, 8]);
g2fAve8 = imfilter(im2, fAve8, 'symmetric');
fAve16 = fspecial('average', [16, 16]);
g2fAve16 = imfilter(im2, fAve16, 'symmetric');
clf;
subplot 141, imshow(g2fAve2); title('Filter result of sizes 2 ¡Á 2')
subplot 142, imshow(g2fAve4); title('Filter result of sizes 4 ¡Á 4')
subplot 143, imshow(g2fAve8); title('Filter result of sizes 8 ¡Á 8')
subplot 144, imshow(g2fAve16); title('Filter result of sizes 16 ¡Á 16')
pause

% 2. Gaussian filter of standard deviations 2, 4, 8, 16 
%(A good choice of gaussian filter size is 4 times its standard deviation, 
%in order to include most of the variability within the box).
g2fGau2 = imgaussfilt(im2, 2, 'Padding', 'symmetric');
g2fGau4 = imgaussfilt(im2, 4, 'Padding', 'symmetric');
g2fGau8 = imgaussfilt(im2, 8, 'Padding', 'symmetric');
g2fGau16 = imgaussfilt(im2, 16, 'Padding', 'symmetric');
clf;
subplot 141, imshow(g2fGau2); title('Filter result of sigma 2')
subplot 142, imshow(g2fGau4); title('Filter result of sigma 4')
subplot 143, imshow(g2fGau8); title('Filter result of sigma 8')
subplot 144, imshow(g2fGau16); title('Filter result of sigma 16')
pause


clf;
home;

