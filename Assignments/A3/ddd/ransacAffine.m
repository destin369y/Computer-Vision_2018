%% Affine fitting using the RANSAC algorithm
%https://en.wikipedia.org/wiki/Random_sample_consensus

function a = ransacAffine(data,num,iter,threshDist,inlierRatio)
 % data: a 2xn dataset with #n data points
 % num: the minimum number of points. For line fitting problem, num=2
 % iter: the number of iterations
 % threshDist: the threshold of the distances between points and the fitting line
 % inlierRatio: the threshold of the number of inliers 
 
 %% Plot the data points
 number = size(data,2); % Total number of points
 bestInNum = 0; % Best fitting line with largest number of inliers
 a = zeros(6, 1); % parameters for best fitting line
 for i=1:iter
 %% Randomly select 3 points
     idx = randperm(number,num); sample = data(:,idx);
     A = [sample(1,1), sample(2,1), 1, 0, 0, 0;
         0, 0, 0, sample(1,1), sample(2,1), 1;
         sample(1,2), sample(2,2), 1, 0, 0, 0;
         0, 0, 0, sample(1,2), sample(2,2), 1;
         sample(1,3), sample(2,3), 1, 0, 0, 0;
         0, 0, 0, sample(1,3), sample(2,3), 1];
     b = [sample(3,1); sample(4,1); sample(3,2); sample(4,2); sample(3,3); sample(4,3)];
 %% Compute the distances between all points with the fitting line
     x = pinv(A)*b;
     distance = sqrt((data(1,:)*x(1)+data(2,:)*x(2)+x(3)-data(3,:)).^2+(data(1,:)*x(4)+data(2,:)*x(5)+x(6)-data(4,:)).^2);
 %% Compute the inliers with distances smaller than the threshold
     inlierIdx = find(abs(distance)<=threshDist);
     inlierNum = length(inlierIdx);
 %% Update the number of inliers and fitting model if better model is found     
     if inlierNum >= round(inlierRatio*number) && inlierNum>bestInNum
         bestInNum = inlierNum;
         a = x;
     end
 end
 
 