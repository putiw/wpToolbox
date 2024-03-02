subject = 'sub-0255';
%roi = {'pMT_REmanual','pMST_REmanual','func2D','FST'};
roi = {'func2D','FST'};

hemi = {'l','r'};
cmd = [];
for whichRoi = 1:numel(roi)
    if contains(roi{whichRoi},'REmanual')
        subDir = '/Volumes/Vision/UsersShare/Rania/Project_dg/data_bids/derivatives/freesurfer';
        labelFolder = 'retinotopy_RE';
    else
        subDir = '/Volumes/Vision/MRI/recon-bank/derivatives/freesurfer';
        labelFolder = '0localizer';
    end
    for whichHemi = 1:numel(hemi)
    cmd = sprintf('%s --label %s/%s/label/%s/%sh.%s.label',cmd,subDir,subject,labelFolder,hemi{whichHemi},roi{whichRoi});
    end
end
    setenv('SUBJECTS_DIR', subDir);
    T1 = sprintf('%s/%s/mri/T1.mgz',subDir,subject);
    cmd = sprintf('freeview -v %s%s &',T1,cmd);
    system(cmd)

