%% Define subject list and select one subject at a time
subjects = {'0201','0230','0248','0250','0255','0306','0307','0373','0392','0395'};
whichSub = 1;  % change this index to select the desired subject
subject  = subjects{whichSub};

%% Define shared parameters
baseDir      = '/Users/pw1246/Documents/MRI/CueIntegration2024/derivatives';
fsDir        = fullfile(baseDir, 'freesurfer', sprintf('sub-%s', subject));
freeviewPath = '/Applications/freesurfer/7.4.1/bin/freeview';

%% Determine ROI sets based on subject groups
% Group 1: Subject 0230 uses Glasser2016 for all ROIs (symmetric)
% Group 2: Subjects 0306, 0307, 0373 use Glasser2016 for V1, MT, MST and 0localizer for FST (symmetric)
% Group 3: All other subjects (e.g., 0201, 0248, 0250, 0255, 0392, 0395) follow the 0201 pattern

if strcmp(subject, '0230')
    % Group 1: All ROIs from Glasser2016
    leftLabels = { fullfile(fsDir, 'label', 'Glasser2016', 'lh.V1.label'), ...
                   fullfile(fsDir, 'label', 'Glasser2016', 'lh.MT.label'), ...
                   fullfile(fsDir, 'label', 'Glasser2016', 'lh.MST.label'), ...
                   fullfile(fsDir, 'label', 'Glasser2016', 'lh.FST.label') };
    rightLabels = { fullfile(fsDir, 'label', 'Glasser2016', 'rh.V1.label'), ...
                    fullfile(fsDir, 'label', 'Glasser2016', 'rh.MT.label'), ...
                    fullfile(fsDir, 'label', 'Glasser2016', 'rh.MST.label'), ...
                    fullfile(fsDir, 'label', 'Glasser2016', 'rh.FST.label') };
elseif ismember(subject, {'0306','0307','0373'})
    % Group 2: Use Glasser2016 for V1, MT, MST and 0localizer for FST
    leftLabels = { fullfile(fsDir, 'label', 'Glasser2016', 'lh.V1.label'), ...
                   fullfile(fsDir, 'label', 'Glasser2016', 'lh.MT.label'), ...
                   fullfile(fsDir, 'label', 'Glasser2016', 'lh.MST.label'), ...
                   fullfile(fsDir, 'label', '0localizer', 'lh.FST.label') };
    rightLabels = { fullfile(fsDir, 'label', 'Glasser2016', 'rh.V1.label'), ...
                    fullfile(fsDir, 'label', 'Glasser2016', 'rh.MT.label'), ...
                    fullfile(fsDir, 'label', 'Glasser2016', 'rh.MST.label'), ...
                    fullfile(fsDir, 'label', '0localizer', 'rh.FST.label') };
else
    % Group 3: Following 0201 pattern, but mirror ROIs to both hemispheres.
    leftLabels = { fullfile(fsDir, 'label', 'retinotopy_RE', 'lh.V1_REmanual.label'), ...
                   fullfile(fsDir, 'label', 'retinotopy_RE', 'lh.pMT_REmanual.label'), ...
                   fullfile(fsDir, 'label', 'retinotopy_RE', 'lh.pMST_REmanual.label'), ...
                   fullfile(fsDir, 'label', '0localizer', 'lh.FST.label') };
    rightLabels = { fullfile(fsDir, 'label', 'retinotopy_RE', 'rh.V1_REmanual.label'), ...
                    fullfile(fsDir, 'label', 'retinotopy_RE', 'rh.pMT_REmanual.label'), ...
                    fullfile(fsDir, 'label', 'retinotopy_RE', 'rh.pMST_REmanual.label'), ...
                    fullfile(fsDir, 'label', '0localizer', 'rh.FST.label') };
end

% Define ROI colors (symmetric for both hemispheres):
% V1: blue, pMT: yellow, pMST: orange, FST: green
roiColors = {'blue', 'yellow', 'orange', 'green'};

%% Build label strings for each hemisphere
leftLabelStr = '';
for i = 1:length(leftLabels)
    leftLabelStr = [leftLabelStr, sprintf(':label=%s:label_color=%s:label_opacity=1', leftLabels{i}, roiColors{i})];
end

rightLabelStr = '';
for i = 1:length(rightLabels)
    rightLabelStr = [rightLabelStr, sprintf(':label=%s:label_color=%s:label_opacity=1', rightLabels{i}, roiColors{i})];
end

%% Define surface paths with binary curvature (grayscale)
leftSurface  = sprintf('%s:curv', fullfile(fsDir, 'surf', 'lh.inflated'));
rightSurface = sprintf('%s:curv', fullfile(fsDir, 'surf', 'rh.inflated'));

%% Construct the freeview command (displaying ROI labels over a grayscale curvature surface)
cmd = sprintf('%s -f %s%s -f %s%s &', freeviewPath, leftSurface, leftLabelStr, rightSurface, rightLabelStr);

fprintf('Executing subject %s:\n%s\n\n', subject, cmd);
system(cmd);


%%
