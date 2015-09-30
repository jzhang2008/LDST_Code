%%DUT-IIAU-DongWang-2013-03-27
%%Dong Wang, Huchuan Lu, Minghsuan Yang, Least Soft-thresold Squares
%%Tracking. CVPR 2013.
%%http://ice.dlut.edu.cn/lu/index.html
%%wangdong.ice@gmail.com
%%
% script: trackparam.m
%     loads data and initializes variables
%
% We would like to thank Jongwoo Lim and David Ross for sharing their codes
% and descriptions. 

% DESCRIPTION OF OPTIONS:
%
% Following is a description of the options you can adjust for
% tracking, each proceeded by its default value.

%*************************************************************
% For a new sequence , you will certainly have to change p.
%       对于一个新的视频序列，需要改变的是p的值
%*************************************************************
%
% To set the other options,
% first try using the values given for one of the demonstration
% sequences, and change parameters as necessary.
%
%*************************************************************
% p = [px, py, sx, sy, theta]; 
% The location of the target in the first frame.
%       目标在第一帧的位置
% px and py are th coordinates of the centre of the box
%   px，py       ：   目标框的中心位置；
%
% sx and sy are the size of the box in the x (width) and y (height)
%   dimensions, before rotation
%   sx，sy       ：   目标框的宽，高
%
% theta is the rotation angle of the box
%   theta        ：   目标框的旋转角度
%
% 'numsample',400,   The number of samples used in the condensation
% algorithm/particle filter.  Increasing this will likely improve the
% results, but make the tracker slower.
%   'numsample'  :    采样次数，采样次数增加会提高效果，但跟踪速度会很慢
%
% 'condenssig',0.01,  The standard deviation of the observation likelihood.
%   'condenssig  ：   观测对象似然标准偏差
%
% 'ff',1, The forgetting factor, as described in the paper.  When
% doing the incremental update, 1 means remember all past data, and 0
% means remeber none of it.
%   'ff'         ：   遗忘因子
%
% 'batchsize',5, How often to update the eigenbasis.  We've used this
% value (update every 5th frame) fairly consistently, so it most
% likely won't need to be changed.  A smaller batchsize means more
% frequent updates, making it quicker to model changes in appearance,
% but also a little more prone to drift, and require more computation.
%   'batchsize'  ：   更新间隔
%
% 'affsig',[4,4,.02,.02,.005,.001]  These are the standard deviations of
% the dynamics distribution, that is how much we expect the target
% object might move from one frame to the next.  The meaning of each
% number is as follows:
%   'affsig'    ：   动态模型，affine变换参数分布"均值","方差"
%    affsig(1) = x translation (pixels, mean is 0)
%    affsig(2) = y translation (pixels, mean is 0)
%    affsig(3) = rotation angle (radians, mean is 0)
%    affsig(4) = x scaling (pixels, mean is 1)
%    affsig(5) = y scaling (pixels, mean is 1)
%    affsig(6) = scaling angle (radians, mean is 0)
%
% OTHER OPTIONS THAT COULD BE SET HERE:
%
% 'tmplsize', [32,32] The resolution at which the tracking window is
% sampled, in this case 32 pixels by 32 pixels.  If your initial
% window (given by p) is very large you may need to increase this.
%   'tmplsize'  ：   跟踪窗大小
%
% 'maxbasis', 16 The number of basis vectors to keep in the learned
% apperance model.
%   'maxbasis'  :   最大基向量个数
%

%%******Change 'title' to choose the sequence you wish to run******%%
condenssig = 0.05;
switch (title) 
%%-------------------------------------------------------------------------
    %
    case 'Caviar3'; 
        p = [162 216 50 140 0.0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4, 4,.01,.00,.00,.00]);
        start_frame = 1; 
        nframes		= 500;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Caviar1'; 
        p = [145,112,30,79,0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4,4,.01,.00,.00,.00]);
        start_frame = 1; 
        nframes		= 382;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';  
    case 'Caviar2';   
        p = [ 152, 68, 18, 61, 0.00 ];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4,4,.01,.00,.00,.00]); 
        start_frame = 1; 
        nframes		= 500;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Occlusion1'; 
        p = [177,147,115,145,0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[1, 1,.01,.00,.00,.00]);  
        start_frame = 1; 
        nframes		= 898;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';            
    case 'Occlusion2';    
        p = [156,107,74,100,0.00];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4, 4,.008,.012,.00,.00]);               
        start_frame = 1; 
        nframes		= 819;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Deer';  
        p = [350, 40, 100, 70, 0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[12,12,.01,.00,.00,.00]);
        start_frame = 1; 
        nframes		= 71;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Jumping';         
        p = [163,126,33,32,0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[12,12,.01,.00,.00,.00]);                      
        start_frame = 1; 
        nframes		= 313;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'DavidIndoorOld';  
        p = [160 112 60 92 -0.02];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4, 4,.005,.02,.00,.00]);  
        start_frame = 1; 
        nframes		= 462;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'DavidIndoorNew'; 
        p = [194,108,46,60,0.00];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4, 4,.002,.01,.00,.00]);
        start_frame = 1; 
        nframes		= 669;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Car11';  
        p = [89 140 30 25 0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4, 4,.01,.00,.00,.00]);
        start_frame = 1;                                                   %starting frame number
        nframes		= 393;	                                               %number of frames to be tracked
        fext		= 'png';				                               %image format
