clear all; close all; clc;
projectName = 'CueIntegration2023';
bidsDir = '~/Desktop/MRI/CueIntegration2023';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.2.0';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,bidsDir,githubDir,fsDir);
%% 3D motion
tmpPath = '/Volumes/Vision/MRI/DecodingPublic/derivatives/resultMat/';
sub = {'0201','0202','0204','0205','0206','0228','0229','0248','0903'};
con = {'0102','0304'};
param.roiSpace = 'fsaverage';
bins = [0.125:0.01:0.3];
cmaps = cmaplookup(bins,min(bins),max(bins),[],cmapsign4);
for subject = 1:length(sub)
    for condition = 1:2
        close all
        load([tmpPath 'sub-' sub{subject} '_ses-' con{condition} '_searchlight_fsaverage6.mat']);
        ll = cvntransfertosubject('fsaverage6','fsaverage', acc(1:40962,1), 'lh', 'nearest', 'orig', 'orig');
        rr = cvntransfertosubject('fsaverage6','fsaverage', acc(40963:end,1), 'rh', 'nearest', 'orig', 'orig');
        val = [ll;rr];
        whichAlpha = val >= min(bins);
        cvnlookup(param.roiSpace,13,val,[min(bins) max(bins)],cmaps,[],[],1,{'overlayalpha',whichAlpha,'roiname',{'V1@Glasser2016','MT@Glasser2016','MST@Glasser2016','FST@Glasser2016','V7@Glasser2016','V3A@Glasser2016','FEF@Glasser2016'},'roicolor',{'g'},'drawroinames',0,'roiwidth',{1},'fontsize',20})
        
        hold on
        hcb=colorbar('SouthOutside');
        colormap(cmaps);
        hcb.Ticks = [min(hcb.Ticks) median(hcb.Ticks) max(hcb.Ticks)];
        hcb.TickLabels = {num2str(min(bins)),num2str(min(bins)+range(bins)./2),num2str(max(bins))};
        hcb.FontSize = 25;
        hcb.TickLength = 0.001;
        title(['sub-' sub{subject} ' searchlight decoding accuracy'])
        set(gcf, 'PaperOrientation', 'landscape');
        saveDir = ['/Users/pw1246/RVL Dropbox/Puti Wen/3D motion pilots/sub-' sub{subject} '/ses-3Dmotion'];
        if ~exist(saveDir, 'dir')
            mkdir(saveDir);
        end
        if condition == 1
            fileName = ['sub-' sub{subject} '-ses-horizontal.pdf'];
        else
            fileName = ['sub-' sub{subject} '-ses-vertical.pdf'];
        end
        print(fullfile(saveDir, fileName), '-dpdf', '-bestfit');
    end
end

%% Cue integration
close all
sub = {'0201','0230','0248','0255','0306','0307','0373'};
subject = 3;
tmpPath = '/Users/pw1246/Desktop/MRI/CueIntegration2023/derivatives/GLMsingle/sub-0201/ses-01/fsaverage/TYPED_FITHRF_GLMDENOISE_RR.mat';
tmpPath = '/Users/pw1246/Desktop/MRI/CueIntegration2023/derivatives/GLMsingle/sub-0201/ses-01/fsaverage/TYPEC_FITHRF_GLMDENOISE.mat';
tmpPath = '/Users/pw1246/Desktop/MRI/CueIntegration2023/derivatives/GLMsingle/sub-0248/ses-02/TYPEC_FITHRF_GLMDENOISE.mat';
load(tmpPath);
param.roiSpace = 'fsaverage';
param.roiSpace = ['sub-' sub{subject}];
bins = prctile(R2,80):0.01:prctile(R2,99);
cmaps = cmaplookup(bins,min(bins),max(bins),[],cmapsign4);
LregFile = '/Users/pw1246/Desktop/MRI/CueIntegration2023/derivatives/freesurfer/sub-0248/surf/lh.orig';
[~, b] = freesurfer_read_surf_kj(LregFile);
size(b,1)
         ll = cvntransfertosubject(param.roiSpace,'fsaverage', acc(1:40962,1), 'lh', 'nearest', 'orig', 'orig');
         rr = cvntransfertosubject(param.roiSpace,'fsaverage', acc(40963:end,1), 'rh', 'nearest', 'orig', 'orig');
         val = [ll;rr];
val = R2;
whichAlpha = val >= min(bins);
cvnlookup(param.roiSpace,13,val,[min(bins) max(bins)],cmaps,[],[],1,{'overlayalpha',whichAlpha,'roiname',{'V1@Glasser2016','MT@Glasser2016','MST@Glasser2016','FST@Glasser2016','V7@Glasser2016','V3A@Glasser2016','FEF@Glasser2016'},'roicolor',{'g'},'drawroinames',0,'roiwidth',{1},'fontsize',20})

