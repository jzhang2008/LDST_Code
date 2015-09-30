function [pdx min_idx]=OcclusionProcess(err,lambda,tmplsize)
[row col]=size(err);
cdx      =zeros(row,col);
Occ_idx   =abs(err)>=lambda;
w        =int16(tmplsize(1));
h        =int16(tmplsize(2));
Occ_region=reshape(Occ_idx,w,h,col);%int16(tmplsize),int16(numsample));
% se = [0 0 0 0 0;
%       0 0 1 0 0;
%       0 1 1 1 0;
%       0 0 1 0 0'
%       0 0 0 0 0];
se = [0 0 0 0 0;
      0 1 1 1 0;
      0 1 1 1 0;
      0 1 1 1 0'
      0 0 0 0 0];
for i=1:col
    trivial_coef=imclose(Occ_region(:,:,i),se);
    cdx(:,i)    =trivial_coef(:);
end
Occ_Pixnum=sum(Occ_idx);
% Occ_Pixnum=sum(cdx);
[min_Occ_Pixnum min_idx]=min(Occ_Pixnum);
% pdx=cdx(:,min_idx);
pdx=Occ_idx(:,min_idx);
% [~,pdx]  =sort(abs(err));
% cdx      =pdx(1:row-max_Occ_Pixnum,:);
% kdx      =pdx(row-max_Occ_Pixnum:end,:);
