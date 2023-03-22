function datafiles = load_data(bidsDir,task,space,fileType,sub,ses,runs)


if isempty(ses) 
     subj_dir = sprintf('%s/derivatives/fmriprep/%s/func',bidsDir,sub);
else
    subj_dir = sprintf('%s/derivatives/fmriprep/%s/%s/func',bidsDir,sub,ses);
end


switch space % switch between volumn or surface
    
    case 'T1w' 
        
        datafiles = cell(1,length(runs));
        
        for iRun = 1:length(runs)
            
              whichRun = runs(iRun);
            
            disp(['Loading: ' sprintf('%s/*%s*%s_*%s_desc-preproc_bold%s',subj_dir,task,num2str(whichRun),space,fileType)]);
            tmpDir = dir(sprintf('%s/*task-%s_run-%s_*%s_desc-preproc_bold%s*',subj_dir,task,num2str(whichRun),space,fileType));
            datafiles{iRun} = niftiread([subj_dir '/' tmpDir.name]);            
            
        end
        
        datafiles(cellfun(@isempty,datafiles)) = [];
        
    case {'fsnative','fsaverage','fsaverage5','fsaverage6'}
        
        hemi = {'L';'R'};
        
        % check to see if data exists in the desired fileType, if not,
        % mir_convert it from gii
        
        for iRun = 1:length(runs)
            whichRun = runs(iRun);
            for iH = 1:numel(hemi)
                input = sprintf('%s/derivatives/fmriprep/%s/%s/func/%s_%s_task-%s_run-%s_space-fsnative_hemi-%s_bold.func.gii',bidsDir,sub,ses,sub,ses,task,num2str(whichRun),hemi{iH});
                output = sprintf('%s/derivatives/fmriprep/%s/%s/func/%s_%s_task-%s_run-%s_space-fsnative_hemi-%s_bold.func.%s',bidsDir,sub,ses,sub,ses,task,num2str(whichRun),hemi{iH},fileType);
                if ~exist(output)
                    system(['mri_convert ' input ' ' output]);
                end
            end
        end
         
        % load surface data
        datafiles = cell(1,length(runs));         
        for iRun = 1:length(runs)           
            whichRun = runs(iRun);
            tempDirL = dir(sprintf('%s/*_task-%s_run-%s_*%s_hemi-%s*%s',subj_dir,task,num2str(whichRun),space,hemi{1},fileType));
            tempDirR = dir(sprintf('%s/*_task-%s_run-%s_*%s_hemi-%s*%s',subj_dir,task,num2str(whichRun),space,hemi{2},fileType));
            disp(['Loading: ' tempDirL.name])
            disp(['Loading: ' tempDirR.name])
            
            switch fileType
                case '.gii'
                    funcL  = gifti(sprintf('%s/%s',subj_dir,tempDirL.name));
                    funcL  = funcL.cdata;
                    funcR  = gifti(sprintf('%s/%s',subj_dir,tempDirR.name));
                    funcR  = funcR.cdata;
                case {'.mgh','.mgz'}                                                          
                    funcL = MRIread(sprintf('%s/%s',subj_dir,tempDirL.name));
                    funcL = squeeze(funcL.vol);
                    funcR = MRIread(sprintf('%s/%s',subj_dir,tempDirR.name));
                    funcR = squeeze(funcR.vol);
                otherwise
                    error('file type not valid')
            end
            datafiles{iRun} = cat(1,funcL,funcR);
        end
    otherwise
        error('data space not valid')
end

end

%%