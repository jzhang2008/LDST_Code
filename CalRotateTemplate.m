function [rTmat uTmat]=CalRotateTemplate(Tmat)
Tmat=reshape(Tmat,32,32);
%左右颠倒模板
rTmat=Tmat(:,end:-1:1);
%上下颠倒的模板
uTmat=Tmat(end:-1:1,end:-1:1);
%转为列向量
rTmat=rTmat(:);
uTmat=uTmat(:);

