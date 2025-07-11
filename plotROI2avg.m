%% Define subject list and shared parameters
subjects = {'0201','0230','0248','0250','0255','0306','0307','0373','0392','0395'};
baseDir = '/Users/pw1246/Documents/MRI/CueIntegration2024';

% Set up the environment variable
setenv('SUBJECTS_DIR', fullfile(baseDir, 'derivatives', 'freesurfer'));

% Define a custom colormap with high contrast colors
custom_colors = [
    0.8 0.8 0.8;      % Dark Red
    0 0.6 0;      % Dark Green
    0 0 0.8;      % Dark Blue
    0.8 0.8 0;    % Dark Yellow
    0.8 0 0.8;    % Dark Magenta
    0 0.8 0.8;    % Dark Cyan
    0.8 0.4 0;    % Dark Orange
    0.6 0 0.6;    % Dark Purple
    0 0.4 0;      % Very Dark Green
    0.4 0.4 0.4   % Dark Gray
];

%% First plot just the curvature
fprintf('Plotting curvature...\n');
lcurv = read_curv('/Users/pw1246/Documents/MRI/CueIntegration2024/derivatives/freesurfer/fsaverage/surf/lh.curv');
rcurv = read_curv('/Users/pw1246/Documents/MRI/CueIntegration2024/derivatives/freesurfer/fsaverage/surf/rh.curv');
curv = [lcurv;rcurv];
% curv(curv>0) = 0.2;
% curv(curv<=0) = -0.2;
figure('Name', 'Cortical Curvature');
cvnlookup('fsaverage', 13, curv, [-0.8 0.8], gray, [], [], [], ...
    {'rgbnan', 1, ...           % White background
     'hemibordercolor', [1 1 1]});  % White border between hemispheres
colormap(gray);
colorbar('Ticks', [-1 0 1], 'TickLabels', {'Sulci', 'Flat', 'Gyri'});

%% Process each subject
for ii = 10%:numel(subjects)
    subject = subjects{ii};
    fprintf('Processing subject %s...\n', subject);
    
    data=load_mgz('fsaverage',baseDir,['averageROI/rois.' sprintf('sub-%s', subject) '']);
    
    % Use cvnlookup to visualize with custom colormap and improved parameters
    figure('Name', sprintf('Subject %s ROIs', subject));
    cvnlookup('fsaverage', 13, data, [0 4], custom_colors, [], [], [], ...
        {'rgbnan', 1, ...           % White background
         'hemibordercolor', [1 1 1], ...  % White border between hemispheres
         'brightness', 1.2, ...     % Slightly increased brightness
         'contrast', 1.2, ...       % Slightly increased contrast
         'roibordercolor', [0 0 0], ...   % Black border around ROIs
         'roiborderwidth', 1});     % Border width
    
    % Add a colorbar to show ROI labels
    colormap(custom_colors);
    colorbar('Ticks', 1:size(custom_colors,1), 'TickLabels', {'ROI 1', 'ROI 2', 'ROI 3', 'ROI 4'});
end 