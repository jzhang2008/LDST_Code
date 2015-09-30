function [T,Tp,T_norm,T_mean,T_std] = LS_InitTemplates(img_name, param0,opt,temp_size)
% generate templates from single image
%   (r1,c1) ***** (r3,c3)            (1,1) ***** (1,cols)
%     *             *                  *           *
%      *             *       ----->     *           *
%       *             *                  *           *
%     (r2,c2) ***** (r4,c4)              (rows,1) **** (rows,cols)
% r1,r2,r3;
% c1,c2,c3

%% prepare templates geometric parameters
init_param=repmat(affparam2geom(param0(:)),[1 opt.nT])+[zeros(6,1) rand(6,opt.nT-1).*repmat(opt.affsig(:).*[0 0 ones(1,4)]',[1 opt.nT-1])];%0 0 ones(1,4)

%% Initializating templates and image
% T	= zeros(prod(opt.tmplsize),10);

% nz	= strcat('%0',num2str(numzeros),'d');
% image_no = sfno;
% fid = sprintf(nz, image_no);
% img_name = strcat(fprefix,fid,'.',fext);

img = imread(img_name);
if(size(img,3) == 3)
    grayimg = double(rgb2gray(img));
else
    grayimg =double(img);
end
img=double(grayimg)/255;
%% cropping and normalizing templates
wimgs = warpimg(img, affparam2mat(init_param), opt.tmplsize);
% nDim  =size(wimgs,3);
% cimgs =zeros(60,40,nDim);
% for i=1:nDim
%     cimgs(:,:,i)=imresize(wimgs(:,:,i),temp_size);
% end
T     = reshape(wimgs,prod(temp_size),opt.nT);
Tp    = T;
T_mean= mean(T);
T_std = std (T);
T     =(T-ones(prod(temp_size),1)*T_mean)./(ones(prod(temp_size),1)*T_std);
T_norm= sqrt(sum(T.^2,1));
T     =T./(ones(prod(temp_size),1)*T_norm);
% T     =Tk-ones(prod(opt.tmplsize),1)*mean(Tk);
