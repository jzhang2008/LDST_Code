function [rTmat uTmat]=CalRotateTemplate(Tmat)
Tmat=reshape(Tmat,32,32);
%���ҵߵ�ģ��
rTmat=Tmat(:,end:-1:1);
%���µߵ���ģ��
uTmat=Tmat(end:-1:1,end:-1:1);
%תΪ������
rTmat=rTmat(:);
uTmat=uTmat(:);

