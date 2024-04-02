% Define the root directory of your subject
dest = '/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis_BIDS/rawdata'; %destiantion BIDs folder structure

subDir = dir(fullfile(dest,'*sub-*'));
subjects = cell(1,numel(subDir));
for ii = 1:numel(subDir)
    subjects{ii} = subDir(ii).name;
end
for whichSub = 1:numel(subjects)

subjectDir = sprintf('/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis_BIDS/rawdata/%s',subjects{whichSub}); % 

% Get a list of session directories in the subject folder
sessionDirs = dir(fullfile(subjectDir, 'ses-*'));
sessionDirs = sessionDirs([sessionDirs.isdir]); % Filter out anything that's not a directory

% Loop through each session directory
for i = 1:length(sessionDirs)
    sessionDirPath = fullfile(subjectDir, sessionDirs(i).name);
    
    % Define the new 'anat' directory path within the session directory
    anatDirPath = fullfile(sessionDirPath, 'anat');
    
    % Create the 'anat' directory if it doesn't already exist
    if ~exist(anatDirPath, 'dir')
        mkdir(anatDirPath);
    end
    
    % Get a list of all .nii.gz and .json files in the session directory
    filesToMove = dir(fullfile(sessionDirPath, '*.nii.gz'));
    filesToMove = [filesToMove; dir(fullfile(sessionDirPath, '*.json'))];
    
    % Move each file into the 'anat' directory
    for j = 1:length(filesToMove)
        movefile(fullfile(sessionDirPath, filesToMove(j).name), anatDirPath);
    end
end

disp('Files have been moved to the anat subfolders.');
end
