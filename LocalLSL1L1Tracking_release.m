function [track_res output] = LocalLSL1L1Tracking_release( s_frames, param0, ...
    opt,video_name)
% L1Tracking  Visual tracking using L1-regularized least square.
%	[track_res] = L1Tracking( s_frames, sz_T, n_sample, init_pos )
%	tracks a target defined by the user using 'init_pos'
%
% Input:
%	s_frames	- names of sequence images to be tracked.
%	sz_T		- template size, e.g. 12 x 15
%	init_pos	- target selected by user (or automatically), it is a 2x3
%		matrix, such that each COLUMN is a point indicating a corner of the target
%		in the first image. Let [p1 p2 p3] be the three points, they are
%		used to determine the affine parameters of the target, as following
% 			  p1-------------------p3
% 				\					\
% 				 \       target      \
% 				  \                   \
% 				  p2-------------------\
%
% Output:
%	track_res - a 6xN matrix where each column contains the six affine parameters
%		for the corresponding frame, where N is the number of frames.
%
% For more details, refer to
%		X. Mei and H. Ling, Robust Visual Tracking using L1 Minimization,
%		IEEE International Conference on Computer Vision (ICCV), Kyoto, Japan, 2009.
%
% Xue Mei and Haibin Ling, Oct. 2009

%% Initialize T
%-Generate T from single image
nT			= 10;		% number of templates used, fixed in this version
n_sample    = opt.numsample;
sz_T        = opt.tmplsize;
opt.nT      = nT;
img_name	= s_frames{1};
%% L1 function settings
% angle_threshold = paraT.angle_threshold;
% para.Lambda = paraT.lambda;
% para.nT = paraT.nT;
% para.Lip = paraT.Lip;
% para.Maxit = paraT.Maxit;
% para.bDebug=paraT.bDebug;
% lambda	= .01;
% rel_tol = 0.01;
% quiet	= true;
angle_threshold =45;
% dim_T	= size(T,1);	%number of elements in one template, sz_T(1)*sz_T(2)=12x15 = 180
%A		= [T eye(dim_T)]; %data matrix is composed of T, positive trivial T.
% A       =T;
alpha = 50;
gamma = 0.2;
% aff_obj = affparam2geom(param0(:)); %get affine transformation parameters from the corner points in the first frame
% map_aff = aff_obj;
% aff_samples = ones(n_sample,1)*map_aff;
% rel_std_afnv = [0.005,0.0005,0.0005,0.005,1,1];
%rel_std_afnv = [0.005,0.0005,0.0005,0.005,2,2];
% rel_std_afnv = [0.05,0.005,0.005,0.05,1,1];
% W = ones(1,nT); %W are initialized to
T_id	= [-(1:nT) 1];	% template IDs, for debugging
% NfixT=hist(Tp(:,1),30);
temp_size  = [32 32];
patch_size = [8 8];
% step_size = 8;
[T,Tp,T_norm,T_mean,T_std] = LS_InitTemplates(img_name,param0,opt,temp_size);
norms       = T_norm.*T_std; %template norms
angle       = 0;
% fixT = T(:,1); %/nT first template is used as a fixed template
[patch_idx, patch_num] = img2patch(temp_size, patch_size);
[Local_Dic]=Cal_local_Dic([Tp Tp(:,1)],patch_idx, patch_num,patch_size);
for i=1:patch_num
    Local_Dic(:,:,i)=normlizeTemp(Local_Dic(:,:,i),patch_size);
