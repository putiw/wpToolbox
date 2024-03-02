

bidsDir = '/Volumes/Vision/UsersShare/Puti/MsBIDS';
subDir = sprintf('%s/derivatives/freesurfer',bidsDir);
setenv('SUBJECTS_DIR', subDir);

subject = 'sub-ms01';

T1 = sprintf('%s/%s/mri/T1.mgz',subDir,subject);
lhwhite = sprintf('%s/%s/surf/lh.white',subDir,subject);
rhwhite = sprintf('%s/%s/surf/rh.white',subDir,subject);
lhpial = sprintf('%s/%s/surf/lh.pial',subDir,subject);
rhpial = sprintf('%s/%s/surf/rh.pial',subDir,subject);

wm = sprintf('%s/%s/mri/wmparc.mgz',subDir,subject);
lesion = '/Users/pw1246/Desktop/empty/ples_lpa_mrT2.mgz';
lesnii = '/Users/pw1246/Desktop/empty/ples_lpa_mrT2.nii';
T2 = '/Users/pw1246/Desktop/empty/mrT2.nii';
T2m = '/Users/pw1246/Desktop/empty/mrT2.mgz';
%cmd = system(sprintf('freeview -v %s -f %s -f %s -f %s -f %s &', T1, lhwhite, rhwhite, lhpial, rhpial));

system(sprintf('freeview -v %s -v %s -v %s &', T1, wm, lesion));
%%
%niiPath = [bidsDir '/derivatives/freesurfer/' subject '/mri/filled.nii'];
%niiPath = [bidsDir '/derivatives/freesurfer/' subject '/mri/ribbon.nii'];
niiPath = [bidsDir '/derivatives/freesurfer/' subject '/mri/brainmask.nii'];




tmp2 = niftiread(T2);
tmp3 = MRIread(T2m);
tmp3 = tmp3.vol;
les1 = MRIread(lesion);
les = les1.vol;
%%

for ii = 90:165
figure(1);clf;
yy = ii;
img0 = reshape(tmp3(:,yy,:),256,256);
wherelesion = reshape(les(:,yy,:),256,256);
wherelesion(wherelesion==0) = nan;
img1 = wherelesion;
img0 = mat2gray(img0); % Normalize img0 to the range [0, 1]
img0 = [img0 img0];
img0 = repelem(img0,4,4);
imshow(img0);
hold on;
img1 = [nan(size(img1)) img1];
img1 = repelem(img1,4,4);

nanMask = ~isnan(img1);
img1(~nanMask) = min(img1(:)); % Replace NaN with min of img1 for colormap indexing
h = imshow(ind2rgb(im2uint8(mat2gray(img1)), hot(256)));
set(h, 'AlphaData', nanMask);
text('Units', 'normalized', 'Position', [0.9, 0.1], 'String', num2str(yy), 'Color', 'white', 'FontSize', 25, 'FontWeight', 'bold', 'FontAngle', 'italic');
drawnow
pause(0.1)

end

%%
figure(2); clf; hold on;
vol = niftiread(niiPath);
vol = permute(vol, [2 3 1]);
lesn = niftiread(lesnii);
lesn = permute(lesn, [2 3 1]);

[x, y, z] = meshgrid(1:size(vol,1), 1:size(vol,2), 1:size(vol,3));

% Plot the lesion isosurface
lesR = lesn;
lesR(:,:,129:end) = 0;
lesL = lesn;
lesL(:,:,1:128) = 0;

[f, v] = isosurface(x, y, z, lesR>0.9, 0.1,'FaceColor', 'red');
p0 = patch('Faces', f, 'Vertices', v);
set(p0, 'FaceColor', 'red', 'EdgeColor', 'none'); % Change lesion color here
material(p0, 'shiny'); % Make the lesion reflective
[f, v] = isosurface(x, y, z, lesL>0.9, 0.1,'FaceColor', 'blue');
p1 = patch('Faces', f, 'Vertices', v);
set(p1, 'FaceColor', 'blue', 'EdgeColor', 'none'); % Change lesion color here
material(p1, 'shiny'); % Make the lesion reflective
lighting phong;
light('Position', [1 0 0], 'Style', 'local'); % Position a light to emphasize the lesion

