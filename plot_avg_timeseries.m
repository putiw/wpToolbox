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
% valMat2d = zeros(163842,30,numel(subjects));
% valMat3d = zeros(163842,20,numel(subjects));
% for whichSub = 1:numel(subjects)
%     subject = subjects{whichSub};
%     tmp = load(sprintf('%s/derivatives/motion_base/%s/rh.datafiles.mat',serverDir,subject));
%     valMat2d(:,:,whichSub) = tmp.boldavg;
%     tmp = load(sprintf('%s/derivatives/cd/%s/rh.datafiles.mat',serverDir,subject));
%     valMat3d(:,:,whichSub) = tmp.boldavg;
% end
load('/Users/pw1246/Desktop/boldAvgClean2d.mat');
load('/Users/pw1246/Desktop/boldAvgClean3d.mat');
meanVal2d = mean(valMat2d,3);
meanVal3d = mean(valMat3d,3);

%% make each frame

whichData = meanVal3d;
bins = [-max(prctile(meanVal3d,99.9)):0.01:max(prctile(meanVal3d,99.9))];
%bins = [-1:0.02:1];
cmaps = cmaplookup(bins,min(bins),max(bins),[],cmapsign4);

drawme3 = cell(1,size(whichData,2)); % 1-1000/2000 6-330/992
for iF = 1:size(whichData,2) 
  vals = nan(327684,1);
  vals(163843:end) = whichData(:,iF);  
 %[~,~,rgbimg] =cvnlookup('fsaverage',13,vals,[min(bins) max(bins)],cmaps,[],[],0,{'overlayalpha',abs(vals)>=0.05,'rgbnan',1});
  [~,~,rgbimg] =cvnlookup('fsaverage',6,vals,[min(bins) max(bins)],cmaps,[],[],0,{'overlayalpha',abs(vals)>=max(prctile(meanVal3d,90)),'rgbnan',0});

%rgbimg(mean(rgbimg,3)-1<0.001)=0;
drawme3{iF}=rgbimg;
end
%% draw per frame
filename = ['/Users/pw1246/Desktop/3D.gif'];
whichData = meanVal3d;

% Prepare the figure
fig1 = figure(1);
clf;
set(fig1, 'Position', [100, 100, 640, 480]); % Adjust as necessary

% Loop through your data
for iF = 1:size(whichData, 2)
    imshow(drawme3{iF});
    drawnow;
    pause(0.2); % Adjust the pause as necessary

    % Capture the current figure frame
    frame = getframe(fig1);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);

    % Determine the midpoint (to crop the right half)
    midPoint = size(im, 2) / 2;
    
    % Crop the right half of the image
    croppedImind = imind(:, midPoint:end);

    % Save each frame to the GIF
    if iF == 1
        imwrite(croppedImind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.2500);
    else
        imwrite(croppedImind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.2500);
    end
end
%% 2D

whichData = meanVal2d;
bins = [-max(prctile(meanVal2d,99.9)):0.01:max(prctile(meanVal2d,99.9))];
%bins = [-1:0.02:1];
cmaps = cmaplookup(bins,min(bins),max(bins),[],cmapsign4);

drawme2 = cell(1,size(whichData,2)); % 1-1000/2000 6-330/992
for iF = 1:size(whichData,2) 
  vals = nan(327684,1);
  vals(163843:end) = whichData(:,iF);  
 %[~,~,rgbimg] =cvnlookup('fsaverage',13,vals,[min(bins) max(bins)],cmaps,[],[],0,{'overlayalpha',abs(vals)>=0.05,'rgbnan',1});
  [~,~,rgbimg] =cvnlookup('fsaverage',6,vals,[min(bins) max(bins)],cmaps,[],[],0,{'overlayalpha',vals>=max(prctile(meanVal2d,90)),'rgbnan',0});

%rgbimg(mean(rgbimg,3)==1)=1;
drawme2{iF}=rgbimg;
end
%% draw per frame
% Define the GIF file path
filename = ['/Users/pw1246/Desktop/2D.gif'];
whichData = meanVal2d;

% Prepare the figure
fig2 = figure(2);
clf;
set(fig2, 'Position', [100, 100, 640, 480]); % Adjust as necessary

% Loop through your data
for iF = 1:size(whichData, 2)

    imshow(drawme2{iF});
  
    drawnow;
    %pause(0.2); % Adjust the pause as necessary

    % Capture the current figure frame
    frame = getframe(fig2);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);

    % Determine the midpoint (to crop the right half)
    midPoint = size(im, 2) / 2;
    
    % Crop the right half of the image
    croppedImind = imind(:, midPoint:end);

    % Save each frame to the GIF
    if iF == 1
        imwrite(croppedImind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.33);
    else
        imwrite(croppedImind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.33);
    end
end
%% draw per frame 2D zoom
% Define the GIF file path
filename = ['/Users/pw1246/Desktop/2Dzoom.gif'];
whichData = meanVal2d;

% Prepare the figure
fig2 = figure(2);
clf;
 set(fig2, 'Position', [50, 800, 750, 500]); % Adjust as necessary

% Loop through your data
for iF = 1:size(whichData, 2)

    tmp = drawme2{iF}(:,round(size(drawme2{iF},2)/2)+5:end,:);
    tmp = tmp(round(size(tmp,1)/3):round(size(tmp,1)/3*2),:,:);
    tmp = tmp(:,1:round(size(tmp,2)/3),:);
    imshow(tmp);
    axis off;
    set(gcf, 'Color', 'black');
    drawnow;
    %pause(0.2); % Adjust the pause as necessary

    % Capture the current figure frame
    frame = getframe(fig2);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);


    % Save each frame to the GIF
    if iF == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.33);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.33);
    end
end
