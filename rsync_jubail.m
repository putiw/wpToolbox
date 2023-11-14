%% jubail to BIDS or BIDS to jubail

who2who = 1; % 1- bids to jubail 2- jubail to bids
giveCommand = 0; % 1 - don't run it, just print out command
% set up path
user = 'pw1246'; % username for jubail
JubailDir = '/scratch/pw1246/MRI/FSTLoc'; % hcp folder on jubail
bidsDir = '/Users/pw1246/Desktop/MRI/bigbids'; % bids dir
rawdata = '/Users/pw1246/Desktop/MRI/bigbids/rawdata'
subs = '0201';
session = 'ses-04';
subject = ['sub-' subs];  % which subject

if who2who == 1
    inputDir = sprintf('%s/rawdata/%s/%s',bidsDir,subject,session);
    outputDir = sprintf('%s@jubail.abudhabi.nyu.edu:%s/rawdata/%s/',user,JubailDir,subject);
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




