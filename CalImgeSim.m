function [idx dis]=CalImgeSim(A,B)
n=size(A,2);
AA=reshape(A,32,32,n);
D =zeros(32,32,n);
d =zeros(n,32);
for i=1:n
    [~,D(:,:,i),~]=svd(AA(:,:,i));
    d(i,:)=diag(D(:,:,i));
end
[~,DD,~]=svd(reshape(B,32,32));
dd      =diag(DD);
diff    =d-repmat(dd',[n,1]);
[dis idx]=min(sum(diff(:,1:10).^2,2));