% % Keep the aspect ratio 1:1:1 and use grayscale colormap for context visualization
daspect([1 1 1]);
% colormap('gray');
%
[f, v] = isosurface(x, y, z, vol, 0.5);
p = patch('Faces', f, 'Vertices', v);
p.FaceColor = [1 1 1];
p.EdgeColor = 'none';
p.FaceAlpha = 0.05; % Transparent white matter surface
camlight;
axis equal;
axis off;


set(gcf, 'Color', 'white');
for ii = [-40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40]
view(0, ii);
drawnow
pause(0.02)
end
% for ii =1:20
% rotate(p, [0 1 0], -10)
% rotate(p0, [0 1 0], -10)
% rotate(p1, [0 1 0], -10)
% 
% drawnow
% end
%%
% Threshold your data if not already binary
% Here, assuming lesions are identified by a threshold (adjust accordingly)
binaryLesions = lesn > 0.8; % Example threshold

% Label connected components (each distinct lesion gets a unique label)
[L, num] = bwlabeln(binaryLesions);

% L is a 3D matrix the same size as 'lesion' with each lesion labeled by a unique number
% 'num' is the total number of distinct lesions found
% Initialize an array to hold volumes
lesionVolumes = zeros(num, 1);

% Calculate volume for each lesion
for i = 1:num
    lesionVolumes(i) = nnz(L == i); % Number of voxels in the ith lesion
end
[~, whichLes] = sort(lesionVolumes);
whichLes = flip(whichLes);
% Convert voxel counts to real-world volume (mm^3) if necessary
% Example: voxelSize = 1; % 1 mm^3 per voxel, adjust based on your data specifics
voxelSize = 1; % This is an assumption; replace with your actual voxel dimensions
lesionVolumes_mm3 = lesionVolumes * voxelSize;
% Extracting the first lesion as an example
for ii = 1:3
firstLesion = L == whichLes(ii); % Binary matrix for the first lesion
isosurface(firstLesion, 0.5); % Adjust the second argument as needed for visualization
drawnow
end
%%
figure(3); clf; hold on;

[x, y, z] = meshgrid(1:size(vol,1), 1:size(vol,2), 1:size(vol,3));

% [f, v] = isosurface(x, y, z, firstLesion, 0.1,'FaceColor', 'red');
% p0 = patch('Faces', f, 'Vertices', v);
% set(p0, 'FaceColor', 'red', 'EdgeColor', 'none'); % Change lesion color here
% material(p0, 'shiny'); % Make the lesion reflective

lighting phong;
light('Position', [1 0 0], 'Style', 'local'); % Position a light to emphasize the lesion

% % Keep the aspect ratio 1:1:1 and use grayscale colormap for context visualization
daspect([1 1 1]);
% colormap('gray');
%
[f, v] = isosurface(x, y, z, vol, 0.5);
p = patch('Faces', f, 'Vertices', v);
p.FaceColor = [1 1 1];
p.EdgeColor = 'none';
p.FaceAlpha = 0.05; % Transparent white matter surface
camlight;
axis equal;
axis off;

set(gcf, 'Color', 'white');
 view(0, -50);
% for ii = [-40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40]
% view(0, ii);
% drawnow
% pause(0.02)
% end

%%

for i = whichLes(1)
    [x, y, z] = ind2sub(size(L), find(L == i)); % Find the indices of the i-th lesion
    
    % Calculate bounding box dimensions
    minX = min(x); maxX = max(x);
    minY = min(y); maxY = max(y);
    minZ = min(z); maxZ = max(z);
    
    % Determine the lengths of the bounding box sides
    lengthX = maxX - minX;
    lengthY = maxY - minY;
    lengthZ = maxZ - minZ;
    
    % Approximate diameter is the largest dimension of the bounding box
    approxDiameter = max([lengthX, lengthY, lengthZ]);

    fprintf('Lesion %d approximate diameter: %d units\n', i, approxDiameter);
end
