clearvars;close all;clc;
% MP2RAGE T1map to Myelin fsnative

% Assume you have ran recon-all on regular T1w
bidsDir = '/Volumes/Vision/MRI/recon-bank';
subject = 'sub-0426';

whichFiles = {'T1w', 'UNIT1'}; % find where these two scans are 
filePath = cell(2,2);
for ii = 1:length(whichFiles)
    files = dir(fullfile(bidsDir, 'rawdata', subject, 'ses-*', 'anat', [subject '_ses-*_' whichFiles{ii} '.nii*']));
    if ~isempty(files)
        session = regexp(files(1).folder, 'ses-\d+', 'match', 'once');
        filePath{ii,1} = sprintf('%s/rawdata/%s/%s/anat/%s_%s_',bidsDir,subject,session,subject,session);
        filePath{ii,2} = sprintf('%s/rawdata/%s/%s/anat/',bidsDir,subject,session);
        filePath{ii,3} = sprintf('%s_%s_',subject,session);
    end
end
% set up path
addpath(genpath('/Users/pw1246/Documents/GitHub/presurfer'));
addpath(genpath('/Users/pw1246/Documents/GitHub/spm12'));
addpath(genpath('/Users/pw1246/Documents/GitHub/qMRLab-2.4.2'));
addpath(genpath('/Users/pw1246/Documents/GitHub/cvncode'));
home
% gitrepos = {'~/Documents/GitHub/presurfer', 'https://github.com/srikash/presurfer.git';...
%     '~/Documents/GitHub/spm12', 'https://github.com/spm/spm12.git'};
% for ii = 1:size(gitrepos, 1)
%     if ~exist(gitrepos{ii, 1}, 'dir')
%         system(['git clone ' gitrepos{ii, 2} ' ' gitrepos{ii, 1}]);
%     end
%     addpath(genpath(gitrepos{ii, 1}));
% end
subDir = sprintf('%s/derivatives/freesurfer',bidsDir);
setenv('SUBJECTS_DIR', subDir);
fslbinDir = '/Users/pw1246/fsl/share/fsl/bin/';
derivMRDir = sprintf('%s/derivatives/qMRLab/%s',bidsDir,subject);
derivMyeDir = sprintf('%s/derivatives/T1MapMyelin/%s',bidsDir,subject);
mkdir(derivMyeDir)
% get files
UNI = sprintf('%sUNIT1.nii.gz',filePath{2,1}); 
R1map = sprintf('%s/R1.nii.gz',derivMRDir); 
INV2 = sprintf('%sinv-2_MP2RAGE.nii.gz',filePath{2,1}); 
UNI_out = sprintf('%spresurf_MPRAGEise/%sUNIT1_MPRAGEised.nii',filePath{2,2},filePath{2,3}); 
stripmask = sprintf('%spresurf_INV2/%sinv-2_MP2RAGE_stripmask.nii',filePath{2,2},filePath{2,3});  
R1mapBrain = sprintf('%s/R1MapBrain.nii.gz',derivMRDir); 
refT1w = sprintf('%s/%s/mri/brain',subDir,subject); 
R1mapT1w = sprintf('%s/R1Map_in_T1w.nii.gz',derivMRDir); 

%% Step 1 - run qMRLab mp2rage model for T1 R1 Map and save to derivatives folder
Model = mp2rage;
Model.Prot.Hardware.Mat = 3;
Model.Prot.RepetitionTimes.Mat = [5;7.14e-3];
Model.Prot.Timing.Mat = [700e-3;2500e-3];
Model.Prot.Sequence.Mat = [4; 5];
Model.Prot.NumberOfShots.Mat = [88; 88];
data.MP2RAGE = load_nii_data(UNI);
FitResults = FitData(data,Model);
FitResultsSave_nii(FitResults,UNI,derivMRDir); 

%% Step 2 - run presurfer for denoise and brain mask - takes long time (15 min+)
if isfile(UNI_out)
else
%presurf_MPRAGEise(INV2,UNI); % remove background noise
presurf_INV2(INV2); % get a stripMask from INV2
%presurf_UNI(UNI_out);
end

%% Step 3 - R1Map to fsnative
% skull strip
system(sprintf('%sfslmaths %s -mul %s %s',fslbinDir, R1map, stripmask, R1mapBrain));

% flirt vol to vol T1(R1) map to T1w
system(sprintf('mri_convert %s.mgz %s.nii.gz',refT1w, refT1w));
system(sprintf('%sflirt -in %s -ref %s.nii.gz -out %s',fslbinDir, R1mapBrain, refT1w, R1mapT1w));

