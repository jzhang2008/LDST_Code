function [idx dis]=HistIntersect(A,B)
if size(A,2)~=size(B,2)
    B=B*ones(1,size(A,2));
end
% Dp=min(A,B);
% hd=sum(Dp);
% [dis idx]=min(hd);
Dp=A-B;
hd=Dp.^2./(A+B);
[dis idx]=min(sum(hd));