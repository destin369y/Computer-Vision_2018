clear all
home

%%
%COMP 546
%Assignment 1: Filtering and Smoothing
%Part I
%Exercise 2

%%
%Write a Matlab script to perform the following operations on ¡°barbara.jpg¡±
im1 = imread('barbara.jpg');  
class(im1)
size(im1)
imshow(im1)
axis on;
impixelinfo;
pause

%%
% Convert the image to gray scale.
grIm1 = rgb2gray(im1);
imshow(grIm1)
pause

%%
% Plot a histogram of the gray scale image with bin-size of 5 in intensity.
imhist(grIm1, 255 / 5)
pause

%%
% Blur the gray scale image by using 
%Gaussian filters of size 15 ¡Á 15 with standard deviations 2 and 8.
gaussFilt2 = fspecial('gaussian', 15, 2);
gaussFilt8 = fspecial('gaussian', 15, 8);
subplot 221, surf(gaussFilt2); title('Gaussian, sigma 2')
subplot 222, surf(gaussFilt8); title('Gaussian, sigma 8')
convIm2 = imfilter(grIm1, gaussFilt2, 'symmetric'); 
convIm8 = imfilter(grIm1, gaussFilt8, 'symmetric'); 
subplot 223, imshow(convIm2); title('blurred image(Gaussian, sigma 2)')
subplot 224, imshow(convIm8); title('blurred image(Gaussian, sigma 8)')
pause

%%
% Plot histograms for the blurred images. 
%How do they differ from each other and the original histogram?
subplot 131, imhist(convIm2, 255 / 5); title('Gaussian, sigma 2')
subplot 132, imhist(convIm8, 255 / 5); title('Gaussian, sigma 8')
subplot 133, imhist(grIm1, 255 / 5); title('Original histogram')
pause

%%
%? Subtract the blurred image obtained using the filter with standard deviation of 2 
%from the original gray scale image.
clf;
difIm1 = grIm1 - convIm2;
imshow(difIm1)
pause

%%
%? Threshold the resultant image at 5% of its maximum pixel value.
maxIntensity = max(max(difIm1))
threshold = maxIntensity * 0.05
difIm1_threshold = difIm1;
difIm1_threshold(difIm1_threshold < threshold) = 0;

%%
%? Display the final image.
%What does the final image look like?
imshow(difIm1_threshold)
% subplot 121,imshow(difIm1)
% subplot 122,imshow(difIm1_threshold)

pause;
clf;
home;

