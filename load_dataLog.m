function datafiles = load_dataLog(matchingRows,space)

nRuns = size(matchingRows,1);
datafiles = cell(1,nRuns); % initialize for all the runs

hemi = {'L';'R'};
fileType = '.mgh';

for iRun = 1:nRuns

    % file path
    subDir = sprintf('%s/derivatives/fmriprep/%s/%s/func',matchingRows.bids{iRun},matchingRows.subject{iRun},matchingRows.session{iRun});

    whichRun = matchingRows.run(iRun); % current run #
    func = cell(2,1); % initialize for 2 hemi

    for iH = 1:numel(hemi)


        fileName = sprintf('%s/%s_%s_task-%s_run-%s_space-%s_hemi-%s_bold.func',subDir,matchingRows.subject{iRun},matchingRows.session{iRun},matchingRows.task{iRun},num2str(whichRun),space,hemi{iH});

        if ~isfile([fileName '.gii'])
            fileName = sprintf('%s/%s_%s_task-%s_dir-PA_run-%s_space-%s_hemi-%s_bold.func',subDir,matchingRows.subject{iRun},matchingRows.session{iRun},matchingRows.task{iRun},num2str(whichRun),space,hemi{iH});
        end

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