hold on
hcb=colorbar('SouthOutside');
colormap(cmaps);
hcb.Ticks = [min(hcb.Ticks) median(hcb.Ticks) max(hcb.Ticks)];
hcb.TickLabels = {num2str(min(bins)),num2str(min(bins)+range(bins)./2),num2str(max(bins))};
hcb.FontSize = 25;
hcb.TickLength = 0.001;
title(['sub-' sub{subject} ' single trial R2'])

%%
tmpPath = '/Volumes/Vision/MRI/DecodingPublic/derivatives/resultMat/';
sub = {'0201','0230','0248','0255','0306','0307','0373'};
param.roiSpace = 'fsaverage';
bins = [0.125:0.01:0.3];
cmaps = cmaplookup(bins,min(bins),max(bins),[],cmapsign4);
for subject = 1:length(sub)
        close all
        load([tmpPath 'sub-' sub{subject} '_ses-' con{condition} '_searchlight_fsaverage6.mat']);
        ll = cvntransfertosubject('fsaverage6','fsaverage', acc(1:40962,1), 'lh', 'nearest', 'orig', 'orig');
        rr = cvntransfertosubject('fsaverage6','fsaverage', acc(40963:end,1), 'rh', 'nearest', 'orig', 'orig');
        val = [ll;rr];
        whichAlpha = val >= min(bins);
        cvnlookup(param.roiSpace,13,val,[min(bins) max(bins)],cmaps,[],[],1,{'overlayalpha',whichAlpha,'roiname',{'V1@Glasser2016','MT@Glasser2016','MST@Glasser2016','FST@Glasser2016','V7@Glasser2016','V3A@Glasser2016','FEF@Glasser2016'},'roicolor',{'g'},'drawroinames',0,'roiwidth',{1},'fontsize',20})
        
        hold on
        hcb=colorbar('SouthOutside');
        colormap(cmaps);
        hcb.Ticks = [min(hcb.Ticks) median(hcb.Ticks) max(hcb.Ticks)];
        hcb.TickLabels = {num2str(min(bins)),num2str(min(bins)+range(bins)./2),num2str(max(bins))};
        hcb.FontSize = 25;
        hcb.TickLength = 0.001;
        title(['sub-' sub{subject} ' searchlight decoding accuracy'])
        set(gcf, 'PaperOrientation', 'landscape');
        saveDir = ['/Users/pw1246/RVL Dropbox/Puti Wen/3D motion pilots/sub-' sub{subject} '/ses-3Dmotion'];
        if ~exist(saveDir, 'dir')
            mkdir(saveDir);
        end
        if condition == 1
            fileName = ['sub-' sub{subject} '-ses-horizontal.pdf'];
        else
            fileName = ['sub-' sub{subject} '-ses-vertical.pdf'];
        end
        print(fullfile(saveDir, fileName), '-dpdf', '-bestfit');
    
end

%%
param.roiSpace = 'fsaverage';
bins = [0.1:0.01:0.25];
cmaps = cmaplookup(bins,min(bins),max(bins),[],cmapsign4);
aa = meanAcc(:,:,1)';
 ll = cvntransfertosubject('fsaverage6','fsaverage', aa(1:40962,1), 'lh', 'nearest', 'orig', 'orig');
        rr = cvntransfertosubject('fsaverage6','fsaverage', aa(40963:end,1), 'rh', 'nearest', 'orig', 'orig');
        val = [ll;rr];
        whichAlpha = val >= min(bins);
        cvnlookup(param.roiSpace,13,val,[min(bins) max(bins)],cmaps,[],[],1,{'overlayalpha',whichAlpha,'roiname',{'V1@Glasser2016','MT@Glasser2016','MST@Glasser2016','FST@Glasser2016','V7@Glasser2016','V3A@Glasser2016','FEF@Glasser2016'},'roicolor',{'g'},'drawroinames',0,'roiwidth',{1},'fontsize',20})
%%
path = '/Users/pw1246/RVL Dropbox/Puti Wen/pw1246/Home/Decoding/motion/maps/l.H_V.mgz';
ok = gifti(fullfile(path));
ok = cvntransfertosubject('fsaverage6','fsaverage', double(ok.cdata), 'lh', 'nearest', 'orig', 'orig');
%%
param.roiSpace = 'fsaverage';
bins = [0.03:0.005:0.06];
cmaps = cmaplookup(bins,min(bins),max(bins),[],hot); %cmapsign4
val = ok;
        whichAlpha = val >= min(bins);
        cvnlookup(param.roiSpace,13,val,[min(bins) max(bins)],cmaps,[],[],1,{'overlayalpha',whichAlpha,'roiname',{'V1@Glasser2016','MT@Glasser2016','MST@Glasser2016','FST@Glasser2016','V7@Glasser2016','V3A@Glasser2016','FEF@Glasser2016'},'roicolor',{'g'},'drawroinames',0,'roiwidth',{1},'fontsize',20})
