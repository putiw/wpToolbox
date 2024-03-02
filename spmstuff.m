addpath(genpath('/Users/pw1246/Documents/GitHub/spm12'));
%%

val = niftiRead('/Users/pw1246/Desktop/empty/ples_lpa_mT2.nii');
[x, y, z] = ind2sub(size(val.data), find(val.data > 0.8));

% Adjusting for voxel size
voxelSize = [0.6000, 0.4688, 0.4688]; % voxel size in each dimension
x = x * voxelSize(1);
y = y * voxelSize(2);
z = z * voxelSize(3);

% Plot using scatter3
scatter3(x, y, z, 10);


xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
title('Scatter Plot of 1s in the Matrix');

% Adjusting axis to match the voxel dimensions
axis([0, size(val.data,1)*voxelSize(1), 0, size(val.data,2)*voxelSize(2), 0, size(val.data,3)*voxelSize(3)]);
daspect([1, 1, 1]); % Keeping the aspect ratio 1:1:1 to preserve the actual shape


