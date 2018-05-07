%COMP 546
%Assignment 6: Image Classification
%Chengyin Liu, cl93

%%%%%%%%%%%%%%
%1. Bag of Features Classification with SIFT Descriptors
run('D:\course\Rice\COMP546\matlab\vlfeat-0.9.21\toolbox\vl_setup');

fprintf('sift');
trainPath = 'D:\course\Rice\COMP546\Assignment Files\A6\Assignment06_data\Assignment06_data_reduced\TrainingDataset';
trainDataset = dir(trainPath);
trainClass = trainDataset(3 : end);
trainImage = struct;
classNum = length(trainClass);
featureSift = [];
for i = 1 : classNum
    trainImageData = imageDatastore(fullfile(trainPath, trainClass(i).name), 'LabelSource', 'foldernames');
    trainImageRead = cellfun(@imread, trainImageData.Files, 'UniformOutput', false);
    trainImageNum = length(trainImageRead);
    trainImageSift = cell(trainImageNum, 1);
    for j = 1 : trainImageNum
		imgGray = single(rgb2gray(trainImageRead{j}));
		[~, d] = vl_sift(imgGray);
		trainImageSift(j) = {d};
		featureSift = cat(2, featureSift, single(d));
    end
    trainImage.(matlab.lang.makeValidName(trainClass(i).name)) = trainImageSift;
end

fprintf('cluster');
N = 1000;
[C, A] = vl_kmeans(featureSift, N, 'distance', 'l1', 'algorithm', 'elkan');
cluster = cell(2, 1);
cluster(:,1) = {C, A};

fprintf('histogram');
histogram = cell(classNum, 1);
figure;
for i = 1 : classNum
	className = matlab.lang.makeValidName(trainClass(i).name);
	classMat = single(cell2mat(horzcat(trainImage.(className)')));
	[IDX, D] = knnsearch(C', classMat', 'distance', 'cityblock');
	thr = mean(D) * 1.5;
	IDX(D > thr) = [];
    idxNum = length(IDX);
    trainHis = zeros(1, N);
    for idx = 1 : idxNum
	  trainHis(IDX(idx)) = trainHis(IDX(idx)) + 1;
    end
	trainHis = trainHis ./ idxNum;
	histogram(i) = {trainHis};

	subplot(classNum, 1, i);
	plot(trainHis, 'b');
    title(strcat('Class: ', trainClass(i).name));
end

fprintf('predict')
testPath = 'D:\course\Rice\COMP546\Assignment Files\A6\Assignment06_data\Assignment06_data_reduced\TestDataset_';
testDatasetNum = classNum;
testResult = zeros(testDatasetNum);
for i = 1 : testDatasetNum
	testImageData = imageDatastore(fullfile([testPath, num2str(i)]), 'LabelSource', 'foldernames');
	testImageRead = cellfun(@imread, testImageData.Files, 'UniformOutput', false);
    testImageNum = length(testImageRead);
	for j = 1 : testImageNum
		testImageGray = single(rgb2gray(testImageRead{j}));
		[~, d] = vl_sift(testImageGray);
		[IDX, D] = knnsearch(C', single(d)', 'distance', 'cityblock');
		thr = mean(D) * 1.5;
		IDX(D > thr) = [];
		testHis = zeros(1, N);
        idxNum = length(IDX);
		for idx = 1 : idxNum
			testHis(IDX(idx)) = testHis(IDX(idx)) + 1;
        end
		testHis = testHis ./ idxNum;
		predict = knnsearch(cell2mat(vertcat(histogram)), testHis, 'NSMethod', 'kdtree');
		testResult(i, predict) = testResult(i, predict) + 1;
    end	
end
figure;
plot(testHis, 'b');
title('Test image histogram');
testResult = testResult ./ repmat(sum(testResult, 2), 1, classNum)



