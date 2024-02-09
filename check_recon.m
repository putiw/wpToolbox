clearvars;close all;clc;
whichHeader = {'StructName', 'NumVert', 'SurfArea', 'GrayVol', 'ThickAvg', 'ThickStd', 'MeanCurv', 'GausCurv', 'FoldInd', 'CurvInd'};
subjDir = '/Users/pw1246/Documents/MRI/tmpBIDS/derivatives/freesurfer';
whichRecon = {'','-UNI-recon-noSkull','-UNI-fMRIPrep-withSkull'};
hemi = {'l','r'};
plotThis = {'NumVert', 'SurfArea', 'GrayVol', 'ThickAvg'};
figure(1);clf
for iP = 1:numel(plotThis)
    ThickMat = zeros(34,6);
    for iR = 1:numel(whichRecon)
        for iH = 1:numel(hemi)
            fileID = fopen(sprintf('%s/sub-0201%s/stats/%sh.aparc.stats',subjDir,whichRecon{iR},hemi{iH}), 'r');
            data = {};
            while ~feof(fileID)
                line = fgetl(fileID);
                if ~startsWith(line, '#')
                    data = [data; textscan(line, '%s %f %f %f %f %f %f %f %f %f')];
                end
            end
            ThickMat(:,(iR-1)*2+iH) = cell2mat(data(:,find(strcmpi(whichHeader, plotThis{iP}))));
        end
    end

    whichPlot = [1 5];
    for ii = 1:2
        subplot(2,4,(ii-1)*4+iP)
        whichPlot = whichPlot + ii - 1;
        ax = gca;
        scatter(ThickMat(:,whichPlot(1)),ThickMat(:,whichPlot(2)),'filled')
        rval = corr(ThickMat(:,whichPlot));
        xlim([min(min(ThickMat(:,whichPlot))) max(max(ThickMat(:,whichPlot)))])
        ylim([min(min(ThickMat(:,whichPlot))) max(max(ThickMat(:,whichPlot)))])
        xlabel('T1w')
        ylabel('UNIT1')
        text(ax.XLim(2), ax.XLim(1), ['r = ' num2str(round(rval(1,2),3))], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
        text(ThickMat(:,whichPlot(1)),ThickMat(:,whichPlot(2)),vertcat(data{:,1}))
        title(plotThis{iP})
        axis square
    end
end
set(findall(gcf, 'Type', 'text'), 'FontSize', 18);
