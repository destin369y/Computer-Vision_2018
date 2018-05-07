%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comp546
% Assignment5
% Chengyin Liu, cl93
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

%% 1 Depth from Binocular Stereo
%% 1.1 Solving Correspondence
imLeft = imread('BinocularStereo/tsukuba_l.ppm');
imRight = imread('BinocularStereo/tsukuba_r.ppm');
imLeftDouble = double(rgb2gray(imLeft));
imRightDouble = double(rgb2gray(imRight));

patchSize = 30;
p1 = [136, 83]; p(1, :) = p1;
p2 = [203, 304]; p(2, :) = p2;
p3 = [182, 119]; p(3, :) = p3;
p4 = [186, 160]; p(4, :) = p4;
p5 = [123, 224]; p(5, :) = p5;
p6 = [153, 338]; p(6, :) = p6;

%similarity
[m, n] = size(imLeftDouble);
figure(1);
for i = 1:1:6
    sim = Similarity(imLeftDouble, imRightDouble, p(i, :), patchSize);
    x = 0 - p(i, 2) : n  - p(i, 2) - 1;
    subplot(2, 3, i); 
    plot(x, sim); 
    title(['p', num2str(i)]);
end

%disparity
threshold = 0.6;
dis = Disparity(imLeftDouble, imRightDouble, patchSize, threshold);
figure(2);
%heatmap(dis);
colormap('gray');
imagesc(dis);
colorbar;
title('Disparity Map');

%interpolation
[X, Y] = meshgrid(1:n, 1:m);
Xp = X(:);
Yp = Y(:);
Zp = dis(:);
Xp(isnan(dis(:)))=[];
Yp(isnan(dis(:)))=[];
Zp(isnan(dis(:)))=[];
disInter = griddata(Xp, Yp, Zp, X, Y);
figure(3);
%heatmap(disInter);
colormap('gray');
imagesc(disInter);
colorbar;
title('Disparity Map after Interpolation');

%% 1.2 Scanline stereo
dynamicDis = DynamicDisparity(imLeftDouble, imRightDouble, patchSize);
figure(4);
colormap('gray');
imagesc(dynamicDis);
caxis([0,34]);
colorbar;
title('Disparity Map by Dynamic Programming');


%% Grad Credits: Photometric Stereo for Lambertian object
close all;
clc;

load('PhotometricStereo\Code\lighting.mat');
[imNum, imDim] = size(L);
imCategory = 'buddha';
imDirectory = ['PhotometricStereo\psmImages\', imCategory, '\'];

[imSet, imGray, mask] = LoadImages(imCategory, imDirectory, imNum);
[N, A, D] = PhotometricStereo(imSet, imGray, mask, L);

figure(2);
ARed = A(:, :, 1);
AGreen = A(:, :, 2);
ABlue = A(:, :, 3);
subplot 131, imshow(ARed);
subplot 132, imshow(AGreen);
subplot 133, imshow(ABlue);

figure(3);
[m, n, d] = size(N);
p = N(:, :, 1) ./ N(:, :, 3);
q = N(:, :, 2) ./ N(:, :, 3);
quiver(1:5:n, 1:5:m, p(1:5:end, 1:5:end), q(1:5:end, 1:5:end), 5);
axis ij;

figure(4); 
surfl(-D);
shading interp; colormap gray; axis tight;

figure(5)
depth = refineDepthMap(N, mask);
surfl(depth); shading interp; colormap gray; axis tight;



