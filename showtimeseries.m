function showtimeseries(datafiles,dsCon,whichVertices,whichCon)

% modified 12/1/23 for VSS probably won't work for older scripts anymore

% mask data by roi
tmp = cellfun(@(m)m(logical(whichVertices),:), datafiles, 'UniformOutput', 0);
% convert to percentage signal change
%tmp = cellfun(@(m)100*(m-nanmean(m,2))./nanmean(m,2), tmp, 'UniformOutput', 0);
% combine across runs
tmp = cat(2,tmp{:})';

% get label across runs
label = cat(1,dsCon{:});
timelength = 35; % plot averaged timeseries across 30 seconds

avgTimeSeries =zeros(numel(whichCon),timelength);
for iC = 1:numel(whichCon) % loop through conditions and average them
    whichTrial = find(label(:, whichCon(iC))==1);
    sample = zeros(numel(whichTrial),timelength);
    for iTrial = 1:numel(whichTrial)
        sample(iTrial,1:numel(whichTrial(iTrial):min(whichTrial(iTrial)+timelength-1,size(label,1)))) = nanmean(tmp(whichTrial(iTrial):min(whichTrial(iTrial)+timelength-1,size(label,1)),:),2)';
    end
    avgTimeSeries(iC,:) = nanmean(sample',2);
end

if numel(whichCon) ~= 1
    avgTimeSeries = mean(avgTimeSeries);
end

plot(avgTimeSeries,'-','linewidth',2);
end