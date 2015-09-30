function [T]=normlizeTemp(T,tmplsize)
% T_mean= mean(T);
% T_std = std (T);
% T     =(T-ones(prod(tmplsize),1)*T_mean)./(ones(prod(tmplsize),1)*T_std);
T_norm= sqrt(sum(T.^2,1));
T     =T./(ones(prod(tmplsize),1)*T_norm+eps);