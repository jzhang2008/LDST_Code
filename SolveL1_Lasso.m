function [z s disNew]=SolveL1_Lasso(A,b,param)
% Description: mexLasso is an efficient implementation of ADMM
% param.mode=1
%       min 0.5*||b-A*x||_2+param.lambda1*||x||_1
% param.mode=2
%       min 0.5*||b-A*x-s||_2+param.lambda1*||x||_1+param.lambda2*||s||_1
% param.mode=0
%       min 0.5*||b-A*x-s||_2+param.lambda1*||x||_1+param.lambda2*||s||_1
%      +param.lambda3*||x-F||_1
       
%--------------------------------------------------------------------------
if ~isfield(param,'mode')
    param.mode=1;
    const=0;
end
if ~isfield(param,'rho')
    param.rho=1;
end
if ~isfield(param,'lambda1')
    param.lambda1=0.01;
end
if ~isfield(param,'lambda3')
    param.lambda3=0.01;
end
if ~isfield(param,'MAX_ITER')
    param.MAX_ITER=500;
end
if ~isfield(param,'RELTOL')
    param.RELTOL  = 1e-4;
end
if param.mode==1
    const=0;
    param.lambda2=0;
end
if param.mode==2
    const=1;
end
%--------------------------------------------------------------------------
[m,n]=size(A);
[L U]=factor(A,param.rho);
   x=zeros(n,1);
   z=zeros(n,1);
   y=zeros(n,1);
   s=zeros(m,1);
   disOld = 0;
   disNew = 0;
   for k=1:param.MAX_ITER
       Atb=A'*(b-s*const);
       q = Atb + param.rho*z - y;    % temporary value
      if( m >= n )    % if skinny
          x = U \ (L \ q);
      else            % if fat
          x = q/param.rho - (A'*(U \ ( L \ (A*q) )))/param.rho^2;
      end
%        z=shrinkage(x+y/param.rho,param.lambda1/param.rho);
       z=max(x+(y+param.lambda1)/param.rho,0);
       y=y+param.rho*(x-z);
       s=shrinkage(b-A*x,param.lambda3);
       disNew=0.5*norm(b-A*x-const*s)^2+param.lambda1*norm(z,1)+param.lambda3*norm(s,1);
       if abs(disNew-disOld)<param.RELTOL
        break;
       end
       disOld=disNew;
   end
end
function z = shrinkage(x, kappa)
    z = max( 0, x - kappa ) - max( 0, -x - kappa );
%     zz=max(0,abs(x)-kappa).*sign(x);
end
function [L U] = factor(A, rho)
    [m, n] = size(A);
    if ( m >= n )    % if skinny
       L = chol( A'*A + rho*speye(n), 'lower' );
    else            % if fat
       L = chol( speye(m) + 1/rho*(A*A'), 'lower' );
    end
    
    % force matlab to recognize the upper / lower triangular structure
    L = sparse(L);
    U = sparse(L');
end
    