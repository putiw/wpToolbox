%% jubail to BIDS or BIDS to jubail

who2who = 2; % 1- bids to jubail 2- jubail to bids
giveCommand = 0; % 1 - don't run it, just print out command
% set up path
user = 'pw1246'; % username for jubail
JubailDir = '/scratch/pw1246/MRI/bigbids'; % hcp folder on jubail bigbids CueIntegration2023
bidsDir = '~/Documents/MRI/bigbids'; % bids dir
subs = '0395';
session = 'ses-01';
subject = ['sub-' subs];  % which subject

if who2who == 1
    inputDir = sprintf('%s/rawdata/sub-%s/%s',bidsDir,subs,session);
    outputDir = sprintf('%s@jubail.abudhabi.nyu.edu:%s/rawdata/sub-%s/',user,JubailDir,subs);
    command = ['rsync -av ' inputDir ' ' outputDir];
    if giveCommand == 1
        command
    else
        
        [~, cmdout] = system(command, '-echo');
    end

else

    inputDir = sprintf('%s@jubail.abudhabi.nyu.edu:%s/derivatives/fmriprep/%s/%s/func/',user,JubailDir,subject,session);
    outputDir = sprintf('%s/derivatives/fmriprep/%s/%s/func/',bidsDir,subject,session);
    
    if ~isfolder(outputDir), mkdir(outputDir); end
    % which file
    whichSpace = 'fsnative';

    % get file path for rsync

    whichFiles1 = sprintf('--include=''*-%s_*'' ', whichSpace);
    whichFiles2 = sprintf('--include=''*confounds_timeseries*'' ');

    % rsync from jubail to target bids
    command = ['rsync -av ' whichFiles1 whichFiles2 '--exclude=''*'' ' inputDir ' ' outputDir];
    if giveCommand == 1
        command
    else
        
        [~, cmdout] = system(command, '-echo');
    end

end




