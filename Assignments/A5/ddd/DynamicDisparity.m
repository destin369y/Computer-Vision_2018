function dynamicDis = DynamicDisparity(imLeft, imRight, patchSize)
    [m, n] = size(imLeft);
	dynamicDis = NaN(m, n);
    for row = 1:m
		%disp(row)
		line = zeros(1, n);
		dis = NaN(n);
        for j = 1:n
			pixel = [row, j];
			dis(j, :)= Similarity(imLeft, imRight, pixel, patchSize);
        end
        
        path = zeros(n);
        for j = 2:n
			path(1, j) = path(1, j - 1) + dis(1, j);
			path(j, 1) = path(j - 1, 1) + dis(1, j);
        end
        
        for i = 2:n
            for j = 2:n
				path(i, j) = max([path(i - 1, j), path(i - 1, j - 1), path(i , j - 1)]) + dis(i, j);
            end
        end
        
		col = n;
		line(col) = 0;
		j = n;
        
		while j > 1
			if col == 1
				line(j - 1) = j - 1;
				j = j - 1;
			else
				temp = max([path(j, col - 1), path(j - 1, col), path(j - 1, col - 1)]);
                if temp == path(j, col - 1)
					col = col - 1;
                elseif temp == path(j - 1, col)
					line(j - 1) = j - col + 1;
					j = j - 1;
				else
					line(j - 1) = j - col;
					j = j - 1;
					col = col - 1;
                end
			end
		end
		dynamicDis(row, :) = line; 
    end
end