function [roi roil roir numl numr] = get_my_roi(subject,serverDir)


lcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'lh.curv'));
rcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'rh.curv'));
numl = numel(lcurv);
numr = numel(rcurv);

roi = cell(1,8);
roir = cell(1,8);
roil = cell(1,8);
try
    roil{1} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/lh.pMT_REmanual.label'));
    roir{1} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/rh.pMT_REmanual.label'));

    roil{2} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/lh.pMST_REmanual.label'));
    roir{2} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/rh.pMST_REmanual.label'));

    roil{4} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/lh.V1_REmanual.label'));
    roir{4} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/retinotopy_RE/rh.V1_REmanual.label'));

catch

end

try
roil{3} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/lh.FST.label'));
roir{3} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/rh.FST.label'));

roil{5} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/lh.func2D.label'));
roir{5} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/0localizer/rh.func2D.label'));
catch

end

roil{6} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/lh.MT.label'));
roir{6} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/rh.MT.label'));

roil{7} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/lh.MST.label'));
roir{7} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/rh.MST.label'));

roil{8} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/lh.FST.label'));
roir{8} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/rh.FST.label'));

%if no retinotipy v1 use glasser v1
if ~(numel(roir{4})+numel(roil{4}))
    roil{4} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/lh.V1.label'));
    roir{4} = read_ROIlabel(fullfile(serverDir,'/derivatives/freesurfer', subject,'label/Glasser2016/rh.V1.label'));
end


for ii = 1:8
    roi{ii} = [roil{ii}; numel(lcurv)+roir{ii}];
end

end