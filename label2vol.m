
clearvars;close all;clc;
% roi from surf to vol

bidsDir = {'/Volumes/Vision/MRI/recon-bank','/Volumes/Vision/UsersShare/Rania/Project_dg/data_bids'};
labelDir = {'0localizer','retinotopy_RE'};
subject = 'sub-0426';
session = 'ses-01'; % which session has the t1w
roi = {'pMT_REmanual','pMST_REmanual','FST'};
roi = {'func2D','FST'};
whichlabelDir = [1 1];
hemi = {'l','r'};

for whichHemi = 1:numel(hemi)

    mylabels = [];
    for whichRoi = 1:numel(roi)
        subDir = sprintf('%s/derivatives/freesurfer',bidsDir{whichlabelDir(whichRoi)});
        labelPath = sprintf('%s/%s/label/%s/%sh.%s.label',subDir,subject,labelDir{whichlabelDir(whichRoi)},hemi{whichHemi},roi{whichRoi});
        whichLabel = sprintf('--label %s',labelPath);
        mylabels = [mylabels ' ' whichLabel];
    end
    subDir = sprintf('%s/derivatives/freesurfer',bidsDir{1});
    setenv('SUBJECTS_DIR', subDir);

    T1w = sprintf('%s/rawdata/%s/%s/anat/%s_%s_T1w.nii.gz',bidsDir{1},subject,session,subject,session);
    %T1w = sprintf('%s/%s/mri/T1.mgz',subDir,subject);

    niiLable = sprintf('%s/%s/label/0localizer/%sh.rois_vol.nii.gz',subDir,subject,hemi{whichHemi});
    %niiLable = sprintf('%s/%s/label/0localizer/%sh.rois_vol.mgh',subDir,subject,hemi{whichHemi});
    orig = sprintf('%s/%s/mri/orig.mgz',subDir,subject);
    cmd = sprintf('mri_label2vol%s --temp %s --o %s --subject %s --hemi %sh --proj frac 0 1 0.1 --fillthresh 0 --regheader %s', mylabels, T1w, niiLable, subject, hemi{whichHemi}, orig);
    system(cmd);
end

% %%
% roi = {'maybe.MST'};
% hemi = {'l'};
% 
% for whichRoi = 1:numel(roi)
% 
%     for whichHemi = 1:numel(hemi)
% 
%         whichLabel = sprintf('%s/%s/label/0localizer/%sh.%s.label',subDir,subject,hemi{whichHemi},roi{whichRoi});
%         T1w = sprintf('%s/rawdata/%s/%s/anat/%s_%s_T1w.nii.gz',bidsDir,subject,session,subject,session);
%         niiLable = sprintf('%s/%s/label/0localizer/%sh.%s.nii.gz',subDir,subject,hemi{whichHemi},roi{whichRoi});
%         orig = sprintf('%s/%s/mri/orig.mgz',subDir,subject);
%         cmd = sprintf('mri_label2vol --label %s --temp %s --o %s --subject %s --hemi %sh --proj frac 0 1 0.1 --fillthresh 0 --regheader %s', whichLabel, T1w, niiLable, subject, hemi{whichHemi}, orig);
%         system(cmd);
%     end
% end
% 
% 