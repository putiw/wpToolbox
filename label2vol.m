
clearvars;close all;clc;
% roi from surf to vol

bidsDir = '/Volumes/Vision/MRI/recon-bank';
subDir = sprintf('%s/derivatives/freesurfer',bidsDir);

subject = 'sub-0248';
session = 'ses-01'; % which session has the t1w
roi = {'pMT_REmanual','pMST_REmanual','FST'};
hemi = {'l','r'};

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



for whichHemi = 1:numel(hemi)

    mylabels = [];
    for whichRoi = 1:numel(roi)
        whichLabel = sprintf('--label %s/%s/label/0localizer/%sh.%s.label',subDir,subject,hemi{whichHemi},roi{whichRoi});
        mylabels = [mylabels ' ' whichLabel];
    end

    T1w = sprintf('%s/rawdata/%s/%s/anat/%s_%s_T1w.nii.gz',bidsDir,subject,session,subject,session);
    niiLable = sprintf('%s/%s/label/0localizer/%sh.myROIs.nii.gz',subDir,subject,hemi{whichHemi});
    orig = sprintf('%s/%s/mri/orig.mgz',subDir,subject);
    cmd = sprintf('mri_label2vol%s --temp %s --o %s --subject %s --hemi %sh --proj frac 0 1 0.1 --fillthresh 0 --regheader %s', mylabels, T1w, niiLable, subject, hemi{whichHemi}, orig);
    system(cmd);

end

%%
roi = {'maybe.MST'};
hemi = {'l'};

for whichRoi = 1:numel(roi)

    for whichHemi = 1:numel(hemi)

        whichLabel = sprintf('%s/%s/label/0localizer/%sh.%s.label',subDir,subject,hemi{whichHemi},roi{whichRoi});
        T1w = sprintf('%s/rawdata/%s/%s/anat/%s_%s_T1w.nii.gz',bidsDir,subject,session,subject,session);
        niiLable = sprintf('%s/%s/label/0localizer/%sh.%s.nii.gz',subDir,subject,hemi{whichHemi},roi{whichRoi});
        orig = sprintf('%s/%s/mri/orig.mgz',subDir,subject);
        cmd = sprintf('mri_label2vol --label %s --temp %s --o %s --subject %s --hemi %sh --proj frac 0 1 0.1 --fillthresh 0 --regheader %s', whichLabel, T1w, niiLable, subject, hemi{whichHemi}, orig);
        system(cmd);
    end
end


