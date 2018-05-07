function N = Normal(imGray, mask, L)
    [imNum, imDim] = size(L);
    [m, n] = size(mask);
    N = zeros(m, n, imDim);

    for i = 1:m
        for j = 1:n
            if mask(i, j)
                I = reshape(imGray(i, j, :), [imNum, 1]);
                g = (L.'*L)\(L.'*I);
                if norm(g) ~= 0
                    g = g/norm(g);
                else
                    g = [0; 0; 0];
                end
                N(i, j, :) = g;
            end
        end
    end

end