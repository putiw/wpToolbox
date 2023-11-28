function native2avg(whichSub, bidsDir, varargin)

% this scripts takes mgz file name, subject ID, and bidsDir to convert
% everything into fsaverage space. 

% subject - e.g. 'sub-0248' - subject ID
% bidsDir - e.g. '~/Documents/MRI/bids' - BIDS directory
% hemi - e.g. - 'l' - optional, if not defined then we will plot both hemisphere
% varargin - e.g. 'maps/motion' - 'subfolderName/mgzFileName' - look for matching files only in the defined subfolder within derivatives

% example usage:
% subject = 'sub-0248'
% bidsDir = '~/Documents/MRI/bids';
% view_fv(subject, bidsDir, 'maps/motion', 'MyelinMap',);
% % or
% view_fv(subject, bidsDir, 'lh', 'mt+2', 'cw:rainbow','prfvista_mov/eccen');

derivDir = [bidsDir '/derivatives'];
subject = [];
%% check if BIDS derivatives directory exsits
if ~exist(derivDir,'dir')
    error(['BIDS derivatives directory does not exist <' derivDir '>'])
end
if contains(derivDir,'~') 
    derivDir = strrep(derivDir, '~', getenv('HOME')); % somehow colormaps cannot be find when using ~
end
%% check if subject directory exsits

if ismember(whichSub,{'fsaverage','fsaverage6'}) % if it's fsaverage space no need to find subject folder
    subfolderName = whichSub;
    subject{1} = whichSub;
    subject{2} = 'NA';
else % if it's native use subject ID as folder
    if ~contains(whichSub, 'sub-')
    else
        tmp = strsplit(whichSub, '-');
        whichSub = tmp{2};
    end
    % if subject has more than one ID, define here so we will find overlays under any of the names.
    if ismember(whichSub,{'0392','wlsubj123'})
        subject = {'sub-0392','sub-wlsubj123'};
    elseif ismember(whichSub,{'0248','wlsubj124'})
        subject = {'sub-0248','sub-wlsubj124'};
    else
        subject{1} = ['sub-' whichSub];
        subject{2} = 'NA';
    end
    subfolder = dir(sprintf('%s/freesurfer/*%s*',derivDir,subject{1})); % in freesurfer folder check for any subject folder matches our subject ID
    if isempty(subfolder)
            subfolder = dir(sprintf('%s/freesurfer/*%s*',derivDir,subject{2})); % check the second name if we can't find a subject folder under first name   
    end
    subfolderName = subfolder([subfolder.isdir]).name; % get the folder name
end

subjectDir = sprintf('%s/freesurfer/%s',derivDir,subfolderName); % build the path for subject directory
if ~exist(subjectDir,'dir') % check if this subject directory exists
    error(['subject freesurfer directory for <' subject '> does not exist: <' subjectDir '>'])
end

%% check if freeview exsits
tmpDir = dir(fullfile('/Applications/freesurfer/*'));
fsPattern = '^\d+\.\d+\.\d+$'; % e.g. 6.2.0
for ii = 1:length(tmpDir)
    if  ~isempty(regexp(tmpDir(ii).name, fsPattern, 'once'))
        fvDir = [tmpDir(ii).folder '/' tmpDir(ii).name];
        setenv('FREESURFER_HOME', fvDir); 
        fvCmd = [fvDir '/bin/freeview'];
    end
end
setenv('SUBJECTS_DIR', [derivDir '/freesurfer']);

%% check which hemisphere to plot
if ismember(lower(varargin{1}), {'l','lh','left'})
    hemi = {'l'};
    varargin = varargin(2:end);
elseif ismember(lower(varargin{1}), {'r','rh','right'})
    hemi = {'r'};
    varargin = varargin(2:end);
else
    hemi = {'l','r'};