end
occlusionNf = zeros(1,patch_num);
W           = ones(nT,patch_num)/nT;
%% Tracking
nframes	= length(s_frames);
track_res	= zeros(6,nframes);
param.est   =param0;
for t = 1:nframes
    fprintf('Frame number: %d \n',t); %image_no);
    tic;
    img_color	= imread(s_frames{t});
    if(size(img_color,3) == 3)
        img     = double(rgb2gray(img_color))/255;
    else
        img     = double(img_color)/255;
    end
    %-Draw transformation samples from a Gaussian distribution
    if ~isfield(param,'param')
       param.param = repmat(affparam2geom(param.est(:)), [1,n_sample]);
    else
       cumconf = cumsum(param.conf);
       idx = floor(sum(repmat(rand(1,n_sample),[n_sample,1]) > repmat(cumconf,[1,n_sample])))+1;
       param.param = param.param(:,idx);
    end
    %%Affine Parameter Sampling
      randMatrix = randn(6,n_sample);
      param.param = param.param + randMatrix.*repmat(opt.affsig(:),[1,n_sample]);
      [Y Yp Y_crop_norm Y_crop_mean Y_crop_std]=Seg_img_crop(img,param,opt);
      [Yc]=ReImageSize(Yp,temp_size);
      YY=Yc(patch_idx,:);
      Yc=reshape(YY,prod(patch_size),patch_num,size(Y,2));
      for j=1:n_sample
          Yc(:,:,j)=normlizeTemp(Yc(:,:,j),patch_size);
      end
    %-L1-LS for each candidate target
    eta_max	= -inf;
%      eta_1	= zeros(n_sample,1);
        c   = zeros(11,patch_num,n_sample);
        s   = zeros(prod(patch_size),patch_num,n_sample);
        D_s = zeros(patch_num,n_sample);
        D_p = zeros(patch_num,n_sample);
    for i=1:n_sample
        % ignore the out-of-frame image patch and constant image patch
        if(sum(abs(Y(:,i))) == 0) %Y_inrange(i) == 0 || 
            continue;
        end
%         param.lambda = 0.01;
%         param.lambda2=1;  
%         param.lambda2 = 0;
%         param.mode = 2;
%         param.L = length(Y(:,i));
%         c = mexLasso(Y(:,i), [A fixT], param);
%         c = full(c);
        param.lambda1 =0.01;
        param.lambda2 =0.005;%0.1;%0.05;%控制动态稀疏
        param.lambda3 =0.01;%0.01;%控制遮挡
        param.mode    =2;
        param.rho1    =1;
        param.rho2    =1;
        for j=1:patch_num
          if t==1
           [c(:,j,i),s(:,j,i),~]=SolveL1_Lasso(Local_Dic(:,:,j),Yc(:,j,i),param);
%          [c(:,:,i), s(:,:,i) ]           =Local_Cal_L1_min(Local_Dic,Yc(:,:,i),param);
          else
           [c(:,j,i), s(:,j,i), ~]=SolveL1L1_Lasso(Local_Dic(:,:,j),Yc(:,j,i),eye(opt.nT+1),xest(:,j),param);
%          [c(:,:,i), s(:,:,i) ]           =Local_Cal_L1L1_min(Local_Dic,Yc(:,:,i),xest,param);
          end
        end
        for j=1:patch_num
%          [c(:,j,i), s(:,j,i) ]           =Cal_L1_min(Local_Dic(:,:,j),Yc(:,j,i),param);
           D_s(j,i) = sum((Yc(:,j,i) - Local_Dic(:,:,j)*c(:,j,i)).^2);%+
%            D_p(j,i) =0.5*sum((Y(:,i) - [A(:,1:nT) fixT]*[c(1:nT,i); c(end,i)]-s(:,i)).^2)+param.lambda3*sum(abs(s(:,i)));
        end
    end
    eta_1=exp(-alpha*sqrt(D_s));
    [eeta_1 pd_max]=max(eta_1,[],1);
    [~,id_max]=max(eeta_1);
    [~,kd_max]=max(sum(eta_1));
    DD=sort(D_s,1);
    Dc=sum(DD(1:2,:));
    [~,id_max]=min(Dc);
    xest      =c(:,:,id_max);
    s_max     =s(:,:,id_max);
    param.conf=sum(eta_1)';
    param.conf = param.conf ./ sum(param.conf);
    %id_max	= find_max_no(eta_1);
    param.est = affparam2mat(param.param(:,id_max));%target transformation parameters with the maximum probability
    a_max	= xest(1:nT,:);
    Yb      = Yc(:,:,id_max);
