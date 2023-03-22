function showtimeseries(datafiles,dsCon,whichRoi,timeDur,pair,lim,nuisance)

% given samples and design matrix plot time series for each conditions

myColor = [1 0 0; 0 0 1];

for iCon = 1:size(pair,1)
    
    figure(iCon);%clf;
    hold on
    
    tmp = cellfun(@(m)m(whichRoi,:), datafiles, 'UniformOutput', 0);
    tmp = cellfun(@(m)100*(m-nanmean(m,2))./nanmean(m,2), tmp, 'UniformOutput', 0);
    tmp = cat(2,tmp{:})';
       
    label = cat(1,dsCon{:});
    
    
    for whichCon = 1:size(pair,2)
        
        whichTrial = find(label(:,pair(iCon,whichCon))==1);
        sample = zeros(numel(whichTrial),timeDur);
        for iTrial = 1:numel(whichTrial)
            sample(iTrial,:) = nanmean(tmp(whichTrial(iTrial):whichTrial(iTrial)+timeDur-1,:),2)';
        end
        
        plot(sample','Color',[myColor(whichCon,:) 0.3])
        plot(nanmean(sample',2),'Color',[myColor(whichCon,:) 1],'linewidth',2)
        ylim(lim)
    end
  
end

end