% get T1w to batch job structure

clear all;close all;clc;

bidsDir = '/Users/pw1246/Desktop/rawdata/Brainimaging_onlyt1w_cleaned/bi_anat_2024_001';
outputDir = '/Users/pw1246/Desktop/tmpT11';

subjects = dir(fullfile(bidsDir, 'sub-*'));

for ii = 1:numel(subjects)

    T1w = dir(fullfile(bidsDir,subjects(ii).name,'*','anat','*T1w.nii*'));

    if ~isempty(T1w)


        T1w = fullfile(T1w(1).folder,T1w(1).name);
        T1wnew = fullfile(outputDir,[subjects(ii).name,'.nii']);

        if ~exist(T1wnew)

            command = ['mri_convert ' T1w ' ' T1wnew];

            [~, cmdout] = system(command, '-echo');

        end

    end

end