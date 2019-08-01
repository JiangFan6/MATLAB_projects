%parameter
%Usage: 
% [Eim, Oim, Aim] =  spatialgabor(im, wavelength, angle, kx, ky, showfilter)
% im :???????????????????????????????
% wavelength:????????????Gabor???
% angle?????????????0???????????????
% kx?????
% ky?????????????kx,ky?????0.5?0.5?
% showfilter??????0/1?????1??????????????????0???????
img = imread('andy.jpg');
figure;

 
%?????????????
grayimg = rgb2gray(img);
subplot(121);
imshow(grayimg);
title('gray original image');
gim = im2double(grayimg);
 
[Eim,Oim,Aim] = spatialgabor(gim,3.5,90,0.5,0.5,1);%spatialgabor(im, wavelength, angle, kx, ky, showfilter)
subplot(122);
imshow(Aim);
Aimsize = size(Aim);%???????????
title('Gabor filted image');
