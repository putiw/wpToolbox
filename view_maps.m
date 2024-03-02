%% define path
clearvars; clc; close all;
subject = 'sub-0392';
bidsDir = '/Volumes/Vision/MRI/recon-bank';
view_fv(subject,bidsDir,'T1MapMyelin/myelin0.1','oppo3');
%%
%view_fv(subject,bidsDir,'loc_old/motioncenter','loc_old/motionright','loc_old/motionleft');
view_fv(subject,bidsDir,'mt+2','cd/cd','T1MapMyelin/myelin0.5');
%view_fv(subject,bidsDir,'l','mt+2','cd/cd','oppo3','T1MapMyelin/myelin0.5');

%%
%%
view_fv(subject,bidsDir,'mt+2')
view_fv(subject,bidsDir,'mt+2','cd','oppo3','prfvista_mov/vexpl','prfvista_mov/eccen','prfvista_mov/angle_adj','prfvista_mov/sigma','T1MapMyelin/myelin0.1');

%%
% view_fv_roi(subject,bidsDir,'mt+2','cd')
% view_fv(subject,bidsDir,'l','hand','mt+2');
view_fv(subject,bidsDir,'l','mstl','lower','upper','mt+2','prfvista_mov/eccen');
view_fv(subject,bidsDir,'r','mstr','lower','upper','mt+2','prfvista_mov/eccen');
%view_fv(subject,bidsDir,'mt','mstl','mstr');
view_fv(subject,bidsDir,'r','mt+2','cd','oppo3','T1MapMyelin/myelin0.5');
%view_fv(subject,bidsDir,'cd2','cd3');
view_fv(subject,bidsDir,'mt+2','cd','oppo3','prfvista_mov/vexpl','prfvista_mov/eccen','prfvista_mov/angle_adj','prfvista_mov/sigma','T1MapMyelin/myelin0.5');
%view_fv('sub-0392',bidsDir,'mt+2','cd3');
%view_fv(subject,bidsDir,'cd2_1run','cd2_2run','cd3_1run','cd3_2run','cd3_3run','cd3_4run')
%%
view_fv('sub-0426',bidsDir,'mt+2','cd2');
%bidsDir = '~/Documents/MRI/bigbids';
view_fv('fsaverage',bidsDir,'prfvista_mov/eccen.sub-avg','prfvista_mov/angle_adj.sub-avg','prfvista_mov/sigma.sub-avg');

%view_fv('fsaverage',bidsDir,'myelin/MyelinMap_BCpercentile.sub-avg:myelin2');
% %%
view_fv(subject,bidsDir,'mt+2','cd2','motion_meridian/upper','motion_meridian/lower','prfvista_mov/eccen','prfvista_mov/angle_adj','T1MapMyelin/myelin0.1','T1MapMyelin/vmyelin0.1')

%%
bidsDir = '/Users/pw1246/Documents/MRI/bigbids';
hh = view_fv('sub-0201',bidsDir,'mt+2','oppo3','cd3','T1MapMyelin/myelin0.1','prfvista_mov/eccen','prfvista_mov/angle_adj')
view_fv('sub-0426',bidsDir,'prfvista_mov/eccen','prfvista_mov/angle_adj');
view_fv('sub-0037',bidsDir,'l','mt+2','cd3')
view_fv('sub-0201',bidsDir,'mt+2','cd2','oppo3','prfvista_mov/eccen','prfvista_mov/angle_adj','myelin/MyelinMap_BCpercentile:myelin2');
view_fv('sub-0037',bidsDir,'cd2','cd2_1run','cd2_2run','cd2_3run','cd2_4run');
%%
% view_fv(subject,bidsDir,'mt+2','cd2','oppo3','prfvista_mov/sigma','prfvista_mov/eccen','prfvista_mov/angle_adj','myelin/SmoothedMyelinMap_BC')
% 
% %% number of runs for cd
% view_fv('sub-0248','/Volumes/Vision/MRI/recon-bank','l','cd2_10run','cd2_9run','cd2_8run','cd2_7run','cd2_6run','cd2_5run','cd2_4run','cd2_3run','cd2_2run','cd2_1run')
% view_fv('sub-0248','/Volumes/Vision/MRI/recon-bank','cd2_10run','mt+2','cd2')
% %% tmp
% view_fv('sub-0037',bidsDir,'l','mt+2','cd2','oppo3','prfvista_mov/eccen','prfvista_mov/angle_adj','myelin/SmoothedMyelinMap_BC')
% view_fv('sub-0255',bidsDir,'mt+2','cd2')
% view_fv(subject,bidsDir,'mt+2','cd2','oppo3','prfvista_mov/eccen','prfvista_mov/angle_adj','myelin/SmoothedMyelinMap_BC');
% 
% %% compare 2D vs 3D 
% view_fv(subject,bidsDir,'mt+2','cd2');
% % view_fv(sub,bidsDir,'mt+12','cdavg');
% 
% %% compare four different motion condition 
% view_fv(subject,bidsDir,'out','in','cw','ccw');
% 
% %% compare upper and lower meridian
% view_fv(subject,bidsDir,'upper','lower','mt+2');
% 
% %% compare new and old mt+ localizer 
% view_fv(subject,bidsDir,'mt+1','mt+2');
% 
% %% compare new and old cd 
% view_fv(subject,bidsDir,'cd1','cd2');
% 
% %% compare new and old transparent motion 
% view_fv(subjectDir,resultsDir,'oppo2','oppo3');
% 
% %% compare transparent motion vs. 3D motion 
% view_fv(subject,bidsDir,'oppo3','cd2');
% % view_fv(sub,bidsDir,'oppo3','cdavg');
% 
% %% myelin map 
% view_fv(subject,bidsDir,'myelin/SmoothedMyelinMap_BC','motion_base/mt+2');
% %view_fv(sub,bidsDir,'SmoothedMyelinMap','mt+2');
% %view_fv(sub,bidsDir,'MyelinMap_BC','mt+2');
% %view_fv(sub,bidsDir,'MyelinMap','mt+2');
% 
% %% prf
% %view_fv(subject,bidsDir,'angle_adj','eccen','sigma');
% cmd = view_fv(subject,bidsDir,'prfvista_mov/eccen');
% %% compare how many runs to use
% view_fv(subject,bidsDir,'run4','run3','run2','run1'); % which runs
% view_fv(subject,bidsDir,'4run','3run','2run','run1'); % how many runs
% 
% %% hand vs. mt+
% view_fv(subject,bidsDir,'hand','mt+2');
