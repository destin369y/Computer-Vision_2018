clear all
home

%%
%COMP 546
%Assignment 1: Filtering and Smoothing
%Part I
%Exercise 1

%%
%Download a color image of your favorite Marvel superhero from the Internet 
%and write a Matlab script to perform the following operations on that image
im1 = imread('Doctor-Strange.png'); 
class(im1)
size(im1)
imshow(im1)
axis on
impixelinfo;
pause

%%
%Crop the head of the superhero from the image.
%[x,y] = ginput(2)
x = [266, 392];
y = [64, 229];
im1_head = imcrop(im1, [x(1), y(1), abs(x(1) - x(2)), abs(y(1) - y(2))]);
imshow(im1_head)

%%
%Save the cropped sub-image as a PNG file.
imwrite(im1_head, 'DS_head.png');
pause

%%
%Display the green component of the cropped image.
im1_green = im1_head(:, :, 2);
imshow(im1_green)
pause

%%
%Change the order of the color components to [Green,Red,Blue] 
%for the original image and display the image. {Don't use loops}
t = im1(:, :, 1);
im1(:, :, 1) = im1(:, :, 2);
im1(:, :, 2) = t;
imshow(im1)

pause;
clf;
home;

