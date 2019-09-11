clear all;
detector=vision.CascadeObjectDetector('LeftEyeCART');
input_image=imread('KA.AN1.39.tiff');
figure();imshow(input_image);title('ԭͼ');
gauss_image=imgaussfilt(input_image,1);
% figure();imshow(gauss_image);title('gauss_image');  %JF

eyes=step(detector,gauss_image);

size_eyes = size(eyes);%�۾��Ŀ�
hold on;
for i =1:size_eyes(1);2
    eyes_final=eyes(i,1:2);%x,y
    image = imcrop(gauss_image,eyes(i,:));
%    figure();imshow(image);title('imcrop_gauss_image');  %JF
    
    rectangle('Position',eyes(i,:),'edgeColor','b');
 
%     image = rgb2gray(image);  %JF
    image = im2double(image);
    [grad_x,grad_y] = gradient(image);%�����ݶ�
    
    g = grad_x.*grad_x + grad_y.*grad_y;
    g = sqrt(g);%�۾�������ݶ�ͼ
    
    std_g = std(g(:));%�����׼��
    mean_g = mean(g(:));%����ƽ��ֵ
    %��ʵ��һ��ȡ����< mean_g - 0.5*std_g��> mean_g + 0.5*std_g����
    g_1 = g;
    g_1(g_1 < mean_g + 0.5*std_g) = 0;%�ݶ�ͼ��С�ھ�ֵ+0.5*��׼�������Ϊ0
    
    g_2 = g;
    g_2(g_2 > mean_g - 0.5*std_g) = 0;%�ݶ�ͼ�д��ھ�ֵ-0.5��׼�������Ϊ0
    
    g = g_1 + g_2;
    temp_g = g;
    w = 1-image;
    temp_g(temp_g ~= 0) = 1;%��������0������Ϊ1 ���ͼֻ��0��1����ֵ
    grad_x = grad_x.*temp_g;%���ݶ����
    grad_y = grad_y.*temp_g;
    
    size_img = size(image);
    Dx = repmat(1:size_img(2),size_img(1),1);%ÿһ�ж���1-44
    Dy = repmat(transpose(1:size_img(1)),1,size_img(2));%ת��
    C_max = 0;
    X = 0;
    Y = 0;
    %Ϊ�˵ó��۾�������λ��
    for x = 1:size_img(2)
        for y = 1:size_img(1)
            D_x = Dx - x;
            D_y = Dy - y;
            
            D_t = D_x.*D_x + D_y.*D_y;
            E = sqrt(D_t);
            
            D_x = D_x./E;
            D_y = D_y./E;
            
            C_x = D_x.*grad_x;
            C_y = D_y.*grad_y;
            
            
            C = w(y,x)*(C_x + C_y);
            C(C < 0) = 0;
            ind = find(isnan(C));
            C(ind)=0;
            % C(isNaN(C)) = 0;
            
            total_C = sum(sum(C));
            
            if(total_C > C_max)
                C_max = total_C;
                X = x;
                Y = y;
            end
            
        end
    end
    plot(X+eyes_final(1),Y+eyes_final(2),'r+','MarkerSize',10);
    p(i,1)=X+eyes_final(1);
    p(i,2)=Y+eyes_final(2);
end