%         numzeros	= 4;	                                               %number of digits for the frame index
        s_frames	= cell(nframes,1);
        nz			= '%04d';%strcat('%0',num2str(numzeros),'d');                  %number of zeros in the name of image
    %
    case 'Owl';      
        p = [380 247 56 100 0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[25,25,.01,.00,.00,.00]); 
        start_frame = 1; 
        nframes		= 630;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Face';  
        p = [293 283 94 114 0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[25,25,.01,.00,.00,.00]);  
        start_frame = 1; 
        nframes		= 492;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Singer1';  
        p = [100, 200, 100, 300, 0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1,...
                     'batchsize', 5, 'affsig',[4,4,.01,.00,.00,.00]); 
        start_frame = 1; 
        nframes		= 321;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Car4'; 
        p = [245 180 200 150 0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1,...
                     'batchsize',5, 'affsig',[4,4,.01,.00,.00,.00]); 
        start_frame = 1; 
        nframes		= 659;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'Football'; 
        p = [330 125 50 50 0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1,...
                     'batchsize',5, 'affsig',[4,4,.005,.00,.00,.00]);  
        start_frame = 1; 
        nframes		= 362;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'DavidOutdoor'; 
        p = [102,266,40,134,0.00];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1,...
                     'batchsize',5, 'affsig',[8,8,.00,.00,.00,.00]);
        start_frame = 1; 
        nframes		= 252;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'panda'; 
        p = [286 171 25 25 0.01];
        opt = struct('numsample',500, 'condenssig',condenssig, 'ff',1, ...
                     'batchsize',5,'affsig',[10,10,.01,.15,.000,.0000]);
        start_frame = 1; 
        nframes		= 241;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'woman'
        p = [222 165 35 95 0.0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1, ...
                     'batchsize',5, 'affsig',[4,4,0.01,0.0,0.005,0.000]);
        start_frame = 1; 
        nframes		= 550;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
    case 'shaking'; 
       p = [255, 170, 60, 70, 0 ];
       opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1, ...
                     'batchsize',5,'affsig',[4,4,.03,.00,.00,.00]);
       start_frame = 1; 
       nframes		= 365;
       fext		= 'jpg';
       s_frames	= cell(nframes,1);
       nz          = '%d';
    case 'board'
        p = [154,243,195,153,0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1, ...
                     'batchsize',5, 'affsig',[10, 10, .03, .00, .001, .00]);
       start_frame = 1; 
       nframes		= 598;
       fext		= 'jpg';
       s_frames	= cell(nframes,1);
       nz          = '%d';
     case 'Stone'; 
        p = [115 150 43 20 0.0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1, ...
                     'batchsize',5, 'affsig',[6,6,.01,.012,.000,.0000]);
        start_frame = 1; 
        nframes		= 593;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
      case 'bird'; 
        p = [470 91 200 127 0.0];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1, ...
                     'batchsize',5, 'affsig',[8,8,.00,.00,.000,.0000]);
        start_frame = 1; 
        nframes		= 593;
        fext		= 'jpg';
        s_frames	= cell(nframes,1);
        nz          = '%d';
      case 'liquor'; 
          p = [ 292, 255, 68, 202, 0.00];
          opt = struct('numsample',600, 'affsig',[15 ,15, 0.01, 0.0, 0.0, .00]);
          start_frame = 1; 
          nframes	  = 1714;
          fext		  = 'jpg';
          s_frames	  = cell(nframes,1);
          nz          = '%05d';
    case 'girl';
        p =[181,110,106,127,0.00];
        opt = struct('numsample',600, 'condenssig',condenssig, 'ff',1.0,...
                     'batchsize',5, 'affsig',[4, 4,.01,.00,.00,.00]); 
        start_frame = 1;  %starting frame number
        nframes		  = 501; %393;	 %number of frames to be tracked
        fext		  = 'png';				%image format
        numzeros	  = 5;	%number of digits for the frame index
        nz			  = strcat('img%0',num2str(numzeros),'d');
    otherwise;  error(['unknown title ' title]);
end
%%******Change 'title' to choose the sequence you wish to run******%%

%%***************************Data Path*****************************%%
fprefix     = fullfile('.\data\',title);
%%***************************Data Path*****************************%%