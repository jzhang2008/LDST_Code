function [x s]=Local_Cal_L1L1_min(Dic,y,xest,param)
%函数说明：
%   求解问题  0.5*||y-D*x-s||^2+lambda1*||x||_1+lambda3*||s||_1+mu/2*||s||^2
%                s.t.  x>=0
% input arguments:
%
% output arguments:
%==========================================================================
%  Initialization
if ~isfield(param,'lambda1')
    param.lambda1=0.01;
end
if ~isfield(param,'lambda2')
    param.lambda2=0.01;
end
if ~isfield(param,'Lip')
    param.Lip=18;
end
if ~isfield(param,'mu')
    param.mu=5;
end
if ~isfield(param,'MAX_ITER')
    param.MAX_ITER=500;
end
if ~isfield(param,'RELTOL')
    param.RELTOL  = 1e-4;
end
if ~isfield(param,'rho')
    param.rho  = 1;
end
beta=10;
[RowDim ColDim,patch_num]=size(Dic);
A=zeros(ColDim,ColDim,patch_num);
b=zeros(ColDim,patch_num);
for i=1:patch_num
    A(:,:,i)=Dic(:,:,i)'*Dic(:,:,i);
    b(:,i)  =Dic(:,:,i)'*y(:,i);
end
xPrev = zeros(ColDim,patch_num);
x     = zeros(ColDim,patch_num);
vPrev = zeros(ColDim,patch_num);
v     = zeros(ColDim,patch_num);
zPrev = zeros(ColDim,patch_num);
z     = zeros(ColDim,patch_num);
tem_y = zeros(ColDim,patch_num);
tem_z = zeros(ColDim,patch_num);
tem_v = zeros(ColDim,patch_num);
lambda= zeros(ColDim,patch_num);
tPrev = 1;
t = 1;
sPrev =zeros(RowDim,patch_num);
s     =zeros(RowDim,patch_num);
tem_s =zeros(RowDim,patch_num);
Obj_old =0;
for k=1:param.MAX_ITER
    tem_t = (tPrev-1)/t;
    for ik=1:patch_num
        tem_y(:,ik) = (1+tem_t)*x(:,ik) - tem_t*xPrev(:,ik);
        tem_s(:,ik) = (1+tem_t)*s(:,ik) - tem_t*sPrev(:,ik);
        tem_v(:,ik) = (1+tem_t)*v(:,ik) - tem_t*vPrev(:,ik);
        tem_z(:,ik) = (1+tem_t)*z(:,ik) - tem_t*zPrev(:,ik);
        tem_y(:,ik) =tem_y(:,ik)-(A(:,:,ik)*tem_y(:,ik)-b(:,ik)-Dic(:,:,ik)'*tem_s(:,ik)+lambda(:,ik)+beta*(tem_y(:,ik)-tem_z(:,ik))+param.rho*(tem_y(:,ik)-xest(:,ik)-tem_v(:,ik)))/param.Lip;
    end
    xPrev = x;
    x     =max(tem_y,0);
    zPrev =z;
    tem_z =tem_z-(-lambda+beta*(tem_z-x))/param.Lip;
    z     =L12(tem_z,param.lambda1/param.Lip);
    sPrev =s;
    for ik=1:patch_num
        tem_s(:,ik) =tem_s(:,ik)-(tem_s(:,ik)-(Dic(:,:,ik)*x(:,ik)-y(:,ik)))/param.Lip;
    end
    s     =softthres(tem_s,param.lambda3/param.Lip);
    vPrev =v;
    for ik=1:patch_num
        tem_v(:,ik) =tem_v(:,ik)-param.rho*(tem_v(:,ik)-x(:,ik)+xest(:,ik))/param.Lip;
    end
    v     =L12(tem_v,param.lambda2/param.Lip);
    tPrev = t;
    t     = (1+sqrt(1+4*t^2))/2;
    Dis   =0;
    for  ik=1:patch_num
        Dis=Dis+sum((Dic(:,:,ik)*x(:,ik)-y(:,ik)-s(:,ik)).^2);%sum(sum(abs(x)))
    end
    Obj   =0.5*Dis+param.lambda1*sum(sqrt(sum(z.*z,2)))+param.lambda3*sum(sum(abs(s)))+...
        param.lambda2*sum(sqrt(sum(v.*v,2)))+param.rho/2*norm(x-xest-v,'fro')^2-trace(lambda'*(z-x))+beta/2*norm(z-x,'fro')^2;
    if abs(Obj-Obj_old)<param.RELTOL
        break;
    end
    Obj_old=Obj;
    lambda=lambda-beta*(z-x);
end
end
%% soft thresholding operator
function y = softthres(x,lambda)
y = max(x-lambda,0)-max(-x-lambda,0);
end
% 结构稀疏
function [value]=L12(F,lambda)
dim=size(F,2);
value=max(0,1-lambda./sqrt(sum(F.*F,2)))*ones(1,dim).*F;
end