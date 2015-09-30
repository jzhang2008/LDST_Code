clear;
clc;
addpath(genpath('.'));
%%******Change 'title' to choose the sequence you wish to run******%%
% title = 'Car11';
title = 'Car4';
% title = 'Face';
% title   ='panda';
% title   ='Caviar1';
% title   ='Caviar2';
% title   ='woman_sequence';
% title   ='shaking';
% title   ='board';
% title   ='bird';
% title   ='liquor';
% title   ='Caviar3';
% title     ='Deer';
% title     ='DavidOutdoor';
%  title ='DavidIndoorNew';
% title ='girl';
% title ='Jumping';
% title   ='Owl';
% title   ='Football';
% title   ='Stone';
% title   ='Occlusion1'; 
% title   ='Singer1';
trackparam;
%%1.1 Initialize variables:
rand('state',0);    randn('state',0);
if ~exist('opt','var')        opt = [];  end
if ~isfield(opt,'tmplsize')   opt.tmplsize = [32,32];  end %[12,15];                 
if ~isfield(opt,'numsample')  opt.numsample = 600;  end                     
if ~isfield(opt,'affsig')     opt.affsig = [4,4,.01,.00,.00,.00];  end
if ~isfield(opt,'lssParam')             %%Parameters for Sloving Soft-thresold Squares Regression
    opt.lssParam = [];                           
    opt.lssParam.lambda = 0.1;          %%For Penalizing the Laplacian Noise Term
    opt.lssParam.maxLoopNum = 20;       %%A Maximal Number of Iterations
    opt.lssParam.tol        = 0.001;    %%Stopping Threshold     
end
if ~isfield(opt,'pDebug') opt.bDebug=1; end
if ~isfield(opt,'s_debug_path') opt.s_debug_path='Results\'; end           %folder for the tracking result
if ~exist([opt.s_debug_path title],'dir')
    mkdir([opt.s_debug_path title]);
end
%% Initialization and parameters
% nT			= 10;		%number of T
% n_sample	= 600;		%number of particles
                                         

%preparing frames
% video_name  = 'pktest02';
% fprefix		= 'pktest02\frame';                                            %folder storing the images
% fext		= 'jpg';				                                       %image format
% start_frame	= 1087;					                                       %starting frame number
% nframes		= 120;					                                       %number of frames to be tracked
% sz_T		= [12 15];	                                                   %size of the template
% numzeros	= 5;	                                                       %number of digits for the frame index

% sz_T		= opt.tmplsize;%[12 15];	                                                   %size of the template
% load([fprefix '\' title '_gt.mat'])
% paramSetting;
% nz			= strcat('%0',num2str(numzeros),'d'); %number of zeros in the name of image
for t=1:nframes
    image_no	= start_frame + (t-1);
    fid			= sprintf(nz, image_no);
    s_frames{t}	= strcat(fprefix,'\',fid,'.',fext);
end

%initialization
%	init_pos	- target selected by user (or automatically), it is a 2x3
%		matrix, such that each COLUMN is a point indicating a corner of the target
%		in the first image. Let [p1 p2 p3] be the three points, they are
%		used to determine the affine parameters of the target, as following
% 			  p1(128,116)-------------------p3(120,129)
% 					\						  \
% 					 \			target         \
% 					  \					        \
% 				  p2(150, 136)-------------------\


% %-One can also cropping the initial box through the following code
% init_pos	= SelectTarget(s_frames{1});
param0 = [p(1), p(2), p(3)/32, p(5), p(4)/p(3), 0];  %    
param0 = affparam2mat(param0);
% init_pos = [m_boundingbox(2)   m_boundingbox(2)+m_boundingbox(4)  m_boundingbox(2) ;
%             m_boundingbox(1)   m_boundingbox(1)                   m_boundingbox(1)+m_boundingbox(3)];
 
% init_pos	= [	128 150 120;
% 			    116 136 129];

%% L1 tracking
fcdatapts               = [28 507; 82 721];                                        %the coordinates of the image on the figure
[tracking_res output]   = LocalLSL1L1Tracking_release( s_frames,param0, opt, title);
disp(['fps: ' num2str(nframes/sum(output.time))])

%% Output tracking results
% all_results_path = '.\Results\';
% if ~exist([all_results_path title],'dir')
%     mkdir([all_results_path title]);
% end
if ~opt.bDebug
   for t = 1:nframes
      img_color	= imread(s_frames{t});
      img_color	= double(img_color);
      imshow(uint8(img_color));
      text(5,10,num2str(t+start_frame),'FontSize',18,'Color','r');
      map_afnv	= tracking_res(:,t);
%       drawAffine(map_afnv, opt.tmplsize, color, 2);
      drawbox(opt.tmplsize, map_afnv, 'Color','r', 'LineWidth',2);
      drawnow
      s_res	= s_frames{t}(1:end-4);
      s_res	= fliplr(strtok(fliplr(s_res),'/'));
      s_res	= fliplr(strtok(fliplr(s_res),'\'));
%     s_res	= [res_path s_res '_L1.png'];
      s_res	= [s_res '_L1.png'];
          f = getframe(gcf);
      imwrite(uint8(f.cdata), [opt.s_debug_path title '\' s_res]);
%     imwrite(uint8(f.cdata), s_res);%(fcdatapts(1,1):fcdatapts(1,2), fcdatapts(2,1):fcdatapts(2,2), :)
  end
end

%% output result
% s_res = sprintf('%s%s\\L1_result_%d_%d.mat', opt.s_debug_path, title,start_frame, nframes);
% save(s_res, 'tracking_res');
%%*************************3.STD Results*****************************%%
load([fprefix '\' title '_gt.mat'])
LSSTCenterAll  = cell(1,nframes);      
LSSTCornersAll = cell(1,nframes);
for num = 1:nframes
    if  num <= size(tracking_res,2)
        est = tracking_res(:,num);
        [ center corners ] = p_to_box([32 32], est');
    end
    LSSTCenterAll{num}  = center;      
    LSSTCornersAll{num} = corners;
end
s_res = sprintf('%s%s\\%s_LSST_rs.mat', opt.s_debug_path, title,title);
save(s_res, 'LSSTCenterAll', 'LSSTCornersAll');
% DynamicSparse_res=affine2rect(tracking_res,sz_T);
[ overlapRate ] = overlapEvaluationQuad(LSSTCornersAll, gtCornersAll, frameIndex);
mOverlapRate = mean_no_nan(overlapRate)
[ centerError ] = centerErrorEvaluation(LSSTCenterAll,  gtCenterAll, frameIndex);
mCenterError = mean_no_nan(centerError)
