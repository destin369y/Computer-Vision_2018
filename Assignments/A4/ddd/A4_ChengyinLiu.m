%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comp546
% Assignment4
% Chengyin Liu, cl93
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

echo off
clear all
home
echo on

%% Implementation
cb = imread('chessboard.jpg');
epsilon = 0.03;
sigma = 3;
threshold = 100;
HarrisCornerDetector(cb, epsilon, sigma, threshold);

%% Rotation and Scaling
%% 1 Rotate the chessboard image by 30 deg and apply your function.
clf;
cbRotate = imrotate(cb, 30);
cbRotate(cbRotate == 0) = 255;
HarrisCornerDetector(cbRotate, 0.03, 6, 160);

%% 2 Resize the chessboard image by 4 times on both axes and apply your function. 
clf;
cbResize = imresize(cb, 4);
HarrisCornerDetector(cbResize, 0.03, 9, 20);




