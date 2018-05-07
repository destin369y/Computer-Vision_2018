function dis = Disparity(imLeft, imRight, patchSize, threshold)
	[m, n] = size(imLeft);
	dis = NaN(m, n);
	for i = 1 : m
		%disp(i)
		for j = 1 : n
			top = max(i - patchSize/2, 1);
			bot = min(i + patchSize/2, m);
			left = max(j - patchSize/2, 1);
			right = min(j + patchSize/2, n);

			patch = imLeft(top:bot, left:right);
			corr = normxcorr2(patch, imRight(top : bot, :));
			corrMax = max(corr(:));
			[ypeak, xpeak] = find(corr == corrMax);
			if corrMax > threshold
				distance = j - patchSize/2 - xpeak;
				if (distance > 0) || (abs(distance) > n / 6)
					distance = NaN;
				end
				dis(i, j) = abs(distance + patchSize);
			end
		end
	end
end
