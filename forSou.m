clear all;close all;clc;


bidsDir = '/Users/pw1246/Desktop';

whichHeader = {'Index', 'SegId', 'NVoxels', 'Volume_mm3', 'StructName', 'normMean', 'normStdDev', 'normMin', 'normMax', 'normRange'};

groupVal = [];
subjects = dir(fullfile(bidsDir,'derivatives','freesurfer740','sub*'));
tic
for whichSub = 1:numel(subjects)

    subjectID = subjects(whichSub).name;

    asegPath = fullfile(bidsDir,'derivatives','freesurfer740',subjectID,'stats','aseg.stats')

    if isfile(asegPath)

        % part I

        fileID = fopen(asegPath);
        valName = {};
        valval = {};
        while ~feof(fileID)
            line = fgetl(fileID);
            if startsWith(line, '# Measure')
                splitLine = split(line, ', ');
                valName = [valName; splitLine{2}];
                valval = [valval; str2double(splitLine{4})];
            end
        end

        % part II

        fileID = fopen(asegPath);
        data = {};
        while ~feof(fileID)
            line = fgetl(fileID);
            if ~startsWith(line, '#')
                data = [data; textscan(line, '%f %f %f %f %s %f %f %f %f %f')];
            end
        end

        excelVal = [subjectID; valval; data(:,4)];
        excelName = ['Subject'; valName; data(:,5)];
        excelName = cellfun(@char, excelName, 'UniformOutput', false);

        groupVal = [groupVal;excelVal'];
    end

end

%%

   tmp = cell2table(groupVal, 'VariableNames', excelName);
   % 

     excel = '/Users/pw1246/Desktop/basNorm/statsMat_ARI_740.xlsx';
    writetable(tmp, excel);