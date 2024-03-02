function pw_save_mgh(subject,bidsDir,derivDir,val,valName,hemi)


lcurv = read_curv(fullfile(bidsDir,'derivatives/freesurfer',subject, 'surf', 'lh.curv'));
rcurv = read_curv(fullfile(bidsDir,'derivatives/freesurfer',subject, 'surf', 'rh.curv'));
leftidx  = 1:numel(lcurv);
rightidx = (1:numel(rcurv))+numel(lcurv);


resultsdir = [bidsDir '/derivatives/' derivDir '/' subject];
mkdir(resultsdir)


mgz = MRIread(fullfile(bidsDir,'derivatives/freesurfer',subject, 'mri', 'orig.mgz'));
mgz.vol = [];

if contains(hemi,'l')
    mgz.vol = val(leftidx);
    MRIwrite(mgz, fullfile(resultsdir, ['lh.' valName '.mgz']));
else
    mgz.vol = val(rightidx);
    MRIwrite(mgz, fullfile(resultsdir, ['rh.' valName '.mgz']));
end


end