function datafiles = load_data_prf(subject,task)

nRuns = 3;
datafiles = cell(1,nRuns); % initialize for all the runs

hemi = {'L';'R'};
fileType = '.mgh';
bidsDir = '/Volumes/Vision/UsersShare/Rania/Project_dg/data_bids';
session = 'ses-02';


subDir = sprintf('%s/derivatives/fmriprep/%s/%s/func',bidsDir,subject,session);

for iRun = 1:nRuns

    func = cell(2,1); % initialize for 2 hemi

    for iH = 1:numel(hemi)

        
        fileName = sprintf('%s/%s_%s_task-%s%s_dir-PA_space-fsnative_hemi-%s_bold.func',subDir,subject,session,task,num2str(iRun),hemi{iH});
  
        input = [fileName '.gii'];
        output = [fileName fileType]; % the file type that we want to load

        % check to see if data exists in the desired fileType, if not,
        % mir_convert file from gii
        if ~exist(output)
            disp(['File does not exist in ' fileType ' format, converting from .gii ...'])
            system(['mri_convert ' input ' ' output]);
        end

        disp(['Loading: ' output])

        tmp = MRIread(output);
        func{iH} = squeeze(tmp.vol);
    end
    datafiles{iRun} = cat(1,func{:});

end




%%