% Version : 1.0
% Date : 12.26.2010
% Author  : Omid Sakhi
% http://www.facedetectioncode.com

function IMVECTOR = im2vec (W27x18)

load gabor;
W27x18 = adapthisteq(W27x18,'Numtiles',[8 3]);
Features135x144 = cell(5,8);
for s = 1:5
    for j = 1:8
        Features135x144{s,j} = abs(ifft2(G{s,j}.*fft2(double(W27x18),32,32),27,18));
    end
end
Features45x48 = cell2mat(Features135x144);
IMVECTOR = reshape (Features45x48,[19440 1]);