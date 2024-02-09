% convert native data to percentile for plotting

%% define path
addpath(genpath('~/Documents/GitHub/cvncode'));
addpath(genpath('~/Documents/GitHub/wptoolbox'));
bidsDir = '/Volumes/Vision/MRI/recon-bank';

subs = {'sub-0037','sub-0037','sub-0201','sub-0248','sub-0255','sub-0392','sub-0397','sub-0426'};
whichFolder = 'myelin';
whichMgz = 'MyelinMap_BC'; %'MyelinMap_BC'; %'SmoothedMyelinMap_BC';
hemi = {'lh','rh'};
%%
for whichSub = 1:numel(subs)
    mgzPath = sprintf('%s/derivatives/%s/%s',bidsDir,whichFolder, subs{whichSub});
    for whichHemi = 1:2
    filename = fullfile(sprintf('%s/%s.%s.mgz',mgzPath,hemi{whichHemi},whichMgz));
    myfile = MRIread(filename);
    tmp = squeeze(myfile.vol);
    tmppos = tmp(tmp>0);
    tmpSort = sort(tmppos);
    [~, whichRank] = ismember(tmppos, tmpSort);
    tmp(tmp>0) = (50+(whichRank / length(tmp))*50)./100;
    tmp(tmp<=0) = 0;
    myfile.vol = tmp(:);
    MRIwrite(myfile, fullfile(sprintf('%s/%s.%s%s.mgz',mgzPath,hemi{whichHemi},whichMgz,'percentile')));
    end
end
