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

%%
valMat2d = cell(1,numel(subjects));
valMat3d = cell(1,numel(subjects));
for whichSub = 1:numel(subjects)
    subject = subjects{whichSub};
    tmp = load(sprintf('%s/derivatives/motion_base/%s/rh.raw.mat',serverDir,subject));
    valMat2d{whichSub} = tmp.boldnative;
    tmp = load(sprintf('%s/derivatives/cd/%s/rh.raw.mat',serverDir,subject));
    valMat3d{whichSub} = tmp.boldnative;
end
% meanVal2d = mean(valMat2d,3);
% meanVal3d = mean(valMat3d,3);
%%
figure(1);clf;hold on;
for whichSub = 1:numel(subjects)
[roi, roil, roir] = get_my_roi(subjects{whichSub},serverDir);
plot(1:30,mean(valMat2d{whichSub}(roir{5},:)),'Color',[0 133/255 225/225],'LineWidth',2);
%plot(1:30,mean(valMat2d{whichSub}(roir{3},:)),'r','LineWidth',2);
drawnow
end
ylim([-1.1 1.1])
set(gcf, 'Color', 'w')
set(gca, 'Color', 'k', 'XColor', 'k', 'YColor', 'k'); % 'k' for black, 'w' for white axes

figure(2);clf;hold on;
for whichSub = 2%:numel(subjects)
[roi, roil, roir] = get_my_roi(subjects{whichSub},serverDir);
plot(1:20,mean(valMat3d{whichSub}(roir{5},:)),'b','LineWidth',2);
plot(1:20,mean(valMat3d{whichSub}(roir{3},:)),'r','LineWidth',2);
drawnow
end
ylim([-1.1 1.1])
set(gcf, 'Color', 'w')
set(gca, 'Color', 'k', 'XColor', 'k', 'YColor', 'k'); % 'k' for black, 'w' for white axes
%axis off;
% box on;