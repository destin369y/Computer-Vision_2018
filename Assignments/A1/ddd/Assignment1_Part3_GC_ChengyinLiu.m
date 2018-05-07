clear all
home

%%
%COMP 546
%Assignment 1: Filtering and Smoothing
%Grad credits: Edge preserving smoothing

%% 
%Denoise ¡®camera_man_noisy.png¡¯ using bilateral filter. 
im3 = double(imread('camera_man_noisy.png'))/255;

%The bilateral filter has three variables: 
%1) spatial standard deviation 
%2) intensity standard deviation
%3) size. 
%Find the best parameters that work for you and report them along with the denoised image. 

%parameters test
%1.bilateral filter half-width
sigma0 = 3;
sigma1 = 0.1;
for i = 1:9
    w = i;
    sigma = [sigma0, sigma1];
    bflt_im3 = bfilter2(im3, w, sigma);
    subplot(3,9,i); imagesc(bflt_im3); 
    colormap gray;
    title(['w = ', num2str(w)]);
end

%2.spatial standard deviation 
w = 5;
sigma1 = 0.1;
for i = 1:9
    sigma0 = i;
    sigma = [sigma0, sigma1];
    bflt_im3 = bfilter2(im3, w, sigma);
    subplot(3,9,i + 9); imagesc(bflt_im3);
    colormap gray;
    title(['sigma0 = ', num2str(sigma0)]);
end

%3.intensity standard deviation
w = 5;
sigma0 = 3;
for i = 1:9
    sigma1 = i / 10.0;
    sigma = [sigma0, sigma1];
    bflt_im3 = bfilter2(im3, w, sigma);
    subplot(3,9,i + 18); imagesc(bflt_im3);
    colormap gray;
    title(['sigma1 = ', num2str(sigma1)]);
end
pause;

%Compare the denoised image from bilateral filter with the one from the best Gaussian filter.
w = 5; % bilateral filter half-width
sigma = [3 0.3]; % bilateral filter standard deviations
bflt_im3 = bfilter2(im3, w, sigma);
figure(1); 
clf;
set(gcf, 'Name', 'Grayscale Bilateral Filtering Results');
subplot 131; imagesc(im3); 
colormap gray;
title('Input Image');
subplot 132; imagesc(bflt_im3);
colormap gray;
title('Result of Bilateral Filtering');
g3fGau2 = imgaussfilt(im3, 2, 'Padding', 'symmetric');
subplot 133, imagesc(g3fGau2);
colormap gray;
title('Filter result of Gaussian filter');
pause;


clf;
home;

