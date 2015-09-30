function [x s]=Cal_L1L1_min(D,y,x0,param)
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
    param.Lip=8;
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
A=D'*D;
b=D'*y;
ColDim=size(A,1);
xPrev = zeros(ColDim,1);
x = zeros(ColDim,1);
tPrev = 1;
t = 1;
pDim  =size(y,1);
sPrev =zeros(pDim,1);
s     =zeros(pDim,1);
vPrev =zeros(ColDim,1);
v     =zeros(ColDim,1);
Obj_old =0;
for k=1:param.MAX_ITER
    tem_t = (tPrev-1)/t;
    tem_y = (1+tem_t)*x - tem_t*xPrev;
    tem_s = (1+tem_t)*s - tem_t*sPrev;
    tem_v = (1+tem_t)*v - tem_t*vPrev;
    tem_y =tem_y-(A*tem_y-b-D'*tem_s+param.lambda1+param.rho*(tem_y-x0-tem_v))/param.Lip;
    xPrev = x;
    x     =max(tem_y,0);
    sPrev =s;
    tem_s =tem_s-(tem_s-(D*x-y)+param.mu*tem_s)/param.Lip;
    s     =softthres(tem_s,param.lambda3/param.Lip);
    vPrev =v;
    tem_v =tem_v-param.rho*(tem_v-x+x0)/param.Lip;
    v     =softthres(tem_v,param.lambda2/param.Lip);
    tPrev = t;
    t     = (1+sqrt(1+4*t^2))/2;
    Obj   =0.5*sum((D*x-y-s).^2)+param.lambda1*sum(abs(x))+param.lambda3*sum(abs(s))+param.mu/2*sum(s.^2)+...
        param.lambda2*sum(abs(v))+param.rho/2*sum((x-x0-v).^2);
    if abs(Obj-Obj_old)<param.RELTOL
        break;
    end
    Obj_old=Obj;
end
%% soft thresholding operator
function y = softthres(x,lambda)
y = max(x-lambda,0)-max(-x-lambda,0);