% Fast copy of ari-validation-details.txt files
% This script directly targets the specific file path pattern

% Define paths
source_base = '/Volumes/CTP-XNAT/xnat-main/xnat-data/archive/rokerslab_ari-hfs_2024_001/arc001';
dest_base = '/Users/pw1246/Desktop/projects/xnatpipeline/validator/rokerslab_ari-hfs_2024_001/arc001';

% Get all subject directories
subject_dirs = dir(fullfile(source_base, 'Subject_*'));
subject_dirs = subject_dirs([subject_dirs.isdir]);

fprintf('Found %d subject directories\n', length(subject_dirs));

% Counter for copied files
copied_count = 0;
missing_count = 0;

% Process each subject directory
for i = 1:length(subject_dirs)
    subject_name = subject_dirs(i).name;
    
    % Construct the exact file path
    source_file = fullfile(source_base, subject_name, 'RESOURCES', 'ari-validation', 'ari-validation-details.txt');
    
    % Check if file exists
    if exist(source_file, 'file')
        % Construct destination path
        dest_dir = fullfile(dest_base, subject_name, 'RESOURCES', 'ari-validation');
        dest_file = fullfile(dest_dir, 'ari-validation-details.txt');
        
        % Create destination directory if it doesn't exist
        if ~exist(dest_dir, 'dir')
            mkdir(dest_dir);
        end
        
        % Copy the file
        copyfile(source_file, dest_file);
        copied_count = copied_count + 1;
        
        if mod(copied_count, 10) == 0
            fprintf('Copied %d files...\n', copied_count);
        end
    else
        missing_count = missing_count + 1;
        fprintf('Warning: File not found for %s\n', subject_name);
    end
end

fprintf('\nCopy complete!\n');
fprintf('Files copied: %d\n', copied_count);
fprintf('Files missing: %d\n', missing_count);
fprintf('Total subjects: %d\n', length(subject_dirs));