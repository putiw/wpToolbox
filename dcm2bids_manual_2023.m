clear all
close all
clc

%% set path
sub = '0357';
ses = '01';
task = 'restingstate';
scanTask = 'restingstate';
dcmbin = '/Users/pw1246/Downloads/dcm2niix/console/dcm2niix';
projDir = '/Users/pw1246/Desktop/MRI/VRI/';
flyDir = '/Users/pw1246/Downloads/flywheel 3';


%% move flywheel dcm files into bids sourcedata

s1 = dir(sprintf('%s/*/*/*/*',flyDir));
s1 = [s1(end).folder '/' s1(end).name];
s2 = sprintf('%s%s/sub-%s_ses-%s_Br_%s',projDir,'sourcedata',sub,ses,task);
movefile(s1,s2);

%% dcm -> nii
scan = dir(s2);

rawDir = sprintf('%s%s/sub-%s/ses-%s/',projDir,'rawdata',sub,ses);

funcDir = sprintf('%s%s',rawDir,'func');
if ~exist(funcDir, 'dir')
    mkdir(funcDir)
end

anatDir = sprintf('%s%s',rawDir,'anat');
if ~exist(anatDir, 'dir')
    mkdir(anatDir)
end
%% 
for ii = 1:numel(scan)
    dcmDir = [scan(ii).folder '/' scan(ii).name];
    
    %% if current folder is func
    if contains(scan(ii).name,['func-bold_task-' scanTask '_run-'])
        
        % go into the folder and unzip the dicom files
        cd(dcmDir)
        system('unzip *')
        
        % dcm2niix
        system([dcmbin ' -b y -f %f -m y -o ' funcDir ' -s y -t y -z y ' dcmDir])
        
        % rename to BIDS format

        n1 = sprintf('%s/%s',funcDir,scan(ii).name);
        
        tmp = strsplit(n1,'_');
        n2 = sprintf('%s/%s',funcDir,['sub-' sub '_ses-' ses '_task-' task '_' char(tmp(contains(tmp,'run'))) '_bold']);
        
        movefile([n1 '.nii.gz'],[n2 '.nii.gz']);
        movefile([n1 '.json'],[n2 '.json']);
        
        delete([n1 '.txt']);
        % fix json file (add task names and re-format)
        
        str = fileread([n2 '.json']);
        val = jsondecode(str);
        
        val.TaskName = task;
        
        str = jsonencode(val);
        str = strrep(str, ',"', sprintf(',\n"'));
        str = strrep(str, '[{', sprintf('[\n{\n'));
        str = strrep(str, '}]', sprintf('\n}\n]'));
        fid = fopen([n2 '.json'],'w');
        fwrite(fid,str);
        fclose(fid);
        
    elseif strcmp(scan(ii).name,'anat-T1w') | strcmp(scan(ii).name,'anat-T2w')
        
        cd(dcmDir)
        system('unzip *')
        
        system([dcmbin ' -b y -f %f -m y -o ' anatDir ' -s y -t y -z y ' dcmDir])
        
        n1 = sprintf('%s/%s',anatDir,scan(ii).name);
        n2 = sprintf('%s/%s',anatDir,['sub-' sub '_ses-' ses '_' scan(ii).name(6:8)]);
        movefile([n1 '.nii.gz'],[n2 '.nii.gz']);
        movefile([n1 '.json'],[n2 '.json']);
        
        delete([n1 '.txt'])
    else
    end
end

% fmap

for ii = 1:numel(scan)
    
    if contains(scan(ii).name,'topup')
        
        dcmDir = [scan(ii).folder '/' scan(ii).name];
        
        cd(dcmDir)
        
        system('unzip *')
        
        outDir = sprintf('%s%s',rawDir,'fmap');
        if ~exist(outDir, 'dir')
            mkdir(outDir)
        end
        
        system([dcmbin ' -b y -f %f -m y -o ' outDir ' -s y -t y -z y ' dcmDir])
        
        
        n1 = sprintf('%s/%s',outDir,scan(ii).name);
        
        tmp = strsplit(n1,'_');
        n2 = sprintf('%s/%s',outDir,['sub-' sub '_ses-' ses '_' char(tmp(contains(tmp,'dir'))) '_' char(tmp(contains(tmp,'run'))) '_epi']);
        
                
        movefile([n1 '.nii.gz'],[n2 '.nii.gz']);
        movefile([n1 '.json'],[n2 '.json']);
        
        str = fileread([n2 '.json']);
        val = jsondecode(str);
        
        val.TaskName = task;
        
        funcfiles = dir(fullfile(funcDir, '*.nii.gz'));
        funcfiles = struct2cell(funcfiles);
        funcfiles = strcat(['ses-' ses '/func/'], funcfiles(1,:)');
        val.IntendedFor = funcfiles;
        
        str = jsonencode(val);
        
        str = strrep(str, ',"', sprintf(',\n"'));
        str = strrep(str, '[{', sprintf('[\n{\n'));
        str = strrep(str, '}]', sprintf('\n}\n]'));
        
        fid = fopen([n2 '.json'],'w');
        
        fwrite(fid,str);
        fclose(fid);
        delete([n1 '.txt'])
    end
    
end