%% vol to surf - fsnative 
for whatFrac = 0.1;
% vol2surf T1 map to fsnative --projfrac-avg 0 1 %s --projfrac-avg 0.1 0.8
% --projfrac 0.5 
system(sprintf('mri_vol2surf --src %s --hemi lh --out %s/lh.myelin%s.mgz --regheader %s --cortex --projfrac-avg 0 1 %s',R1mapT1w,derivMyeDir,num2str(whatFrac),subject,num2str(whatFrac)));
system(sprintf('mri_vol2surf --src %s --hemi rh --out %s/rh.myelin%s.mgz --regheader %s --cortex  --projfrac-avg 0 1 %s',R1mapT1w,derivMyeDir,num2str(whatFrac),subject,num2str(whatFrac)));
end
%h=view_fv(subject,bidsDir,'rh','T1MapMyelin/myelin0.1','T1MapMyelin/myelin0.5');
%% regress out curvature?
% lcurv = read_curv(fullfile(subDir,subject, 'surf', 'lh.curv'));
% rcurv = read_curv(fullfile(subDir,subject, 'surf', 'rh.curv'));
% curv = [lcurv;rcurv];
% myelinVal = load_mgz(subject,bidsDir,'T1MapMyelin/myelin0.1');
% curv = [ones(length(curv), 1) curv]; 
% [~, ~, residuals, ~, ~] = regress(myelinVal, curv);
% tmp = MRIread([bidsDir '/derivatives/T1MapMyelin/' subject '/lh.myelin0.1.mgz']);
% tmp.vol = residuals(1:numel(lcurv),1);
% MRIwrite(tmp,[bidsDir '/derivatives/T1MapMyelin/' subject '/lh.myelin0.1_nocurv.mgz']);
% tmp = MRIread([bidsDir '/derivatives/T1MapMyelin/' subject '/rh.myelin0.1.mgz']);
% tmp.vol = residuals(numel(lcurv)+1:end,1);
% MRIwrite(tmp,[bidsDir '/derivatives/T1MapMyelin/' subject '/rh.myelin0.1_nocurv.mgz']);
% %%
% view_fv(subject,bidsDir,'rh','T1MapMyelin/myelin0.1','T1MapMyelin/myelin0.1_nocurv');
% %% Step 4 - if we ran recon-all on UNIT1
% % we do vol2surf and then surf2surf
% 
% R1map = sprintf('%s/R1.nii.gz',derivMRDir); 
% subject = 'sub-0248';
% subjectUNI = 'sub-02481';
% outDir = [bidsDir '/derivatives/T1MapMyelin/' subject];
% mkdir(outDir);
% 
% for whatFrac = 0.1
% cmd = sprintf('mri_vol2surf --src %s --hemi lh --out %s/lh.myelin%s.mgh --cortex --regheader %s --projfrac %s',R1map,outDir,num2str(whatFrac),subjectUNI,num2str(whatFrac));
% system(cmd)
% cmd = sprintf('mri_vol2surf --src %s --hemi rh --out %s/rh.myelin%s.mgh --cortex --regheader %s --projfrac %s',R1map,outDir,num2str(whatFrac),subjectUNI,num2str(whatFrac));
% system(cmd)
% 
% lvals = MRIread(sprintf('%s/lh.myelin%s.mgh',outDir,num2str(whatFrac)));
% lvals = squeeze(lvals.vol)';
% rvals = MRIread(sprintf('%s/rh.myelin%s.mgh',outDir,num2str(whatFrac)));
% rvals = squeeze(rvals.vol)';
% vals = [lvals;rvals];
% fsdirFROM = [bidsDir '/derivatives/freesurfer/' subjectUNI];
% fsdirTO = [bidsDir '/derivatives/freesurfer/' subject];
% [~, f1, f2] = convert_surf(fsdirFROM,fsdirTO,vals);
% 
% tmp = MRIread([bidsDir '/derivatives/myelin/' subject '/lh.MyelinMap.mgz']);
% tmp.vol = f1;
% MRIwrite(tmp,[outDir '/lh.vmyelin' num2str(whatFrac) '.mgz']);
% tmp = MRIread([bidsDir '/derivatives/myelin/' subject '/rh.MyelinMap.mgz']);
% tmp.vol = f2;
% MRIwrite(tmp,[outDir '/rh.vmyelin' num2str(whatFrac) '.mgz']);
% end
% 

 %%
view_fv(subject,bidsDir,'mt+2','T1MapMyelin/myelin0.1');
 %%
% %%
% view_fv(subject,'/Volumes/Vision/MRI/recon-bank','mt+2','T1MapMyelin/myelin0.05','T1MapMyelin/myelin0.1','T1MapMyelin/myelin0.15','T1MapMyelin/myelin0.2','T1MapMyelin/myelin0.25','T1MapMyelin/myelin0.75');
% view_fv(subject,'/Volumes/Vision/MRI/recon-bank','T1MapMyelin/myelin0.1','T1MapMyelin/myelin0.3');
% %%
%view_fv(subject,'/Volumes/Vision/MRI/recon-bank','mt+2','cd2','T1MapMyelin/myelin0.1','T1MapMyelin/vmyelin0.1')
% 
% h=view_fv(subject,'/Volumes/Vision/MRI/recon-bank','l','mt+2')
% 




%%

