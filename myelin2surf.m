clearvars;close all;clc;


bidsDir = '/Users/pw1246/Documents/MRI/bigbids';
setenv('SUBJECTS_DIR', [bidsDir '/derivatives/freesurfer']);
t1mapDir = '/Users/pw1246/Documents/MRI/bigbids/rawdata/sub-0201/ses-01/anat/sub-0201_ses-01_T1Map.nii.gz';
subject = 'sub-02481';
outDir = [bidsDir '/derivatives/T1MapMyelin/' subject];
mkdir(outDir);

for ii = 0:0.1:1
whatFrac = ii;
cmd = sprintf('mri_vol2surf --src %s --hemi lh --out %s/lh.myelin%s.mgh --cortex --regheader %s --projfrac %s',t1mapDir,outDir,num2str(whatFrac),subject,num2str(whatFrac));
system(cmd)

cmd = sprintf('mri_vol2surf --src %s --hemi rh --out %s/rh.myelin%s.mgh --cortex --regheader %s --projfrac %s',t1mapDir,outDir,num2str(whatFrac),subject,num2str(whatFrac));
system(cmd)

lvals = MRIread(sprintf('%s/lh.myelin%s.mgh',outDir,num2str(whatFrac)));
lvals = squeeze(lvals.vol)';
rvals = MRIread(sprintf('%s/rh.myelin%s.mgh',outDir,num2str(whatFrac)));
rvals = squeeze(rvals.vol)';
vals = [lvals;rvals];
fsdirFROM = [bidsDir '/derivatives/freesurfer/' subject];
fsdirTO = [bidsDir '/derivatives/freesurfer/sub-0201'];
[~, f1, f2] = convert_surf(fsdirFROM,fsdirTO,vals);

serverDir = '/Volumes/Vision/MRI/recon-bank';
resultDir = [serverDir '/derivatives/T1MapMyelin/sub-0201'];
mkdir(resultDir);
tmp = MRIread([serverDir '/derivatives/myelin/sub-0201/lh.MyelinMap.mgz']);
tmp.vol = f1;
MRIwrite(tmp,[resultDir '/lh.vmyelin' num2str(whatFrac) '.mgz']);
tmp = MRIread([serverDir '/derivatives/myelin/sub-0201/rh.MyelinMap.mgz']);
tmp.vol = f2;
MRIwrite(tmp,[resultDir '/rh.vmyelin' num2str(whatFrac) '.mgz']);
end
%%
%view_fv(subject,serverDir,['T1MapMyelin/myelin' num2str(whatFrac)]);

view_fv(subject,serverDir,'T1MapMyelin/myelin0.3','T1MapMyelin/myelin0.2','T1MapMyelin/myelin0.1','mt+2','cd2')
view_fv(subject,serverDir,'T1MapMyelin/myelin0.35','T1MapMyelin/myelin0.55');