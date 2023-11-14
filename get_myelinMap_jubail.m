%% step 1 - jubail to BIDS
% set up path
user = 'pw1246'; % username for jubail 
hcpJubailDir = '/scratch/pw1246/MRI/HCP'; % hcp folder on jubail
bidsDir = '/Users/pw1246/Desktop/MRI/bigbids'; % bids dir
subs = '0397';
subject = ['sub-' subs];  % which subject
inputDir = sprintf('%s@jubail.abudhabi.nyu.edu:%s/%s/outputs/PostFreeSurfer/MNINonLinear/Native/ ',user,hcpJubailDir,subject);
outputDir = sprintf('%s/derivatives/myelinHCP/%s',bidsDir,subject); % myelin output local dir
if ~isfolder(outputDir), mkdir(outputDir); end

% which myeline map
biasCorrect = 1;
smoothing = 0;

% get file path for rsync

inputMyelin = sprintf('--include=''%s.*.%sMyelinMap%s.native.func.gii'' ', subject, repmat('Smoothed',1,smoothing),repmat('_BC',1,biasCorrect))
inputSphere = sprintf('--include=''%s.*.%s.native.surf.gii'' ', subject, 'sphere');
inputThickness = sprintf('--include=''%s.*.%s.native.surf.gii'' ', subject, 'midthickness');

% rsync from jubail to target bids
command = ['rsync -av ' inputMyelin inputSphere inputThickness '--exclude=''*'' ' inputDir outputDir];
[~, cmdout] = system(command, '-echo');

%% step 2 - hcp to fsnative

fsDir = '/Volumes/Vision/MRI/recon-bank/freesurfer';
bidsDir = '/Volumes/Vision/MRI/recon-bank';
whichFolder = dir(fsDir);
subFolders = whichFolder([whichFolder.isdir] & ~ismember({whichFolder.name}, {'.', '..'}));
matchingFolders = subFolders(contains({subFolders.name}, subs));
subjectFolder = matchingFolders(1).name;
subjectDir = fullfile(fsDir, subjectFolder);

hemi = {'L','R'};

resultsDir = sprintf('%s/myelin/%s',bidsDir,subject); % myelin output local dir
if ~isfolder(resultsDir), mkdir(resultsDir); end

for whichHemi = 1:length(hemi)

fromMyelin = sprintf('%s/%s.%s.%sMyelinMap%s.native.func.gii',outputDir,subject,hemi{whichHemi},repmat('Smoothed',1,smoothing),repmat('_BC',1,biasCorrect));
fromSphere = sprintf('%s/%s.%s.%s.native.surf.gii',outputDir,subject,hemi{whichHemi},'sphere');
toSphere = sprintf('%s/freesurfer/%s/surf/%sh.%s',bidsDir,subjectFolder,lower(hemi{whichHemi}),'sphere');
toMyelin = sprintf('%s/%sh.%sMyelinMap%s',outputDir,lower(hemi{whichHemi}),repmat('Smoothed',1,smoothing),repmat('_BC',1,biasCorrect));
fromThickness = sprintf('%s/%s.%s.%s.native.surf.gii',outputDir,subject,hemi{whichHemi},'midthickness');
toThickness = sprintf('%s/freesurfer/%s/surf/%sh.%s',bidsDir,subjectFolder,lower(hemi{whichHemi}),'midthickness');
toMyelin2 = sprintf('%s/%sh.%sMyelinMap%s',resultsDir,lower(hemi{whichHemi}),repmat('Smoothed',1,smoothing),repmat('_BC',1,biasCorrect));

% mris_convert fsnative sphere to .gii
[~, cmdout] = system(['mris_convert ' toSphere ' ' toSphere '.gii'], '-echo');

% mris_convert fsnative midthickness to .gii
[~, cmdout] = system(['mris_convert ' toThickness ' ' toThickness '.gii'], '-echo');

% resample using wb_command 
command = sprintf('wb_command -metric-resample %s %s %s.gii ADAP_BARY_AREA %s.gii -area-surfs %s %s.gii', fromMyelin, fromSphere, toSphere, toMyelin, fromThickness, toThickness);
[~, cmdout] = system(command, '-echo');

% mris_convert .gii to .mgz
[~, cmdout] = system(['mri_convert ' toMyelin '.gii ' toMyelin2 '.mgz'], '-echo');

end


