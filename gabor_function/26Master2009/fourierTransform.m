% I =imread('KA.AN1.39.tiff');
I =imread('andy_face.tiff');
subplot(1,2,1);
imshow(I);

I=im2double(I);         % ?????double???????????????0,255?????0,1? -????????????
F=fft2(I);              % ???????
F=fftshift(F);          % ???????????????
F=abs(F);               % ????????????????????????????abs???? - ??????????????
T=log(F+1);             % ?????????????????????????????????????????????
%figure;                 % ????     
subplot(1,2,2);
imshow(T,[]);           % imshow?????0~1??????????????????????1?????[]?????1????????0~1??????
