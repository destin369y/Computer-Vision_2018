function D = Depth(N, mask)
    [m, n] = size(mask);
    D = zeros(m, n);
    p = N(:, :, 1) ./ N(:, :, 3);
    q = N(:, :, 2) ./ N(:, :, 3);
    p(isnan(p)==1) = 0;
    q(isnan(q)==1) = 0;
    
    %D(1, 1) = 0;
    for i = 2:m
        D(i, 1) = D(i - 1, 1) + q(i, 1);
    end
    for i = 1:m
        for j = 2:n
            D(i, j) = D(i, j - 1) + p(i, j);
        end
    end
    for i = 1:m
        for j = 1:n
            if mask(i, j) == 0
                D(i, j) = 0;
            end
        end
    end 
    D(D > 500) = 0;
end

