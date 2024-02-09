clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '/Volumes/Vision/MRI/recon-bank';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,bidsDir,githubDir,fsDir);
if ~isfolder(bidsDir)
system(['open smb://pw1246@it-nfs.abudhabi.nyu.edu/Vision']);
pause(5)
end
dataLog = readtable([bidsDir '/code/dataLog.xlsx']);

subject = 'sub-0037';
space = 'fsnative';

%%
[tmpl, ~, ~] = cvnroimask('fsaverage','lh','tmpFST',[],[]);
[tmpr,~,~] = cvnroimask('fsaverage','rh','tmpFST',[],[]);
tmpFST = [tmpl{:};tmpr{:}];
roimask = get_roi(subject,'Glasser2016',{'V4t'});

%%
figure(2);
hold on
whichTask = 'cd';
whichVersion = 3;
matchingRows = dataLog(strcmp(dataLog.subject, subject) & strcmp(dataLog.task, whichTask) & (dataLog.version==whichVersion), :);
datafiles = load_dataLog(matchingRows,space);
[dsm, ds1, ds2, myNoise] = load_dsm(matchingRows);
[data, betas, R2] = get_beta(datafiles,dsm,myNoise);
showtimeseries(data,ds2,roimask{1},1)
%%
whichTask = 'motion';
whichVersion = 2;
matchingRows = dataLog(strcmp(dataLog.subject, subject) & strcmp(dataLog.task, whichTask) & (dataLog.version==whichVersion), :);
datafiles = load_dataLog(matchingRows,space);
[dsm, ds1, ds2, myNoise] = load_dsm(matchingRows);
[data, betas, R2] = get_beta(datafiles,dsm,myNoise);
showtimeseries(data,ds2,roimask{1},[1 2 3 4])
%%