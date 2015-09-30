function dispalyResults
%%Algorithms:{'NNDL'},...            %IVT/IPCA Tracker
algorithm = [
             {'l1'},...             %L1   Tracker
             {'MTT'},...            %VTD  Tracker
             {'ASLAS'},...            %MIL  Tracker
             {'SBCM'},...           %Frag Tracker%{'srpca'}...           %srpca
             {'LSST'},...
             {'LDST'}...            %Dynamic Sparse
            ];%{'pn'},...             %PN   Tracker
%%Color:
color     = [{'b'},...       
             {'g'},...      
             {'k'},...         
             {'y'},...           
             {'m'},...           
             {'c'},...           
             {'r'}...
            ];

%%VideoName
% videoName = 'Lemming';
% videoName = 'Occlusion2';
% videoName = 'Occlusion1';
%  videoName = 'Girl';
%   videoName = 'Stone';
% videoName = 'Car11';
% videoName = 'Car4';
% videoName = 'Caviar1';
% videoName = 'girl';
% videoName = 'Jumping';
% videoName = 'Singer1';
% videoName = 'Deer';
% videoName = 'DavidIndoor';
% videoName = 'Caviar2';
% videoName = 'Football';
%   videoName = 'shaking';
videoName ='woman';
%%FontSize && LineWidth
% fontSize  = 30;     lineWidth = 3.5;
fontSize  = 18;     lineWidth = 2.7;

%%结果文件或真值文件路径：
filePath  = ['Results' '\' videoName '\'];  

%%视频数据信息：[ 宽 高 帧数 ]
temp      = importdata(['Data\' videoName '\' 'datainfo.txt' ]);
imageSize = [ temp(2) temp(1) ];
frameNum  = temp(3);

%%Load Results:
for num = 1:length(algorithm)
    load([ filePath '\' videoName '_' algorithm{num} '_' 'rs.mat' ]);
%     load([ filePath '\' videoName '_' algorithm{num}  '.mat' ]);
end
load([ filePath '\' videoName '_' 'gt' '.mat' ]);
figure('position',[ 100 100 imageSize(2) imageSize(1) ]); 
set(gcf,'DoubleBuffer','on','MenuBar','none');
step=1;
for num = 1:step:frameNum
    framePath = [ 'Data\' videoName '\'  int2str(num) '.jpg'];
    imageRGB  = imread(framePath);
    axes('position', [0 0 1.0 1.0]);
    imagesc(imageRGB, [0,1]); 
    hold on; 

    numStr = sprintf('#%04d', num);
    text(10,20,numStr,'Color', 'r', 'FontWeight', 'bold', 'FontSize', fontSize);
    
    corner = gtCornersAll{1,floor(num/step)+1};
    line(corner(1,:), corner(2,:), 'Color', 'b', 'LineWidth', lineWidth); 
    corner = l1CornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'g', 'LineWidth', lineWidth);
%     corner = pnCornersAll{1,num};
%     line(corner(1,:), corner(2,:), 'Color', 'k', 'LineWidth', lineWidth); 
    corner = MTTCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'y', 'LineWidth', lineWidth); 
    corner = ASLASCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'm', 'LineWidth', lineWidth);
    corner = SBCMCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'c', 'LineWidth', lineWidth);   
%     corner = srpcaCornersAll{1,num};
    corner = LSSTCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'LineStyle','--','Color', [0 0.5 0], 'LineWidth', lineWidth); 
    corner = LDSTCornersAll{1,num};
    line(corner(1,:), corner(2,:), 'Color', 'r', 'LineWidth', lineWidth);    
 

    axis off;
    hold off;
    drawnow;
    savePath = sprintf('Dump/%s_%s_%04d.jpg', videoName, 'rs', num);
    imwrite(frame2im(getframe(gcf)),savePath);
    clf;
end