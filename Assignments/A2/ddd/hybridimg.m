function hybridimg(ImgFile1, ImgFile2, ImgFileOut)
% Hybrid Image Generator
% Usage: hybridimg(<Img1 Filename>, <Img2 Filename>, <ImgOutput Filename>);

    radius = 13;     % Param
                     % GaussianRadius
    I1 = imread(ImgFile1);
    I2 = imread(ImgFile2);
    I1_ = fftshift(fft2(double(I1)));
    I2_ = fftshift(fft2(double(I2)));
    [m n z] = size(I1);
    h = fspecial('gaussian', [m n], radius);
    h = h./max(max(h));
    for colorI = 1:3
        J_(:,:,colorI) = I1_(:,:,colorI).*(1-h) + I2_(:,:,colorI).*h;
    end
    J = uint8(real(ifft2(ifftshift(J_))));
    imwrite(J, ImgFileOut);
end
