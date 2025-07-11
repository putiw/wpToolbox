% eeg2bids.m  –  convert three BrainVision runs to BIDS-EEG with FieldTrip
addpath('/Users/pw1246/Documents/MATLAB/fieldtrip');
ft_defaults;                               % initialise FieldTrip

srcRoot  = '...';
bidsRoot = '/Users/pw1246/Library/CloudStorage/Box-Box/EEG-FMRI/Data/fingertapping/rawdata';

subID    = '0665';
sesID    = '01';
taskName = 'fingertapping';

for run = 1:3
    vhdrFile = fullfile(srcRoot, ...
        sprintf('sub-%s/ses-%s/eeg/sub_%s_finger_tapping_redesign_%d.vhdr', ...
        subID, sesID, subID, run));

    cfg                 = [];
    cfg.method          = 'copy';      % keep original .vhdr/.eeg/.vmrk
    cfg.datatype        = 'eeg';
    cfg.dataset         = vhdrFile;

    cfg.bidsroot        = bidsRoot;    % *** mandatory ***
    cfg.sub             = subID;
    cfg.ses             = sesID;
    cfg.task            = taskName;
    cfg.run             = run;

    cfg.PowerLineFrequency = 50;       % UAE mains
    cfg.InstitutionName    = 'NYU Abu Dhabi';
    cfg.overwrite       = 'yes';
    
    % Add required BIDS fields with default values (user can modify if needed)
    cfg.dataset_description.Name = 'Fingertapping EEG-fMRI Dataset';
    cfg.EEGReference = 'n/a';      % User can replace with actual reference (e.g., 'Cz', 'left mastoid')
    cfg.SoftwareFilters = 'n/a';   % User can replace with actual filter info if available

    data2bids(cfg);                    % perform the conversion
end