clearvars;close all;clc;
% MP2RAGE T1map to Myelin fsnative

% Assume you have ran recon-all on regular T1w
bidsDir = '/Users/pw1246/Desktop/ms/MsBIDS';
subject = 'sub-0001';

% set up path
addpath(genpath('/Users/pw1246/Documents/GitHub/presurfer'));
addpath(genpath('/Users/pw1246/Documents/GitHub/spm12'));
addpath(genpath('/Users/pw1246/Documents/GitHub/qMRLab-2.4.2'));
addpath(genpath('/Users/pw1246/Documents/GitHub/cvncode'));
home

subDir = sprintf('%s/derivatives/freesurfer',bidsDir);
setenv('SUBJECTS_DIR', subDir);
fslbinDir = '/Users/pw1246/fsl/share/fsl/bin/';
derivMRDir = sprintf('%s/derivatives/qMRLab/%s',bidsDir,subject);
derivMyeDir = sprintf('%s/derivatives/T1MapMyelin/%s',bidsDir,subject);
mkdir(derivMyeDir)
anatDir = sprintf('%s/rawdata/%s/ses-01/anat/%s_ses-01_',bidsDir,subject,subject);
% get files
UNI = sprintf('%sUNIT1.nii',anatDir); 
INV2 = sprintf('%sinv-2_part-mag_MP2RAGE.nii',anatDir); 

%% Step 1 - run qMRLab mp2rage model for T1 R1 Map and save to derivatives folder
Model = mp2rage;
Model.Prot.Hardware.Mat = 3;
Model.Prot.RepetitionTimes.Mat = [5;7.1e-3];
Model.Prot.Timing.Mat = [700e-3;2500e-3];
Model.Prot.Sequence.Mat = [4; 5];
Model.Prot.NumberOfShots.Mat = [88; 88];
data.MP2RAGE = load_nii_data(UNI);
FitResults = FitData(data,Model);
FitResultsSave_nii(FitResults,UNI,derivMRDir); 

%% Step 2 - run presurfer for denoise and brain mask - takes long time (15 min+)

try
    presurf_MPRAGEise(INV2,UNI);
catch
    UNI = [UNI '.gz'];
    INV2 = [INV2 '.gz'];
    presurf_MPRAGEise(INV2,UNI);

end
%presurf_INV2(INV2); % get a stripMask from INV2
%presurf_UNI(UNI_out);
