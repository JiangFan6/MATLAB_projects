%函数功能：核函数计算
% 输入
% x		:输入向量
% kernel 	: 核函数
%  kerneloption	: kerneloption是给定多项式次数的标量，包含内核选项的标量或向量
% 'gaussian' : 标量伽玛对于所有坐标都是相同的
% 'poly' : 多项式
% xsup		: 支持向量
%   framematrix  :框架内核的框架元素
%   vector       :帧元素采样位置
%	 dual 		  :双框架

function [K,option]=svmkernel(x,kernel,kerneloption,xsup,framematrix,vector,dual)

if nargin < 6
    vector=[];
    dual=[];
end;
if nargin <5
    frame=[];
end;

if nargin<4
    xsup=x;
end;
if nargin<3
    kerneloption=1;
end;
if nargin<2
    kernel='gaussian';
end;
if isempty(xsup)
    xsup=x;
end;
[n1 n2]=size(x);
[n n3]=size(xsup);
ps  =  zeros(n1,n);			% produit scalaire
switch lower(kernel)
case 'poly'
    
    [nk,nk2]=size(kerneloption);   
    if nk>nk2
        kerneloption=kerneloption';
        nk2=nk;
    end;
    if nk2==1
        degree=kerneloption;
        var=ones(1,n2);
        
    elseif nk2 ==2
        degree=kerneloption(1);
        var=ones(1,n2)*kerneloption(2);
        
    elseif nk2== n2+1
        degree=kerneloption(1);
        var=kerneloption(2:n2+1);
        
    elseif nk2 ==n2+2
        degree=kerneloption(1);
        var=kerneloption(2:n2+1);
    end;

    if nk2==1
        aux=1;
    else
        aux=repmat(var,n,1);
    end;
  
    ps= x *(xsup.*aux.^2)';

    if degree > 1
        K =(ps+1).^degree;
    else
        K=ps;
    end;
case 'polyhomog'
    
    [nk,nk2]=size(kerneloption);   
    if nk>nk2
        kerneloption=kerneloption';
        nk2=nk;
    end;
    if nk2==1
        degree=kerneloption;
        var=ones(1,n2);
    else
        if nk2 ~=n2+1
            degree=kerneloption(1);
            var=ones(1,n2)*kerneloption(2);
        else
            degree=kerneloption(1);
            var=kerneloption(2:nk2);
        end;
    end;
    
    
    aux=repmat(var,n,1);
    ps= x *(xsup.*aux.^2)';
    K =(ps).^degree;
    
    
case 'gaussian'
    [nk,nk2]=size(kerneloption);
    if nk ~=nk2
        if nk>nk2
            kerneloption=kerneloption';
        end;
    else
        kerneloption=ones(1,n2)*kerneloption;
    end;
    
    if length(kerneloption)~=n2 & length(kerneloption)~=n2+1 
        error('Number of kerneloption is not compatible with data...');
    end;
    
    
    metric = diag(1./kerneloption.^2);
    ps = x*metric*xsup'; 
    [nps,pps]=size(ps);
    normx = sum(x.^2*metric,2);
    normxsup = sum(xsup.^2*metric,2);
    ps = -2*ps + repmat(normx,1,pps) + repmat(normxsup',nps,1) ; 
    
    
    K = exp(-ps/2);
    
case 'htrbf'    % heavy tailed RBF  %see Chappelle Paper%
    b=kerneloption(2);
    a=kerneloption(1);
    for i=1:n
        ps(:,i) = sum( abs((x.^a - ones(n1,1)*xsup(i,:).^a)).^b   ,2);
    end;
    
    
    K = exp(-ps);
    
case 'gaussianslow'    %
    %b=kerneloption(2);
    %a=kerneloption(1);
    for i=1:n
        ps(:,i) = sum( abs((x - ones(n1,1)*xsup(i,:))).^2 ,2)./kerneloption.^2/2;
    end;
    
    
    K = exp(-ps);
case 'multiquadric'
    metric = diag(1./kerneloption);
    ps = x*metric*xsup'; 
    [nps,pps]=size(ps);
    normx = sum(x.^2*metric,2);
    normxsup = sum(xsup.^2*metric,2);
    ps = -2*ps + repmat(normx,1,pps) + repmat(normxsup',nps,1) ; 
    K=sqrt(ps + 0.1);
case 'wavelet'
    K=kernelwavelet(x,kerneloption,xsup);     
case 'frame'
    K=kernelframe(x,kerneloption,xsup,framematrix,vector,dual);
case 'wavelet2d'
    K=wav2dkernelint(x,xsup,kerneloption);
case 'radialwavelet2d'
    K=radialwavkernel(x,xsup);    
case 'tensorwavkernel'
    [K,option]=tensorwavkernel(x,xsup,kerneloption);  

case 'numerical'
    K=kerneloption.matrix;
case 'polymetric'
    K=x*kerneloption.metric*xsup';
    
case 'jcb'
    K=x*xsup';
    
end;



