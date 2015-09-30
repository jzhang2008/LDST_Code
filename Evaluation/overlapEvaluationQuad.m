function [ overlapRate frameIndex ] = overlapEvaluationQuad(rsCorners, gtCorners, frameIndex)
%%function [ overlapRate frameIndex ] = overlapEvaluationQuad(rsCorners, gtCorners, frameIndex)
%%Perform Overlap Rate Evaluation via Tracking Results and Ground Truth
%%Version 1.0
%%
%%Input:
%%  rsCorners:      Cell Structure; The Tracking Results in the i-th frame
%%                  rsCorners{i}    [ x1 x2 x3 x4 x1...
%%                                    y1 y2 y3 y4 y1 ];
%%                                  use a 2*5 matrix depict a quadrilateral region
%%  gtCorners:      Cell Structure; The Ground Truth in the frameIndex{i}-th frame
%%                  rsCorners{i}    [ x1 x2 x3 x4 x1...
%%                                    y1 y2 y3 y4 y1 ];
%%                                  use a 2*5 matrix depict a quadrilateral region
%%  frameIndex:     The Frame Index of Ground Truth
%%                  The i-th groundtruth is related with the frameIndex{i}-th frame
%%                  "It is too trivial to label gound truth for every frame,
%%                  especially for long-term sequence. Thus, a protion of
%%                  all frames are usually labeled manually. This parmeter indicates 
%%                  the labeled frames".               
%%Authour:
%%  Dong Wang-IIAU LAB-2011,05,10
%%  http://ice.dlut.edu.cn/lu/index.html
%%V1.0 (2011,05,10): Calculate Overlap Rate Evaluation via Tracking Results and Ground Truth
%%

gtLength = length(frameIndex);
overlapRate = zeros(1, gtLength);
overlapRate(1) = 1.0;
for num = 2:gtLength
    overlapRate(num) = calculateOverlapRate(rsCorners{frameIndex(num)},... 
                                            gtCorners{num},...
                                            'quadrilateral');
end
