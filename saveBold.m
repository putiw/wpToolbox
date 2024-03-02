% this script loads a subject's functional data and average across runs and
% repeats
% saves the averaged timeseries in fsnative and fsaverage space in
% derivatives 
% as of feb 25th only do it for lh for the figure

clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '~/Desktop/MRI/FSTloc';
serverDir = '/Volumes/Vision/MRI/recon-bank';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,serverDir,githubDir,fsDir);

subjects = {'sub-0037','sub-0201','sub-0248','sub-0250','sub-0255','sub-0392','sub-0395','sub-0397','sub-0426'};
%subjects = {'sub-0250','sub-0255','sub-0392','sub-0395','sub-0397','sub-0426'};

%%
for whichSub = 1:numel(subjects)
    subject = subjects{whichSub}
    space = 'fsnative';
    whichTask = 'motion';
    whichVersion = 2;
    dataLog = readtable([serverDir '/code/dataLog.xlsx']);
    matchingRows = dataLog(strcmp(dataLog.subject, subject) & strcmp(dataLog.task, whichTask) & (dataLog.version==whichVersion), :);
    datafiles = load_dataLog(matchingRows,space);
    data1 = mean(cat(3, datafiles{1:2}),3);

    if ismember(subject,{'sub-0392'})
        motion = data1(:,1:300);
    else
        motion = data1(:,1:360);
    end

    motion =(motion - mean(motion,2))./ mean(motion,2) * 100;
    dur1 = 30;
    boldnativeAll = mean(reshape(motion,size(motion,1),dur1,size(motion,2)/dur1),3);
    lcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'lh.curv'));
    boldnative = boldnativeAll(1:numel(lcurv),:);
    save(sprintf('%s/derivatives/motion_base/%s/lh.raw.mat',serverDir,subject), 'boldnative');
    boldnative = boldnativeAll(numel(lcurv)+1:end,:);
    save(sprintf('%s/derivatives/motion_base/%s/rh.raw.mat',serverDir,subject), 'boldnative');

    %%
    whichTask = 'cd';
    if ismember(subject,{'sub-0250','sub-0255','sub-0392','sub-0395','sub-0426'})
        whichVersion = 2;
    else
        whichVersion = 3;
    end

    dataLog = readtable([serverDir '/code/dataLog.xlsx']);
    matchingRows = dataLog(strcmp(dataLog.subject, subject) & strcmp(dataLog.task, whichTask) & (dataLog.version==whichVersion), :);
    datafiles = load_dataLog(matchingRows,space);
    data2 = mean(cat(3, datafiles{:}),3);
    cd = data2(:,1:300);
    cd =(cd - mean(cd,2))./ mean(cd,2) * 100;
    dur2 = 20;
    boldnativeAll = mean(reshape(cd,size(cd,1),dur2,size(cd,2)/dur2),3);
    boldnative = boldnativeAll(1:numel(lcurv),:);
    save(sprintf('%s/derivatives/cd/%s/lh.raw.mat',serverDir,subject), 'boldnative');
    boldnative = boldnativeAll(numel(lcurv)+1:end,:);
    save(sprintf('%s/derivatives/cd/%s/rh.raw.mat',serverDir,subject), 'boldnative');
end
%%


% %%
% space = 'fsnative';
% whichTask = 'motion';
% whichVersion = 2;
% dataLog = readtable([serverDir '/code/dataLog.xlsx']);
% matchingRows = dataLog(strcmp(dataLog.subject, subject) & strcmp(dataLog.task, whichTask) & (dataLog.version==whichVersion), :);
% datafiles = load_dataLog(matchingRows,space);
% [dsm, ds1, myNoise] = load_dsm(matchingRows);
% [data1, betas, R2] = get_beta(datafiles,dsm,myNoise);
% data1 = mean(cat(3, data1{:}),3);
% motion = data1(:,1:360);
% %motion = data1(:,1:300);
% dur1 = 30;
% boldnativeAll = mean(reshape(motion,size(motion,1),dur1,size(motion,2)/dur1),3);
% lcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'lh.curv'));
% boldnative = boldnativeAll(1:numel(lcurv),:);
% boldavg = cvntransfertosubject(subject,'fsaverage', boldnative, 'lh', 'nearest', 'orig', 'orig');
% save(sprintf('%s/derivatives/motion_base/%s/lh.datafiles.mat',serverDir,subject), 'boldnative', 'boldavg');
% boldnative = boldnativeAll(numel(lcurv)+1:end,:);
% boldavg = cvntransfertosubject(subject,'fsaverage', boldnative, 'rh', 'nearest', 'orig', 'orig');
% save(sprintf('%s/derivatives/motion_base/%s/rh.datafiles.mat',serverDir,subject), 'boldnative', 'boldavg');
%
% %%
% whichTask = 'cd';
% whichVersion = 2;
% dataLog = readtable([serverDir '/code/dataLog.xlsx']);
% matchingRows = dataLog(strcmp(dataLog.subject, subject) & strcmp(dataLog.task, whichTask) & (dataLog.version==whichVersion), :);
% datafiles = load_dataLog(matchingRows,space);
% [dsm, ds1, myNoise] = load_dsm(matchingRows);
% [data2, betas, R2] = get_beta(datafiles,dsm,myNoise);
% data2 = mean(cat(3, data2{:}),3);
% cd = data2(:,1:300);
% dur2 = 20;
% boldnativeAll = mean(reshape(cd,size(cd,1),dur2,size(cd,2)/dur2),3);
% boldnative = boldnativeAll(1:numel(lcurv),:);
% boldavg = cvntransfertosubject(subject,'fsaverage', boldnative, 'lh', 'nearest', 'orig', 'orig');
% save(sprintf('%s/derivatives/cd/%s/lh.datafiles.mat',serverDir,subject), 'boldnative', 'boldavg');
% boldnative = boldnativeAll(numel(lcurv)+1:end,:);
% boldavg = cvntransfertosubject(subject,'fsaverage', boldnative, 'rh', 'nearest', 'orig', 'orig');
% save(sprintf('%s/derivatives/cd/%s/rh.datafiles.mat',serverDir,subject), 'boldnative', 'boldavg');
