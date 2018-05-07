function [N, A, D] = PhotometricStereo(imSet, imGray, mask, L)
    N = Normal(imGray, mask, L);
    A = Albedo(imSet, mask, L, N);
    D = Depth(N, mask);
end
