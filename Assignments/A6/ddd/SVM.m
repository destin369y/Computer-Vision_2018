%COMP 546
%Assignment 6: Image Classification
%Chengyin Liu, cl93

%%%%%%%%%%%%%%
%3. Grad Credits: Support Vector Machines for Image Classification
run('D:\course\Rice\COMP546\matlab\vlfeat-0.9.21\toolbox\vl_setup');

fprintf('feature');
trainPath = 'D:\course\Rice\COMP546\Assignment Files\A6\Assignment06_data\Assignment06_data_reduced\TrainingDataset';
trainDataset = dir(trainPath);
trainClass = trainDataset(3 : end);
classNum = length(trainClass);
%trainImage = struct;
trainSet = imageSet(trainPath, 'recursive');
trainFeature = bagOfFeatures(trainSet);
feature = [];
label = [];
for i = 1 : classNum
    trainImageData = imageDatastore(fullfile(trainPath, trainClass(i).name), 'LabelSource', 'foldernames');
    trainImageRead = cellfun(@imread, trainImageData.Files, 'UniformOutput', false);
    trainImageNum = length(trainImageRead);
    %trainImageSift = cell(trainImageNum, 1);
    for j = 1 : trainImageNum
        trainImageFeature = encode(trainFeature, trainImageRead{j});
        feature = [feature; trainImageFeature];
        label = [label; i];
    end
    %trainImage.(matlab.lang.makeValidName(trainClass(i).name)) = trainImageSift;
end

fprintf('svm');
temSVM = templateSVM('KernelFunction', 'rbf');
modSVM = fitcecoc(feature, label, 'Learners', temSVM);

fprintf('predict')
testPath = 'D:\course\Rice\COMP546\Assignment Files\A6\Assignment06_data\Assignment06_data_reduced\TestDataset_';
testDatasetNum = classNum;
testResult = zeros(testDatasetNum);
for i = 1 : testDatasetNum
	testImageData = imageDatastore(fullfile([testPath, num2str(i)]), 'LabelSource', 'foldernames');
	testImageRead = cellfun(@imread, testImageData.Files, 'UniformOutput', false);
    testImageNum = length(testImageRead);
	for j = 1 : testImageNum
        testImageFeature = encode(trainFeature, testImageRead{j});
		[pre, ~] = predict(modSVM, testImageFeature);
		testResult(i, pre) = testResult(i, pre) + 1;
    end	
end

