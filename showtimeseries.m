function showtimeseries(datafiles,dsCon,whichVertices,nuisance,myColor)

% Inputs:
%     datafiles:        data stored in 1 by #runs cell matrix
%     dsCon:            designmatrix stored in 1 by #runs cell matrix
%     whichCon:         if there are multiple conditions in dsCon, specify
%                           which conditions to plot the timeseries -e.g. 1 or [1 5]
%     whichVertices:         idx of which vertices to plot -e.g. 300k by 1
%                           column vector where 1 means to plot this vertex
%     nuisance:         nuisance regressors

% Outputs:
%     showtimeseries plot


hold on

tmp = cellfun(@(m)m(logical(whichVertices),:), datafiles, 'UniformOutput', 0);
tmp = cellfun(@(m)100*(m-nanmean(m,2))./nanmean(m,2), tmp, 'UniformOutput', 0);
tmp = cat(2,tmp{:})';

label = cat(1,dsCon{:});

whichTrial = find(label(:,1)==1);

sample = zeros(numel(whichTrial),15);

for iTrial = 1:numel(whichTrial)
    sample(iTrial,1:numel(whichTrial(iTrial):min(whichTrial(iTrial)+14,numel(label)))) = nanmean(tmp(whichTrial(iTrial):min(whichTrial(iTrial)+14,numel(label)),:),2)';
end

plot(sample','-','Color',[myColor 0.1])
plot(nanmean(sample',2),'-','Color',myColor,'linewidth',2)

hold off

end