end
%% loop through each hemisphere
tmpmgz0 = MRIread(fullfile(sprintf('%s/freesurfer/fsaverage',derivDir), 'mri', 'orig.mgz'));
for whichHemi = 1:numel(hemi)

    % loop through each overlay name provided in varargin

    for whichOverlay = 1:length(varargin)
        % parse the input to get the folder, overlay, and colormap name
        [folder, fileParts] = parse_input(varargin{whichOverlay},derivDir,subject,hemi{whichHemi});
        overlayName = fileParts{3};
        for whichFolder = 1:numel(folder)
            % find fsnative mgz
            whereOverlay = sprintf('%s/%sh.%s.mgz', folder{whichFolder}, hemi{whichHemi}, overlayName);
            % load fsnative mgz
            tmp = MRIread(whereOverlay);
            tmp = squeeze(tmp.vol);
            % convert to fsaverage
            tmp = cvntransfertosubject(subfolderName,'fsaverage', tmp(:), [hemi{whichHemi} 'h'], 'nearest', 'orig', 'orig');
            % use an empty mgz to write the value to 
            tmpmgz = tmpmgz0;
            tmpmgz.vol = [];
            tmpmgz.vol = tmp;
            % find path to save the fsavg file
            tmp = strsplit(folder{whichFolder},'/');
            if contains(tmp(end),'ses')
                tmp(end-1:end) = []; % get rid of subject and session folder
            else
                tmp(end) = []; % get rid of subject folder
            end
            tmp = [strjoin(tmp, '/') '/fsaverage'];
            if ~isfolder(tmp) mkdir(tmp); end
            filename = [hemi{whichHemi} 'h.' overlayName '.' subject{1} '.mgz'];
            disp(['saving ' [hemi{whichHemi} 'h.' overlayName '.' subject{1} '.mgz ...']])
            MRIwrite(tmpmgz, fullfile(tmp, filename));
        end
    end
    
end

end

%% sub functions
%% which folders are my overlay files in
function [folder, fileParts] = parse_input(whichFile,derivDir,subject,iHemi)

    % create temp variable fileParts that is {whichFolder} {whichOverlay} {whichColormap} {whichHemi}
    fileParts = regexp(whichFile, '[:/]', 'split'); % if folder and colormap are specified
    if count(whichFile, '/') == 1 % yes folder no session
        fileParts = [fileParts(1) '**' fileParts(2:end)];
    elseif  count(whichFile, '/') == 0 % no folder no session
        fileParts = ['**' '**' fileParts];
    end
    if ~contains(whichFile,':') % if colormap is not specified
        fileParts = [fileParts 'NA'];
    end

    fileParts = [fileParts iHemi]; % which hemi
    folder = {};
    for iSub = 1:numel(subject) % if sub has more than one name we check across all of them
        tmpFolder = find_my_files(subject{iSub},derivDir,fileParts); % look for the overlay files
        if isfolder(tmpFolder)
            folder = [folder tmpFolder];
        end
    end

    if isempty(folder)
        warning(['<' iHemi 'h.' fileParts{3} '.mgz> not found in any subfolders for this subject']);
        warning(['skipping ' fileParts{3} ' for ' iHemi 'h']);
    end


end

%% return all sub folders that contains wanted overlay mgz file
function folder = find_my_files(whichSub,derivDir,fileParts)

    subDirs = dir(fullfile(derivDir, '*'));
    
    if strcmp(fileParts{1},'**')
        subDirs = subDirs([subDirs.isdir] & ~ismember({subDirs.name}, {'.', '..', 'derivatives','freesurfer'}));
    else
        subDirs = subDirs([subDirs.isdir] & ismember({subDirs.name}, {fileParts{1}}));
    end

    tmpFiles = [];
    for subDir = subDirs'
        tmpFiles = [tmpFiles; dir(fullfile(derivDir, subDir.name, whichSub, fileParts{2}, [fileParts{5} 'h.' fileParts{3} '.mgz']))];
    end

    folder = cell(numel(tmpFiles),1);
    for iFile = 1:length(tmpFiles)
        if ~tmpFiles(iFile).isdir
            folder{iFile}  = tmpFiles(iFile).folder;
        end
    end
end
