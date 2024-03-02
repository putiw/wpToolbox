

cmd = ['mri_convert ' serverDir '/derivatives/freesurfer/' subject '/mri/filled.mgz ' serverDir '/derivatives/freesurfer/' subject '/mri/filled.nii.gz']
system(cmd)


flirtCmdTemplate = ['/Users/pw1246/fsl/share/fsl/bin/flirt -in %s -ref %s ' ...
                    '-out %s ' ...
                    '-omat %s ' ...
                    '-bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6 -interp nearestneighbour'];

% Input, reference, output, and matrix paths
inPath = sprintf('%s/derivatives/freesurfer/%s/mri/filled.nii.gz', serverDir, subject);
refPath = sprintf('%s/rawdata/%s/ses-01/anat/%s_ses-01_T1w.nii.gz', serverDir, subject, subject);
outPath = sprintf('%s/derivatives/freesurfer/%s/mri/registered_filled_to_T1w.nii.gz', serverDir, subject);
omatPath = sprintf('%s/derivatives/freesurfer/%s/mri/filled_to_T1w.mat', serverDir, subject);

% Construct the FLIRT command
flirtCmd = sprintf(flirtCmdTemplate, inPath, refPath, outPath, omatPath);

% Execute the FLIRT command
[status, result] = system(flirtCmd);

% Check if the command executed successfully
if status == 0
    disp('FLIRT registration completed successfully.');
else
    disp('FLIRT registration failed.');
    disp(result);
end
