function setup_user(projectName,bidsDir,githubDir,fsDir)

switch(projectName)
    case 'Decoding'
        % setup toolboxes
        addpath(genpath(fullfile(pwd,'Toolbox')));
        addpath(genpath(fullfile(githubDir, 'MRI_tools'))); % https://github.com/WinawerLab/MRI_tools
        addpath(genpath(fullfile(githubDir, 'analyzePRF'))); % https://github.com/cvnlab/analyzePRF
        addpath(genpath(fullfile(githubDir, 'jsonlab'))); % https://github.com/fangq/jsonlab
        addpath(genpath(fullfile(githubDir, 'fMRI-Matlab'))); % https://github.com/gllmflndn/gifti
            
    case 'CueIntegration2023'
        addpath(genpath(fullfile(githubDir, 'GLMdenoise'))); % https://github.com/cvnlab/GLMdenoise
        addpath(genpath(fullfile(githubDir, 'nsdcode'))); % https://github.com/cvnlab/nsdcode

    case 'Loc2023'
        addpath(genpath(fullfile(githubDir, 'GLMdenoise'))); % https://github.com/cvnlab/GLMdenoise
        addpath(genpath(fullfile(githubDir, 'nsdcode'))); % https://github.com/cvnlab/nsdcode
    case 'FSTLoc'
        addpath(genpath(fullfile(githubDir, 'GLMdenoise'))); % https://github.com/cvnlab/GLMdenoise
        addpath(genpath(fullfile(githubDir, 'nsdcode'))); % https://github.com/cvnlab/nsdcode
         addpath(genpath(fullfile(githubDir, 'vistasoft')));  
end

% general toolboxes
        addpath(genpath(fullfile(githubDir, 'cvncode'))); % https://github.com/cvnlab/cvncode
        addpath(genpath(fullfile(githubDir, 'knkutils'))); % https://github.com/cvnlab/knkutils
        addpath(genpath(fullfile(githubDir, 'gifti'))); % https://github.com/gllmflndn/gifti
        addpath(genpath(fullfile(githubDir, 'GLMsingle')));

        
% freesurfer settings
PATH = getenv('PATH'); 

fslDir = '/usr/local/fsl';
if ~contains(PATH, [fslDir '/bin'])
    setenv('PATH', [PATH ':' fslDir '/bin']); % add freesurfer/bin to path
end
setenv('FSLDIR', fslDir);

if ~contains(getenv('PATH'), '/usr/local/bin')
    setenv('PATH', sprintf('/usr/local/bin:%s', getenv('PATH'))); % add /usr/local/bin to PATH
end

fsDir = '/usr/local/freesurfer'; % assuming fsDir is defined somewhere
if ~contains(getenv('PATH'), [fsDir '/bin'])
    setenv('PATH', [fsDir '/bin:' getenv('PATH')]);
end

if ~contains(getenv('PATH'), '/usr/local/fsl/bin')
    setenv('PATH', [getenv('PATH') ':/usr/local/fsl/bin']);
end

setenv('FREESURFER_HOME', fsDir);
addpath(genpath(fullfile(fsDir, 'matlab')));
setenv('SUBJECTS_DIR', [bidsDir '/derivatives/freesurfer']);