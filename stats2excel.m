clearvars;close all;clc;

subject = 'sub-ms01';

bidsDir = '/Volumes/Vision/MRI/recon-bank';

whichHeader = {'StructName', 'NumVert', 'SurfArea', 'GrayVol', 'ThickAvg', 'ThickStd', 'MeanCurv', 'GausCurv', 'FoldInd', 'CurvInd'};
hemi = {'l','r'};

subjects = {'sub-0037','sub-0201','sub-0248','sub-0250','sub-0255','sub-0392','sub-0395','sub-0397','sub-0426'};

for whichSub = 1:numel(subjects)
    subject = subjects{whichSub};

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
