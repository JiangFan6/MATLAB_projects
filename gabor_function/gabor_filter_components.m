%????Gabor????????????
clear;
x = 0;
theta = 0;
f0 = 0.2;
for i = linspace(-15,15,50)
    x = x + 1;
    y = 0;
    for j = linspace(-15,15,50)
        y = y + 1;
        z(y,x)=compute(i,j,f0,theta);
    end
end
x = linspace(-15,15,50);
y = linspace(-15,15,50);
surf(x,y,real(z))
title('Gabor filter:real component');
xlabel('x');
ylabel('y');
zlabel('z');
figure(2);
surf(x,y,imag(z))
title('Gabor filter:imaginary component');
xlabel('x');
ylabel('y');
zlabel('z');

Z = fft2(z);
u = linspace(-0.5,0.5,50);
v = linspace(-0.5,0.5,50);
figure(3);
surf(u,v,abs(fftshift(Z)))
title('Gabor filter:frequency component');
xlabel('u');
ylabel('v');
zlabel('Z');