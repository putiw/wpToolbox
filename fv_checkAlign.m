% Define the BIDS directory, subject, and session


%% NO PA

bidsDir = '/Users/pw1246/Desktop/testfMRI/f24sbfnoPA';
subject = 'sub-0620';
session = 'ses-01';

% Define the path to the BOLD NIfTI file and convert to MGZ if necessary
bold = sprintf('%s/derivatives/fmriprep/%s/%s/func/%s_%s_task-restingstate_dir-AP_run-01_space-T1w_desc-preproc_bold.nii.gz', ...
    bidsDir, subject, session, subject, session);
mgz = strrep(bold, 'nii.gz', 'mgz');

if ~isfile(mgz)
    system(sprintf('mri_convert %s %s', bold, mgz));
end

% Define paths to the T1-weighted image and surface files
T1w = sprintf('%s/derivatives/freesurfer/%s/mri/T1.mgz', bidsDir, subject);
lh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/lh.pial', bidsDir, subject);
rh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/rh.pial', bidsDir, subject);
lh_white = sprintf('%s/derivatives/freesurfer/%s/surf/lh.white', bidsDir, subject);
rh_white = sprintf('%s/derivatives/freesurfer/%s/surf/rh.white', bidsDir, subject);

% Build and execute the Freeview command to display the images and overlays
cmd = sprintf(['freeview -v %s ' ...
    '-v %s:colormap=grayscale ' ...
    '-f %s:edgecolor=red ' ...
    '%s:edgecolor=red ' ...
    '%s:edgecolor=yellow ' ...
    '%s:edgecolor=yellow &'], ...
    T1w, mgz, lh_pial, rh_pial, lh_white, rh_white);

system(cmd);


%% PA 20

% Define the BIDS directory, subject, and session
bidsDir = '/Users/pw1246/Desktop/testfMRI/ameenPath20sbref';
subject = 'sub-0620';
session = 'ses-01';
% Define the path to the BOLD NIfTI file and convert to MGZ if necessary
bold = sprintf('%s/derivatives/fmriprep/%s/%s/func/%s_%s_task-restingstate_dir-PA_run-1_space-T1w_desc-preproc_bold.nii.gz', ...
    bidsDir, subject, session, subject, session);
mgz = strrep(bold, 'nii.gz', 'mgz');

if ~isfile(mgz)
    system(sprintf('mri_convert %s %s', bold, mgz));
end

% Define paths to the T1-weighted image and surface files
T1w = sprintf('%s/derivatives/freesurfer/%s/mri/T1.mgz', bidsDir, subject);
lh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/lh.pial', bidsDir, subject);
rh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/rh.pial', bidsDir, subject);
lh_white = sprintf('%s/derivatives/freesurfer/%s/surf/lh.white', bidsDir, subject);
rh_white = sprintf('%s/derivatives/freesurfer/%s/surf/rh.white', bidsDir, subject);

% Build and execute the Freeview command to display the images and overlays
cmd = sprintf(['freeview -v %s ' ...
    '-v %s:colormap=grayscale ' ...
    '-f %s:edgecolor=red ' ...
    '%s:edgecolor=red ' ...
    '%s:edgecolor=yellow ' ...
    '%s:edgecolor=yellow &'], ...
    T1w, mgz, lh_pial, rh_pial, lh_white, rh_white);

system(cmd);

%% PA 24

% Define the BIDS directory, subject, and session
bidsDir = '/Users/pw1246/Desktop/testfMRI/f24sbfyesPA';
subject = 'sub-0620';
session = 'ses-01';
% Define the path to the BOLD NIfTI file and convert to MGZ if necessary
bold = sprintf('%s/derivatives/%s/%s/func/%s_%s_task-restingstate_dir-PA_run-01_space-T1w_desc-preproc_bold.nii.gz', ...
    bidsDir, subject, session, subject, session);
mgz = strrep(bold, 'nii.gz', 'mgz');

if ~isfile(mgz)
    system(sprintf('mri_convert %s %s', bold, mgz));
end

% Define paths to the T1-weighted image and surface files
T1w = sprintf('%s/derivatives/freesurfer/%s/mri/T1.mgz', bidsDir, subject);
lh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/lh.pial', bidsDir, subject);
rh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/rh.pial', bidsDir, subject);
lh_white = sprintf('%s/derivatives/freesurfer/%s/surf/lh.white', bidsDir, subject);
rh_white = sprintf('%s/derivatives/freesurfer/%s/surf/rh.white', bidsDir, subject);

% Build and execute the Freeview command to display the images and overlays
cmd = sprintf(['freeview -v %s ' ...
    '-v %s:colormap=grayscale ' ...
    '-f %s:edgecolor=red ' ...
    '%s:edgecolor=red ' ...
    '%s:edgecolor=yellow ' ...
    '%s:edgecolor=yellow &'], ...
    T1w, mgz, lh_pial, rh_pial, lh_white, rh_white);

system(cmd);


%%

% Define the BIDS directory, subject, and session
bidsDir = '/Users/pw1246/Desktop/testfMRI/f24sbfyesPA';
subject = 'sub-0620';
session = 'ses-01';
% Define the path to the BOLD NIfTI file and convert to MGZ if necessary
bold = sprintf('%s/derivatives/%s/%s/func/%s_%s_task-restingstate_dir-PA_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz', ...
    bidsDir, subject, session, subject, session);
mgz = strrep(bold, 'nii.gz', 'mgz');

if ~isfile(mgz)
    system(sprintf('mri_convert %s %s', bold, mgz));
end

% Define paths to the T1-weighted image and surface files
T1w = sprintf('%s/derivatives/freesurfer/%s/mri/T1.mgz', bidsDir, subject);
lh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/lh.pial', bidsDir, subject);
rh_pial = sprintf('%s/derivatives/freesurfer/%s/surf/rh.pial', bidsDir, subject);
lh_white = sprintf('%s/derivatives/freesurfer/%s/surf/lh.white', bidsDir, subject);
rh_white = sprintf('%s/derivatives/freesurfer/%s/surf/rh.white', bidsDir, subject);

% Build and execute the Freeview command to display the images and overlays
cmd = sprintf(['freeview -v %s ' ...
    '-v %s:colormap=grayscale ' ...
    '-f %s:edgecolor=red ' ...
    '%s:edgecolor=red ' ...
    '%s:edgecolor=yellow ' ...
    '%s:edgecolor=yellow &'], ...
    T1w, mgz, lh_pial, rh_pial, lh_white, rh_white);

system(cmd);
