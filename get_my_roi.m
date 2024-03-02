function [roi roil roir] = get_my_roi(subject,serverDir)


lcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'lh.curv'));
roi = cell(1,5);
roir = cell(1,5);
roil = cell(1,5);
try
    roil{1} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/lh.pMT_REmanual.label'));
    roir{1} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/rh.pMT_REmanual.label'));

    roil{2} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/lh.pMST_REmanual.label'));
    roir{2} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/rh.pMST_REmanual.label'));

    roil{3} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/lh.FST.label'));
    roir{3} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/rh.FST.label'));

    roil{4} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/lh.V1_REmanual.label'));
    roir{4} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/rh.V1_REmanual.label'));

    roil{5} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/lh.func2D.label'));
    roir{5} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/rh.func2D.label'));
catch
    
    roil{3} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/lh.FST.label'));
    roir{3} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/rh.FST.label'));

    roil{5} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/lh.func2D.label'));
    roir{5} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/rh.func2D.label'));
end

for ii = 1:5
    roi{ii} = [roil{ii}; numel(lcurv)+roir{ii}];
end

end