%     for ik=1:patch_num
%         Wn          =W(:,ik).*exp(abs(a_max(:,ik)));
%         [~, indA]   = min(Wn);
%         angle   = images_angle(Yb(:,ik),Local_Dic(:,indA,ik));
%         if angle<=angle_threshold
%             disp('Update!')
%             Local_Dic(:,indA,ik)= Yb(:,ik);
%             Wn(indA)              =median(Wn);                  
% %             Local_Dic(:,:,ik)=normlizeTemp(Local_Dic(:,:,ik),patch_size);
%         end
%         W(:,ik)=Wn/sum(Wn);
%     end
    %% ------- 计算是否需要更新模板的条件-----------------------------------
    for ik=1:patch_num
        [~, indA]   = max(a_max(:,ik));
        angle   = images_angle(Yb(:,ik),Local_Dic(:,indA,ik));
        %-Template update
        occlusionNf(ik) = occlusionNf(ik)-1;
        level = 0.02;
        if( angle > angle_threshold && occlusionNf(ik)<0)        
            disp('Update!')
            trivial_coef = abs(s_max(:,ik));
            trivial_coef = reshape(trivial_coef, patch_size);
            trivial_coef = im2bw(trivial_coef, level);
            se           = [0 0 0 0 0;
                            0 0 1 0 0;
                            0 1 1 1 0;
                            0 0 1 0 0;
                            0 0 0 0 0];
            trivial_coef = imclose(trivial_coef, se);
            cc           = bwconncomp(trivial_coef);
            stats        = regionprops(cc, 'Area');
            areas        = [stats.Area];
            if isempty(areas)
                 areas   = 0;
            end
          % occlusion detection max(areas) 
            if ( max(areas)< round(0.25*prod(patch_size)))        
            % find the tempalte to be replaced
              [~,indW]   = min(a_max(:,ik));
             % insert new template
              Local_Dic(:,indW,ik)	 = Yb(:,ik);
              Local_Dic(:,:,ik)=normlizeTemp(Local_Dic(:,:,ik),patch_size);
%               T_mean(indW)= Y_crop_mean(id_max);
%               T_id(indW)	 = t; %track the replaced template for debugging
%               norms(indW) = Y_crop_std(id_max)*Y_crop_norm(id_max);
%               [T, ~]     = normalizeTemplates(T);
%               A(:,1:nT)	 = T;
%             xest(indW)=0.5;
            else
             occlusionNf(ik) = 5;
            end
        end
    end
    %% ----------------------- end---------------------------------------------------
    Time_record(t) = toc;
    %-Store tracking result
    track_res(:,t) = param.est;
    
    %-Demostration and debugging
    if opt.bDebug
        % print debugging information
        s_debug_path = opt.s_debug_path;
        fprintf('minimum angle: %f\n', angle);
        fprintf('T are: ');
        for i = 1:nT+1
            fprintf('%d ',T_id(i));
        end
        fprintf('\n');
        fprintf('coffs are: ');
        for i = 1:nT+1
            fprintf('%.3f ',xest(i));
        end
        
        fprintf('\n');
        fprintf('W are: ');
        for i = 1:nT
            fprintf('%.3f ',W(i));
        end
        fprintf('\n\n');
        
        % draw tracking results
        img_color	= double(img_color);
        img_color	= showTemplates(img_color, T, T_mean, norms, temp_size, nT);
        imshow(uint8(img_color));
        %显示第几帧
        text(5,10,num2str(t),'FontSize',18,'Color','r');
%         color = [1 0 0];
%         drawAffine(map_aff, sz_T, color, 2);[40 60]
        drawbox(opt.tmplsize, param.est, 'Color','r', 'LineWidth',2);
        %更新视图
        drawnow;
        
        if ~exist(s_debug_path,'dir')
            fprintf('Path %s not exist!\n', s_debug_path);
        else
            s_res	= s_frames{t}(1:end-4);
            s_res	= fliplr(strtok(fliplr(s_res),'/'));
            s_res	= fliplr(strtok(fliplr(s_res),'\'));
            s_res	= [s_debug_path video_name '\' s_res '_L1.png'];
            f		= getframe(gcf);
            imwrite(uint8(f.cdata), s_res);
        end
    end
end
output.time = Time_record; % cpu time of APG method for each frame
