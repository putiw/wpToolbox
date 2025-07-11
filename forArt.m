% % Define the freesurfer directory containing subject folders
% freesurferDir = '/Users/pw1246/Documents/MRI/bigbids/derivatives/freesurfer';
% 
% % Set the colWidth variable (e.g., 3 columns per block)
% colWidth = 4;
% 
% % List all subject directories that match the pattern (e.g., sub-0xxx)
% subjectDirs = dir(fullfile(freesurferDir, 'sub-0*'));
% 
% % Initialize a cell array to hold the slices from each subject
% subjectSlices = {};
% 
% % Loop through each subject folder to load the T1.mgz file and extract the desired slice
% for i = 1:length(subjectDirs)
%     % Build the full path for the T1.mgz file
%     t1Path = fullfile(freesurferDir, subjectDirs(i).name, 'mri', 'T1.mgz');
%     if exist(t1Path, 'file')
%         % Load the T1 image using MRIread and extract the volume data
%         T1_struct = MRIread(t1Path);
%         T1_vol = T1_struct.vol;
% 
%         % Check if the volume dimensions are exactly 256x256x256; if not, skip this subject
%         if ~isequal(size(T1_vol), [256,256,256])
%             warning('Subject %s T1 volume is not 256x256x256. Skipping.', subjectDirs(i).name);
%             continue;
%         end
% 
%         % Extract the slice using squeeze(T1_vol(80,:,:))
%         axialSlice = squeeze(T1_vol(:,:,80));
% 
%         % Add the extracted slice to our cell array
%         subjectSlices{end+1} = axialSlice;
%     else
%         warning('File %s does not exist. Skipping.', t1Path);
%     end
% end
% 
% % Ensure at least one valid subject slice was loaded
% if isempty(subjectSlices)
%     error('No valid subject slices were loaded. Please check the directory and file paths.');
% end
% 
% % Assume all slices are the same size; retrieve image dimensions from the first slice
% [nRows, nCols] = size(subjectSlices{1});
% 
% % Create a new composite image by selecting, for each block of columns,
% % a block of 'colWidth' columns from a randomly chosen subject's slice.
% finalImage = zeros(nRows, nCols);
% numSubjects = length(subjectSlices);
% 
% for colStart = 1:colWidth:nCols
%     % Determine the ending column index for the current block
%     colEnd = min(colStart + colWidth - 1, nCols);
% 
%     % Randomly select a subject index
%     subjIdx = randi(numSubjects);
% 
%     % Fill the corresponding block in the final image
%     finalImage(:, colStart:colEnd) = subjectSlices{subjIdx}(:, colStart:colEnd);
% end
% 
% % Display the composite image using imshow
% figure(1);hold on;
% set(gcf,'Position',[1 1 800 800]);
% imshow(finalImage, []);
% title('Composite Slice with Random Subject Columns');

% Define the freesurfer directory containing subject folders
% Define the freesurfer directory containing subject folders
freesurferDir = '/Users/pw1246/Documents/MRI/bigbids/derivatives/freesurfer';

% Set the colWidth variable (e.g., 3 columns per block)
colWidth = 5;

% List all subject directories that match the pattern (e.g., sub-0xxx)
subjectDirs = dir(fullfile(freesurferDir, 'sub-0*'));

% Initialize cell arrays for the slices and corresponding random colors
subjectSlices = {};
subjectColors = [];

% Loop through each subject folder to load the T1.mgz file and extract the desired slice
for i = 1:length(subjectDirs)
    % Build the full path for the T1.mgz file
    t1Path = fullfile(freesurferDir, subjectDirs(i).name, 'mri', 'T1.mgz');
    if exist(t1Path, 'file')
        % Load the T1 image using MRIread and extract the volume data
        T1_struct = MRIread(t1Path);
        T1_vol = T1_struct.vol;
        
        % Check if the volume dimensions are exactly 256x256x256; if not, skip this subject
        if ~isequal(size(T1_vol), [256,256,256])
            warning('Subject %s T1 volume is not 256x256x256. Skipping.', subjectDirs(i).name);
            continue;
        end
        
        % Extract the slice using squeeze(T1_vol(80,:,:))
        axialSlice = squeeze(T1_vol(:,135,:));
        % Normalize the slice to [0,1] to avoid saturation issues
        axialSlice = mat2gray(axialSlice);
        
        % Store the extracted slice and assign a random color (RGB values)
        subjectSlices{end+1} = axialSlice;
        subjectColors(end+1, :) = rand(1,3);
    else
        warning('File %s does not exist. Skipping.', t1Path);
    end
end

% Ensure at least one valid subject slice was loaded
if isempty(subjectSlices)
    error('No valid subject slices were loaded. Please check the directory and file paths.');
end

% Retrieve image dimensions from the first slice
[nRows, nCols] = size(subjectSlices{1});

% Initialize the final composite image as an RGB image
finalImage = zeros(nRows, nCols, 3);
numSubjects = length(subjectSlices);

% For each block of 'colWidth' columns, assign columns from a random subject's slice
% and apply the subject's corresponding random color
for colStart = 1:colWidth:nCols
    % Determine the ending column index for the current block
    colEnd = min(colStart + colWidth - 1, nCols);
    
    % Randomly select a subject index
    subjIdx = randi(numSubjects);
    color = subjectColors(subjIdx, :);
    
    % Extract the block from the chosen subject's slice
    block = subjectSlices{subjIdx}(:, colStart:colEnd);
    
    % Apply the random color by multiplying the grayscale block with the color vector
    finalImage(:, colStart:colEnd, 1) = block * color(1);
    finalImage(:, colStart:colEnd, 2) = block * color(2);
    finalImage(:, colStart:colEnd, 3) = block * color(3);
end

% Set up the figure with the specified properties
figure(1); hold on;
set(gcf, 'Position', [1 1 800 800]);

% Display the composite colored image using imshow
imshow(finalImage, []);
title('Composite Colored Slice with Random Subject Columns');