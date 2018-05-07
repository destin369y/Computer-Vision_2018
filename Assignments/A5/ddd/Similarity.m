%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Comp546
% Assignment5
% Chengyin Liu, cl93
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sim = Similarity(imLeft, imRight, pixel, patchSize)
	[m, n] = size(imLeft);
	% get the patch position
	top = max(pixel(1) - patchSize / 2, 1);
	bot = min(pixel(1) + patchSize / 2, m);
	left = max(pixel(2) - patchSize / 2, 1);
	right = min(pixel(2) + patchSize / 2, n);

	patch = imLeft(top:bot, left:right);
	xcorr = normxcorr2(patch, imRight(top:bot, :));
	%[ypeak, xpeak] = find(xcorr == max(xcorr(:)));
	sim = xcorr(patchSize + 1, patchSize / 2 + 1:n + patchSize / 2);
end