%% convert roi from single trial decoding project to fsaverage space
subjects = {'0201','0230','0248','0250','0255','0306','0307','0373','0392','0395'};
baseDir = '/Users/pw1246/Documents/MRI/CueIntegration2024';
bidsDir = baseDir;

% Create output directory if it doesn't exist
outputDir = fullfile(baseDir, 'derivatives', 'averageROI');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% Process each subject
for ii = 1:numel(subjects)
    subject = subjects{ii};
    fprintf('Processing subject %s...\n', subject);
    
    % Run native2avg for this subject
    native2avg(sprintf('sub-%s', subject), bidsDir, 'averageROI/rois');
end
