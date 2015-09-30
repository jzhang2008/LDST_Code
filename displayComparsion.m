function displayComparsion
clc;
clear;
addpath('./Evaluation/');

%%1--Video Name:
%%  Data sets reported in the TIP paper 
% fileName = 'Occlusion1';
% fileName = 'Occlusion2';
% fileName = 'Caviar1';
% fileName = 'Caviar2';
% fileName = 'Car4';
% fileName = 'Singer1';
% fileName = 'Shaking';
% fileName = 'Football';
% fileName = 'DavidIndoor';
% fileName = 'Car11';
% fileName = 'Deer';
% fileName = 'Jumping';
% fileName = 'Lemming';
% fileName = 'Cliffbar';
%%  Additional data sets:
% fileName = 'DavidOutdoor';
% fileName = 'Stone';
% fileName = 'Girl';
fileName = 'woman';

%%2--Load data
filePath = [ '.\Results\' fileName '\' ];
%%(1)IPCA(IVT) Tracker
% load([filePath fileName '_NNDL_rs.mat']); 
%%(2)L1 Tracker
load([filePath fileName '_l1_rs.mat']);
%%(3)PN Tracker
% load([filePath fileName '_pn_rs.mat']);
%%(4)VTD Tracker
load([filePath fileName '_MTT_rs.mat']);
%%(5)MIL Tracker
load([filePath fileName '_ASLAS_rs.mat']);
%%(6)Frag Tracker
load([filePath fileName '_SBCM_rs.mat']);
%%(7)My Tracker
% load([filePath fileName '_srpca_rs.mat']);
load([filePath fileName '_LSST_rs.mat']);
load([filePath fileName '_LDST_rs.mat']);
%%(8)GT
load([filePath fileName '_gt.mat']);

%%3--Overlap Rate Evaluation
%%(1)IPCA(IVT) Tracker
% [ overlapRateNDL ]   = overlapEvaluationQuad(NNDLCornersAll, gtCornersAll, frameIndex);
%%(2)L1 Tracker
[ overlapRateL1 ]    = overlapEvaluationQuad(l1CornersAll, gtCornersAll, frameIndex);
%%(3)PN Tracker
% [ overlapRatePN ]    = overlapEvaluationQuad(pnCornersAll, gtCornersAll, frameIndex);
%%(4)VTD Tracker
[ overlapRateMTT ]   = overlapEvaluationQuad(MTTCornersAll, gtCornersAll, frameIndex);
%%(5)MIL Tracker
[ overlapRateSCM ]   = overlapEvaluationQuad(SBCMCornersAll, gtCornersAll, frameIndex);
%%(6)Frag Tracker
[ overlapRateASLAS ]  = overlapEvaluationQuad(ASLASCornersAll, gtCornersAll, frameIndex);
%%(7)My Tracker
% [ overlapRateSRPCA ] = overlapEvaluationQuad(srpcaCornersAll, gtCornersAll, frameIndex);
[ overlapRateLSST ] = overlapEvaluationQuad(LSSTCornersAll, gtCornersAll, frameIndex);
[ overlapRateLDST ] = overlapEvaluationQuad(LDSTCornersAll, gtCornersAll, frameIndex);
ORE = [];   %%Overlap Rate Evaluation
% ORE.NDL   = overlapRateNDL;
ORE.L1    = overlapRateL1;
% ORE.PN    = overlapRatePN;
ORE.MTT   = overlapRateMTT;
ORE.SCM   = overlapRateSCM;
ORE.ASLAS  = overlapRateASLAS;
%ORE.SRPCA = overlapRateSRPCA;
ORE.LSST = overlapRateLSST;
ORE.LDST = overlapRateLDST;
ORE_M = []; %%Overlap Rate Evaluation (Mean)
% ORE_M.NDL   = mean(overlapRateNDL)
ORE_M.L1    = mean(overlapRateL1)
% ORE_M.PN    = mean(overlapRatePN)
ORE_M.MTT   = mean(overlapRateMTT)
ORE_M.SCM   = mean(overlapRateSCM)
ORE_M.ASLAS  = mean(overlapRateASLAS)
%ORE_M.SRPCA = mean(overlapRateSRPCA);
ORE_M.LSST = mean(overlapRateLSST)
ORE_M.LDST = mean(overlapRateLDST)
ORE_S = []; %%Overlap Rate Evaluation (Successful Tracking Frames)
% ORE_S.NDL   = sum(overlapRateNDL>0.5);
ORE_S.L1    = sum(overlapRateL1>0.5);
% ORE_S.PN    = sum(overlapRatePN>0.5);
ORE_S.MTT   = sum(overlapRateMTT>0.5);
ORE_S.SCM   = sum(overlapRateSCM>0.5);
ORE_S.ASLAS  = sum(overlapRateASLAS>0.5);
% ORE_S.SRPCA = sum(overlapRateSRPCA>0.5);
ORE_S.LSST = sum(overlapRateLSST>0.5);
ORE_S.LDST = sum(overlapRateLDST>0.5);
save([fileName '_overlapRateEvaluation.mat'], 'ORE', 'ORE_M', 'ORE_S', 'frameIndex');

%%4--Center Error Evaluation
%%(1)IPCA(IVT) Tracker
% [ centerErrorNDL ]   = centerErrorEvaluation(NNDLCenterAll, gtCenterAll, frameIndex);
%%(2)L1 Tracker
[ centerErrorL1 ]    = centerErrorEvaluation(l1CenterAll, gtCenterAll, frameIndex);
%%(3)PN Tracker
% [ centerErrorPN ]    = centerErrorEvaluation(pnCenterAll, gtCenterAll, frameIndex);
%%(4)VTD Tracker
[ centerErrorMTT ]   = centerErrorEvaluation(MTTCenterAll, gtCenterAll, frameIndex);
%%(5)MIL Tracker
[ centerErrorSCM ]   = centerErrorEvaluation(SBCMCenterAll, gtCenterAll, frameIndex);
%%(6)Frag Tracker
[ centerErrorASLAS ]  = centerErrorEvaluation(ASLASCenterAll, gtCenterAll, frameIndex);
%%(7)My Tracker
% [ centerErrorSRPCA ] = centerErrorEvaluation(srpcaCenterAll, gtCenterAll, frameIndex);
[ centerErrorLSST ] = centerErrorEvaluation(LSSTCenterAll, gtCenterAll, frameIndex);
[ centerErrorLDST ] = centerErrorEvaluation(LDSTCenterAll, gtCenterAll, frameIndex);
CEE = [];   %%Center Error Evaluation
% CEE.NDL   = centerErrorNDL;
CEE.L1    = centerErrorL1;
% CEE.PN    = centerErrorPN;
CEE.MTT   = centerErrorMTT;
CEE.SCM   = centerErrorSCM;
CEE.ASLAS  = centerErrorASLAS;
%CEE.SRPCA = centerErrorSRPCA;
CEE.LSST = centerErrorLSST;
CEE.LDST = centerErrorLDST;
CEE_M = []; %%Center Error Evaluation (Mean)
% CEE_M.NDL   = mean(centerErrorNDL)
CEE_M.L1    = mean(centerErrorL1)
% CEE_M.PN    = mean(centerErrorPN(~isnan(centerErrorPN)))
CEE_M.MTT   = mean(centerErrorMTT)
CEE_M.SCM   = mean(centerErrorSCM)
CEE_M.ASLAS  = mean(centerErrorASLAS)
% CEE_M.SRPCA = mean(centerErrorSRPCA);
CEE_M.LSST = mean(centerErrorLSST)
CEE_M.LDST = mean(centerErrorLDST)
save([fileName '_centerErrorEvaluation.mat'], 'CEE', 'CEE_M', 'frameIndex');

%%5--Display Overlap Rate Evaluation
figure(1);
% hold on;
% plot(frameIndex, ORE.NDL,   'B--', 'linewidth', 2.5); 
hold on; 
plot(frameIndex, ORE.L1 ,   'G--', 'linewidth', 2.5); 
% hold on;
% plot(frameIndex, ORE.PN,    'K--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.MTT,   'Y--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.SCM,   'M--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, ORE.ASLAS,  'C--', 'linewidth', 2.5); 
hold on;
% plot(frameIndex, ORE.SRPCA, 'R',   'linewidth', 2.5);
plot(frameIndex, ORE.LSST, 'LineStyle','-.','color',[0 0.5 0], 'linewidth', 2.5);
hold on;
plot(frameIndex, ORE.LDST, 'R',   'linewidth', 2.5);
xlabel('Frame Number','fontsize',18, 'fontweight','bold');
ylabel('Overlap Rate','fontsize',18, 'fontweight','bold');
% legend('NDL','L1','MTT','SCM','ASLAS','LSST','LDST');
legend('L1','MTT','SCM','ASLAS','LSST','LDST');
hold off;
set(gca, 'fontsize', 18, 'fontweight', 'bold', 'box', 'on');

%%6--Display Center Error Evaluation
figure(2);
% hold on;
% plot(frameIndex, CEE.NDL,   'B--', 'linewidth', 2.5); 
hold on; 
plot(frameIndex, CEE.L1,    'G--', 'linewidth', 2.5); 
% hold on;
% plot(frameIndex, CEE.PN,    'K--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.MTT,   'Y--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.SCM,   'M--', 'linewidth', 2.5); 
hold on;
plot(frameIndex, CEE.ASLAS,  'C--', 'linewidth', 2.5); 
hold on;
% plot(frameIndex, CEE.SRPCA, 'R',   'linewidth', 2.5);
plot(frameIndex, CEE.LSST,'LineStyle','-.','color',[0 0.5 0], 'linewidth', 2.5);
hold on;
plot(frameIndex, CEE.LDST, 'R',   'linewidth', 2.5); 
xlabel('Frame Number','fontsize',18, 'fontweight','bold');
ylabel('Center Error','fontsize',18, 'fontweight','bold');
% legend('NDL','L1','MTT','SCM','ASLAS','LSST','LDST');
legend('L1','MTT','SCM','ASLAS','LSST','LDST');
hold off;
set(gca, 'fontsize', 18, 'fontweight', 'bold', 'box', 'on');
%%
max_threshold = 50;  %used for graphs in the paper
% PRE.NDL=zeros(max_threshold,1);
PRE.L1 =zeros(max_threshold,1);
PRE.MTT=zeros(max_threshold,1);
PRE.SCM=zeros(max_threshold,1);
PRE.ASLAS=zeros(max_threshold,1);
PRE.LSST=zeros(max_threshold,1);
PRE.LDST=zeros(max_threshold,1);
for p=1:max_threshold
%     PRE.NDL(p)=nnz(CEE.NDL<=p)/numel(CEE.NDL);
    PRE.L1(p) =nnz(CEE.L1<=p)/numel(CEE.L1);
    PRE.MTT(p)=nnz(CEE.MTT<=p)/numel(CEE.MTT);
    PRE.SCM(p)=nnz(CEE.SCM<=p)/numel(CEE.SCM);
    PRE.ASLAS(p)=nnz(CEE.ASLAS<=p)/numel(CEE.ASLAS);
    PRE.LSST(p)=nnz(CEE.LSST<=p)/numel(CEE.LSST);
    PRE.LDST(p)=nnz(CEE.LDST<=p)/numel(CEE.LDST);
end
%%6--Display Center Error Precision
figure(4);
% hold on;
% plot(1:max_threshold, PRE.NDL,   'B--', 'linewidth', 2.5); 
hold on; 
plot(1:max_threshold, PRE.L1,    'G--', 'linewidth', 2.5); 
% hold on;
% plot(frameIndex, CEE.PN,    'K--', 'linewidth', 2.5); 
hold on;
plot(1:max_threshold, PRE.MTT,   'Y--', 'linewidth', 2.5); 
hold on;
plot(1:max_threshold, PRE.SCM,   'M--', 'linewidth', 2.5); 
hold on;
plot(1:max_threshold, PRE.ASLAS,  'C--', 'linewidth', 2.5); 
hold on;
% plot(frameIndex, CEE.SRPCA, 'R',   'linewidth', 2.5);
plot(1:max_threshold, PRE.LSST,'LineStyle','-.','color',[0 0.5 0], 'linewidth', 2.5);
hold on;
plot(1:max_threshold, PRE.LDST, 'R',   'linewidth', 2.5); 
xlabel('Location error threshold','fontsize',18, 'fontweight','bold');
ylabel('Precision','fontsize',18, 'fontweight','bold');
% legend('NDL','L1','MTT','SCM','ASLAS','LSST','LDST');
legend('L1','MTT','SCM','ASLAS','LSST','LDST');
hold off;
set(gca, 'fontsize', 18, 'fontweight', 'bold', 'box', 'on');