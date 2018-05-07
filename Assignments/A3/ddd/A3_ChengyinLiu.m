%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comp546
% Assignment3
% Chengyin Liu, cl93
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

echo off
clear all
home
echo on

%% 1 Understanding RANSAC

%% 1.1. Ransac for Line Fitting
lineData = load('Ransac/LineData.mat');
data1 = [lineData.x; lineData.y];
num = 2;
iter = 1000;
threshDist = 0.5;
inlierRatio = 0.5;
[a, b] = ransac(data1, num, iter, threshDist, inlierRatio);

%Plot the best fitting line
xAxis = lineData.x; 
yAxis = a * xAxis + b;
figure(1);plot(xAxis, yAxis, 'r-', 'LineWidth', 2);

%% 1.2 Ransac for Affine Fitting
I1 = imread('Ransac/castle_original.png');
I2 = imread('Ransac/castle_transformed.png');
affineData = load('Ransac/AffineData.mat.mat');
data2 = [affineData.orig_feature_pt; affineData.trans_feature_pt];

num = 3;
iter = 500;
%threshDist = 5;
%inlierRatio = 0.5;

figure(2);
inlierRatio = 0.5;
i = 1;
for threshDist = [0.5, 1, 5, 10, 20, 50, 100, 200] 
    a = ransacAffine(data2, num, iter, threshDist, inlierRatio);
    tform = maketform('affine', [a(1:3), a(4:6), [0; 0; 1]]);
    Inew = imtransform(I1, tform);
    subplot(2, 4, i); imshow(Inew); title(['t=', num2str(threshDist)]);
    i = i + 1;
end

figure(3);
threshDist = 5;
j = 1;
for inlierRatio = 0.1:0.1:0.8 
    a = ransacAffine(data2, num, iter, threshDist, inlierRatio);
    tform = maketform('affine', [a(1:3), a(4:6), [0; 0; 1]]);
    Inew = imtransform(I1, tform);
    subplot(2, 4, j); imshow(Inew); title(['ir=', num2str(inlierRatio)]);
    j = j + 1;
end

figure(4);
inlierRatio = 0.5;
threshDist = 5;
a = ransacAffine(data2, num, iter, threshDist, inlierRatio);
tform = maketform('affine', [a(1:3), a(4:6), [0; 0; 1]]);
Inew = imtransform(I1, tform);
imshowpair(I2, Inew, 'montage');


%% 2 Distance Transforms and Chamfer Matching

%% 2.1 Distance Transform
cow = imread('DistanceTransform_ChamferMatching/cow.png');
cowEdge = edge(rgb2gray(cow), 'canny');
figure(5); imshow(cowEdge); title('Canny Edge');

%initialization
[m, n] = size(cowEdge);
dis = inf(size(cowEdge));
index = find(cowEdge > 0);
dis(index) = 0;

%forward
%based on top and left
for i = 2 : m
	for j = 2 : n
		dis(i, j) = min(dis(i, j), (min(dis(i - 1, j), dis(i, j - 1)) + 1));
	end
end
%backward
%based on bottom and right
for i = m - 1 : -1 : 1
	for j = n -1 : -1 : 1
		dis(i, j) = min(dis(i, j), (min(dis(i + 1, j), dis(i, j + 1)) + 1));
	end
end
figure(6); imshow(uint8(dis)); title('Distance Transform');

dis1 = bwdist(cowEdge,'euclidean');
dis2 = bwdist(cowEdge,'cityblock');
dis3 = bwdist(cowEdge,'chessboard');
figure(7);
subplot 131; imshow(mat2gray(dis1)); title('Euclidean');
subplot 132; imshow(mat2gray(dis2)); title('City Block');
subplot 133; imshow(mat2gray(dis3)); title('Chessboard');

%% 2.2 Chamfer Matching
template = imread('DistanceTransform_ChamferMatching/template.png');
[mTem, nTem] = size(template);
disMin = inf;

for i = 1 : m - mTem
    for j = 1 : n - nTem
		disCur = sum(sum(dis(i:(i + mTem - 1), j:(j + nTem - 1)) .* template));
        if disCur < disMin
			disMin = disCur;
			ori = [i, j];
        end
    end
end

tem = zeros(size(cow));
oriX = ori(1):(ori(1) + mTem - 1);
oriY = ori(2):(ori(2) + nTem - 1);
tem(oriX, oriY, 1) = template;
tem(oriX, oriY, 2) = template;
tem(oriX, oriY, 3) = template;
cowTem = cow;
cowTem(tem > 0) = 255;

figure(8); imshow(cowTem);

