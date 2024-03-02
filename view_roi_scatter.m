clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '~/Desktop/MRI/FSTloc';
serverDir = '/Volumes/Vision/MRI/recon-bank';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,serverDir,githubDir,fsDir);

subject = 'sub-0395';
%roi = get_my_roi(subject,serverDir);
roisl = niftiread(['/Volumes/Vision/MRI/recon-bank/derivatives/freesurfer/' subject '/label/0localizer/lh.rois_vol.nii.gz']);
roisr = niftiread(['/Volumes/Vision/MRI/recon-bank/derivatives/freesurfer/' subject '/label/0localizer/rh.rois_vol.nii.gz']);
rois = roisl+roisr;
t1 = niftiread(['/Volumes/Vision/MRI/recon-bank/rawdata/' subject '/ses-01/anat/' subject '_ses-01_T1w.nii.gz']);
niiPath = ['/Volumes/Vision/MRI/recon-bank/derivatives/freesurfer/' subject '/mri/registered_filled_to_T1w.nii.gz'];
if isfile(niiPath)
else
tmpconvert
end
%%

vol = niftiread(niiPath);

% Assuming 'rois' variable is already loaded with your ROI data

% Voxel size in mm
voxelSize = 0.8;

% Visualization setup
fig = figure;
hold on;
daspect([1 1 1]); % Keep the aspect ratio 1:1:1 to reflect real dimensions
colormap('gray'); % Use grayscale for the T1 slice

% Plot the registered filled volume (e.g., brain) with transparency
[x, y, z] = meshgrid(1:size(vol,2), 1:size(vol,1), 1:size(vol,3));
[f, v] =isosurface(x * voxelSize, y * voxelSize, z * voxelSize, vol, 0.5);
p = patch('Faces',f,'Vertices',v);
%p = patch(isosurface(x * voxelSize, y * voxelSize, z * voxelSize, vol, 0.5));
p.FaceColor = 'white';
p.EdgeColor = 'none';
p.FaceAlpha = 0.3; % Adjust transparency here


% ROIs Visualization
% Visualize the first ROI (e.g., where rois == 1)
p1 = patch(isosurface(x * voxelSize, y * voxelSize, z * voxelSize, rois == 1, 0.5));
set(p1, 'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 1); % Less transparent ROIs

% Visualize the second ROI (e.g., where rois == 2)
p2 = patch(isosurface(x * voxelSize, y * voxelSize, z * voxelSize, rois == 2, 0.5));
set(p2, 'FaceColor', 'red', 'EdgeColor', 'none', 'FaceAlpha', 1);

% Adjust view, lighting, and axis
view(3); % 3D view
axis tight; % Fit the axis
lighting gouraud; % Smooth shading
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');

% Adjust axis limits based on the voxel size and volume dimensions
xlim([0 size(vol,2) * voxelSize]);
ylim([0 size(vol,1) * voxelSize]);
zlim([0 size(vol,3) * voxelSize]);


axis off; % Hide axis for better visualization

% Enhance plot with a light object and material properties for aesthetics
%light; lighting phong; material dull;
set(fig, 'Color', 'black', 'Position', [100, 100, 640*2, 480*2]); % Adjust position and size as needed

% Optional: Set the figure background color to none for transparency
%%


filename = ['/Users/pw1246/Desktop/' subject '.gif'];

% Loop to animate the view and save each frame to the GIF
for ii = [1:10, 10:-1:2]
    az = 10 + ii*5; % azimuth
    el = 20; % elevation
    view(az, el); % Set the camera view
    drawnow; % Force MATLAB to render the figure window now
    
    % Capture the frame
    frame = getframe(fig);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);

    % Write to the GIF File 
    if ii == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf,'DelayTime',0.15);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append','DelayTime',0.15);
    end
    pause(0.1)
    
end

hold off;
%%
% Read the GIF file
[img, map] = imread(filename, 'Frames', 'all');

% Define the crop rectangle [X, Y, Width, Height]
% Adjusted to MATLAB's indexing (subtract 1 from width and height)
cropRect = [700,400,1000,700]; 

% Preparing to overwrite or save to a new file
newFilename = filename; % Overwrite the original file

% Process and save each frame
for ii = 1:size(img, 4)
    % Crop the current frame (for indexed images)
    croppedImg = imcrop(img(:,:,1,ii), cropRect);
    
    % Write the cropped frame to the GIF file
    if ii == 1
        imwrite(croppedImg, map, newFilename, 'gif', 'Loopcount', inf, 'DelayTime', 0.2);
    else
        imwrite(croppedImg, map, newFilename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.2);
    end
end
%%
 