clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'CueIntegration2024';
bidsDir = '/Users/pw1246/Documents/MRI/CueIntegration2024';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath('/Users/pw1246/Documents/GitHub/wpToolbox'));
setup_user(projectName, bidsDir, '/Users/pw1246/Documents/GitHub', fsDir);

% Define subjects
subjects = {'0201','0230','0248','0250','0255','0306','0307','0373','0392','0395'};

for ii = 1:numel(subjects)
    subject = subjects{ii};
    fprintf('Processing subject %s...\n', subject);
    
    % Determine ROI sets based on subject groups
    if strcmp(subject, '0230')
        % Group 1: All ROIs from Glasser2016
        leftLabels = { fullfile('label', 'Glasser2016', 'lh.V1.label'), ...
                      fullfile('label', 'Glasser2016', 'lh.MT.label'), ...
                      fullfile('label', 'Glasser2016', 'lh.MST.label'), ...
                      fullfile('label', 'Glasser2016', 'lh.FST.label') };
        rightLabels = { fullfile('label', 'Glasser2016', 'rh.V1.label'), ...
                       fullfile('label', 'Glasser2016', 'rh.MT.label'), ...
                       fullfile('label', 'Glasser2016', 'rh.MST.label'), ...
                       fullfile('label', 'Glasser2016', 'rh.FST.label') };
    elseif ismember(subject, {'0306','0307','0373'})
        % Group 2: Use Glasser2016 for V1, MT, MST and 0localizer for FST
        leftLabels = { fullfile('label', 'Glasser2016', 'lh.V1.label'), ...
                      fullfile('label', 'Glasser2016', 'lh.MT.label'), ...
                      fullfile('label', 'Glasser2016', 'lh.MST.label'), ...
                      fullfile('label', '0localizer', 'lh.FST.label') };
        rightLabels = { fullfile('label', 'Glasser2016', 'rh.V1.label'), ...
                       fullfile('label', 'Glasser2016', 'rh.MT.label'), ...
                       fullfile('label', 'Glasser2016', 'rh.MST.label'), ...
                       fullfile('label', '0localizer', 'rh.FST.label') };
    else
        % Group 3: Following 0201 pattern
        leftLabels = { fullfile('label', 'retinotopy_RE', 'lh.V1_REmanual.label'), ...
                      fullfile('label', 'retinotopy_RE', 'lh.pMT_REmanual.label'), ...
                      fullfile('label', 'retinotopy_RE', 'lh.pMST_REmanual.label'), ...
                      fullfile('label', '0localizer', 'lh.FST.label') };
        rightLabels = { fullfile('label', 'retinotopy_RE', 'rh.V1_REmanual.label'), ...
                       fullfile('label', 'retinotopy_RE', 'rh.pMT_REmanual.label'), ...
                       fullfile('label', 'retinotopy_RE', 'rh.pMST_REmanual.label'), ...
                       fullfile('label', '0localizer', 'rh.FST.label') };
    end
    
    % Read curvature for surface size
    lcurv = read_curv(fullfile(bidsDir, 'derivatives', 'freesurfer', sprintf('sub-%s', subject), 'surf', 'lh.curv'));
    rcurv = read_curv(fullfile(bidsDir, 'derivatives', 'freesurfer', sprintf('sub-%s', subject), 'surf', 'rh.curv'));
    leftidx = 1:numel(lcurv);
    rightidx = (1:numel(rcurv))+numel(lcurv);
    
    % Initialize values array
    vals = zeros(numel(lcurv) + numel(rcurv), 1);
    
    % Process left hemisphere
    for roiIdx = 1:length(leftLabels)
        pialROI = read_ROIlabel(fullfile(bidsDir, 'derivatives', 'freesurfer', sprintf('sub-%s', subject), leftLabels{roiIdx}));
        vals(pialROI) = roiIdx;
    end
    
    % Process right hemisphere
    for roiIdx = 1:length(rightLabels)
        pialROI = read_ROIlabel(fullfile(bidsDir, 'derivatives', 'freesurfer', sprintf('sub-%s', subject), rightLabels{roiIdx}));
        vals(pialROI + numel(lcurv)) = roiIdx;
    end
    
    % Create MGZ structure
    mgz = MRIread(fullfile(bidsDir, 'derivatives', 'freesurfer', sprintf('sub-%s', subject), 'mri', 'orig.mgz'));
    mgz.vol = [];
    
    % Save left hemisphere
    mgz.vol = vals(leftidx);
    resultsdir = fullfile(bidsDir, 'derivatives', 'averageROI', sprintf('sub-%s', subject));
    mkdir(resultsdir);
    MRIwrite(mgz, fullfile(resultsdir, 'lh.rois.mgz'));
    
    % Save right hemisphere
    mgz.vol = vals(rightidx);
    MRIwrite(mgz, fullfile(resultsdir, 'rh.rois.mgz'));
end 