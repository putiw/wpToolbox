clearvars;close all;clc;

subject = 'sub-ms01';

bidsDir = '/Users/pw1246/Desktop/ms/MsBIDS';

whichHeader = {'StructName', 'NumVert', 'SurfArea', 'GrayVol', 'ThickAvg', 'ThickStd', 'MeanCurv', 'GausCurv', 'FoldInd', 'CurvInd'};
hemi = {'l','r'};

subjects = dir(fullfile(bidsDir,'rawdata','sub*'));
tic
for whichSub = 1%:numel(subjects)

    subject = subjects(whichSub).name;

    excelDir = sprintf('%s/derivatives/excel/%s',bidsDir,subject);
    mkdir(excelDir);
    excel = sprintf('%s/statsMat.xlsx',excelDir);

    for iH = 1:numel(hemi)
        fileID = fopen(sprintf('%s/derivatives/freesurfer/%s/stats/%sh.aparc.stats',bidsDir,subject,hemi{iH}));
        data = {};
        while ~feof(fileID)
            line = fgetl(fileID);
            if ~startsWith(line, '#')
                data = [data; textscan(line, '%s %f %f %f %f %f %f %f %f %f')];
            end
        end
        tmp = cell2table(data, 'VariableNames', whichHeader);
        writetable(tmp, excel, 'Sheet', [hemi{iH} ' hemi']);
    end
end
