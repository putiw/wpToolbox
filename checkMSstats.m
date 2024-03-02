%clearvars;close all;clc;

subject = 'sub-ms01';

bidsDir = '/Volumes/Vision/MRI/recon-bank';

whichHeader = {'ThickAvg','MeanCurv'};
whichArea = {'caudalanteriorcingulate','isthmuscingulate','parahippocampal','posteriorcingulate','rostralanteriorcingulate'};
areaOrder = [3 2 4 1 5];
areaOrder = flip(areaOrder);

hemi = {'l','r'};
 
subjects = {'sub-0037','sub-0201','sub-0248','sub-0250','sub-0255','sub-0392','sub-0395','sub-0397','sub-0426'};

resultMat = zeros(numel(whichArea),numel(whichHeader),numel(subjects));
for whichSub = 1:numel(subjects)
    subject = subjects{whichSub};

    dataTable = readtable(sprintf('%s/derivatives/excel/%s/statsMat.xlsx',bidsDir,subject),'Sheet', 2);
    matchingRows = ismember(dataTable.StructName, whichArea);
    filteredData = dataTable(matchingRows, :);
    resultMat(:,:,whichSub) = table2array(filteredData(:, whichHeader));
end

subjects = {'sub-ms01'};
bidsDir = '/Volumes/Vision/UsersShare/Puti/MsBIDS';

testMat = zeros(numel(whichArea),numel(whichHeader),numel(subjects));
for whichSub = 1:numel(subjects)
    subject = subjects{whichSub};

    dataTable = readtable(sprintf('%s/derivatives/excel/%s/statsMat.xlsx',bidsDir,subject),'Sheet', 1);
    matchingRows = ismember(dataTable.StructName, whichArea);
    filteredData = dataTable(matchingRows, :);
    testMat(:,:,whichSub) = table2array(filteredData(:, whichHeader));
end

%% plot
mycolor = [116 91 138;
    113 16 107;
    10 112 31;
    205 165 191;
    69 17 113;
    ];

figure(1);clf;hold on;
set(gcf, 'Position', [100 500 900 600]);
for iH = 1:numel(whichHeader)
    for iArea = 1:numel(whichArea)
        iA = areaOrder(iArea);
        subplot(numel(whichHeader),numel(whichArea),(iH-1)*5+iArea);hold on;
        %title([upper(whichArea{iA}(1)), lower(whichArea{iA}(2:end))],'fontsize',20,'FontName', 'SF Display Pro','FontWeight','bold');
        plot([1;2],[mean(squeeze(resultMat(iA,iH,:))) testMat(iA,iH)],'-','Color','r','LineWidth',3);

        % plot([1;2],[mean(squeeze(resultMat(iA,iH,:))) testMat(iA,iH)],'-','Color','w','LineWidth',15);
        % plot([1;2],[mean(squeeze(resultMat(iA,iH,:))) testMat(iA,iH)],'-','Color',mycolor(iA,:)./255,'LineWidth',10);

        scatter(ones(9,1),squeeze(resultMat(iA,iH,:)),150,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'linewidth',2);
        scatter(2*ones(9,1),testMat(iA,iH),200,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'linewidth',2);
        %set(gca, 'xtick', [1, 2], 'xticklabel', {'Control', 'MS'});
        xlim([0.5 2.5])
        %title(whichHeader{iH})
        set(gca, 'fontsize',15,'FontWeight','bold','FontAngle', 'italic','linewidth',2);

        %set(gca, 'fontsize',15,'FontName', 'SF Display Pro','FontWeight','bold','FontAngle', 'italic','linewidth',2,'Color', 'k', 'XColor', 'w', 'YColor', 'w');
        set(gca, 'TickDir', 'out');
        set(gca, 'XTick', [], 'XTickLabel', []);
        drawnow
    end
end
