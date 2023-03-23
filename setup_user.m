function setup_user(projectName,bidsDir,githubDir,fsDir)

switch(projectName)
    case 'Decoding'
        % setup toolboxes
        addpath(genpath(fullfile(pwd,'Toolbox')));
        addpath(genpath(fullfile(githubDir, 'MRI_tools'))); % https://github.com/WinawerLab/MRI_tools
        addpath(genpath(fullfile(githubDir, 'analyzePRF'))); % https://github.com/cvnlab/analyzePRF
        addpath(genpath(fullfile(githubDir, 'jsonlab'))); % https://github.com/fangq/jsonlab
        addpath(genpath(fullfile(githubDir, 'cvncode'))); % https://github.com/cvnlab/cvncode
        addpath(genpath(fullfile(githubDir, 'knkutils'))); % https://github.com/cvnlab/knkutils
        addpath(genpath(fullfile(githubDir, 'gifti'))); % https://github.com/gllmflndn/gifti
        addpath(genpath(fullfile(githubDir, 'fMRI-Matlab'))); % https://github.com/gllmflndn/gifti
        addpath(genpath(fullfile(githubDir, 'fMRI-Matlab'))); % https://github.com/gllmflndn/gifti
        addpath(genpath(fullfile('/Users/pw1246/Documents/GitHub/GLMsingle')));
            
    case 'CueIntegration2023'
        addpath(genpath(fullfile(githubDir, 'cvncode'))); % https://github.com/cvnlab/cvncode
        addpath(genpath(fullfile(githubDir, 'gifti'))); % https://github.com/gllmflndn/gifti
        addpath(genpath(fullfile(githubDir, 'GLMdenoise'))); % https://github.com/cvnlab/GLMdenoise
        addpath(genpath(fullfile(githubDir, 'knkutils'))); % https://github.com/cvnlab/knkutils
        addpath(genpath(fullfile(githubDir, 'nsdcode'))); % https://github.com/cvnlab/nsdcode
        addpath(genpath(fullfile(githubDir, 'GLMsingle')));

    case 'Loc2023'
        addpath(genpath(fullfile(githubDir, 'cvncode'))); % https://github.com/cvnlab/cvncode
        addpath(genpath(fullfile(githubDir, 'knkutils'))); % https://github.com/cvnlab/knkutils
        addpath(genpath(fullfile(githubDir, 'GLMdenoise'))); % https://github.com/cvnlab/GLMdenoise
        addpath(genpath(fullfile(githubDir, 'nsdcode'))); % https://github.com/cvnlab/nsdcode
        addpath(genpath(fullfile(githubDir, 'gifti'))); % https://github.com/gllmflndn/gifti        
        
end

% freesurfer settings
fslDir = '/usr/local/fsl';
PATH = getenv('PATH'); setenv('PATH', [PATH ':' fslDir '/bin']); % add freesurfer/bin to path
setenv('FSLDIR', fslDir);
setenv('PATH', sprintf('/usr/local/bin:%s', getenv('PATH'))); % add /usr/local/bin to PATH
setenv('PATH', [fsDir '/bin:' getenv('PATH')]);
setenv('PATH', [getenv('PATH') ':/usr/local/fsl/bin']);
setenv('FREESURFER_HOME', fsDir);
addpath(genpath(fullfile(fsDir, 'matlab')));
setenv('SUBJECTS_DIR', [bidsDir '/derivatives/freesurfer']);
