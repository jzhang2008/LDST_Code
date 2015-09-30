function [Yc]=ReImageSize(Y,temp_size)
[~,nDim]=size(Y);
YY=reshape(Y,32,32,nDim);
Yc=zeros(temp_size(1),temp_size(2),nDim);
for i=1:nDim
    Yc(:,:,i)=imresize(YY(:,:,i),temp_size);
end
Yc=reshape(Yc,prod(temp_size),nDim);