%COMP 546
%Assignment 6: Image Classification
%Chengyin Liu, cl93

%%%%%%%%%%%%%%
%2. Can you fix it? Yes you can!
run('D:\course\Rice\COMP546\matlab\vlfeat-0.9.21\toolbox\vl_setup');

fprintf('sift');
trainPath = 'D:\course\Rice\COMP546\Assignment Files\A6\Assignment06_data\Assignment06_data_expanded\TrainingDataset';
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
        [~, ~, trainImageChannel] = size(trainImageRead{j});
        if trainImageChannel == 3
            trainImageGray = single(rgb2gray(trainImageRead{j}));
        else
            trainImageGray = single(trainImageRead{j});
        end
		[~, d] = vl_sift(trainImageGray);
		trainImageSift(j) = {d};
		featureSift = cat(2, featureSift, single(d));
    end
    trainImage.(matlab.lang.makeValidName(trainClass(i).name)) = trainImageSift;
end

fprintf('cluster');
N = 3000;
treeDepth = 6;
[TREE, ASGN] = vl_hikmeans(uint8(featureSift), treeDepth, N);

fprintf('histogram');
histogram = cell(classNum, 1);
noise = 150;
for i = 1 : classNum
	className = matlab.lang.makeValidName(trainClass(i).name);
    classMat = uint8(cell2mat(horzcat(trainImage.(className)')));
    trainTreePath = vl_hikmeanspush(TREE, classMat);
    trainH = vl_hikmeanshist(TREE, trainTreePath)';
    trainH = trainH(noise : end);
    trainHis = trainH / mean(trainH);
    histogram(i) = {trainHis};
end
figure;
plot(trainHis, 'b');
title(strcat('Class: ', trainClass(classNum).name));

fprintf('predict')
testPath = 'D:\course\Rice\COMP546\Assignment Files\A6\Assignment06_data\Assignment06_data_expanded\TestDataset_';
testDatasetNum = classNum;
testResult = zeros(testDatasetNum);
for i = 1 : testDatasetNum
	testImageData = imageDatastore(fullfile([testPath, num2str(i)]), 'LabelSource', 'foldernames');
	testImageRead = cellfun(@imread, testImageData.Files, 'UniformOutput', false);
    testImageNum = length(testImageRead);
	for j = 1 : testImageNum
        [~, ~, testImageChannel] = size(testImageRead{j});
        if testImageChannel == 3
            testImageGray = single(rgb2gray(testImageRead{j}));
        else
            testImageGray = single(testImageRead{j});
        end
		[~, d] = vl_sift(testImageGray);
		testTreePath = vl_hikmeanspush(TREE, d);
        testH = vl_hikmeanshist(TREE, testTreePath)';
        testH = testH(noise : end);
        testHis = testH / mean(testH);
		predict = knnsearch(cell2mat(vertcat(histogram)), testHis, 'NSMethod', 'kdtree');
		testResult(i, predict) = testResult(i, predict) + 1;
    end	
end
figure;
plot(testHis, 'b');
title('Test image histogram');
testResult = testResult ./ repmat(sum(testResult, 2), 1, classNum);

testResult = testResult * 100;
testResult = round(testResult, 2);

