function A = Albedo(imSet, mask, L, N)
    [imNum, imDim] = size(L);
    [m, n] = size(mask);
    A = zeros(m, n, imDim);
    Ni = zeros(imDim,1);
    Ii = zeros(imNum, 1);
    
    for i = 1:m
        for j = 1:n
            if mask(i, j)
                for k = 1:imDim               
                    Ni(k, 1) = N(i, j, k); 
                end               
                Ji = L * Ni;
                for k = 1:imDim
                    for l = 1:imNum               
                        Ii(l,1) = imSet(i, j, k, l);
                    end
                    A(i, j, k) = (Ii' * Ji) / (Ji' * Ji);          
                end 
            end
        end
    end

    minA = min(min(min(A)));
    maxA = max(max(max(A)));
    A = (A - minA) / (maxA - minA);
end