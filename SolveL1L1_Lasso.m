function [z s disNew]=SolveL1L1_Lasso(A,b,F,x0,param)
if ~isfield(param,'mode')
    param.mode=1;
    const=0;
end
if ~isfield(param,'rho1')
    param.rho1=1;
end
if ~isfield(param,'rho2')
    param.rho2=1;
end
if ~isfield(param,'lambda1')
    param.lambda1=0.01;
end
if ~isfield(param,'lambda2')
    param.lambda2=0.01;
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
end
if param.mode==2
    const=1;
end
%--------------------------------------------------------------------------
[m,n]=size(A);
[L U]=factor(A,param.rho1+param.rho2);
   x=zeros(n,1);
   z=zeros(n,1);
   y1=zeros(n,1);
   y2=zeros(n,1);
   v =zeros(n,1);
   s=zeros(m,1);
   disOld = 0;
   disNew = 0;
   for k=1:param.MAX_ITER
       Atb=A'*(b-s*const);
       q = Atb + param.rho1*z - y1+param.rho2*(F*x0+v)-y2;    % temporary value
      if( m >= n )    % if skinny
          x = U \ (L \ q);
      else            % if fat
          x = q/(param.rho1+param.rho2) - (A'*(U \ ( L \ (A*q) )))/(param.rho1+param.rho2)^2;
      end
%        z=shrinkage(x+y1/param.rho1,param.lambda1/param.rho1);
       z=max(x+(y1+param.lambda1)/param.rho1,0);
       y1=y1+param.rho1*(x-z);
       v=shrinkage(x-F*x0+y2/param.rho2,param.lambda2/param.rho2);
       y2=y2+param.rho2*(x-x0-v);
       s=shrinkage(b-A*x,param.lambda3);
       disNew=0.5*norm(b-A*x-s*const)+param.lambda1*norm(z,1)+param.lambda2*norm(x-F*x0,1)+param.lambda3*norm(s,1);
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