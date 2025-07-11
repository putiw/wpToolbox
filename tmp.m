% Script to merge validation data with flexible ID matching
% Handles various ID format differences

clear; clc;

% File paths
validation_file = '/Users/pw1246/Desktop/projects/xnatpipeline/validation_summary.xlsx';
project_file = '/Users/pw1246/Desktop/projects/xnatpipeline/Intl Data Sharing Project.xlsx';
output_file = '/Users/pw1246/Desktop/projects/xnatpipeline/Intl Data Sharing Project_updated.xlsx';

% Read the files
fprintf('Reading validation summary...\n');
validation_data = readtable(validation_file, 'Sheet', 'Validation Results');

fprintf('Reading International Data Sharing Project file...\n');
project_data = readtable(project_file);

% Display sample IDs to understand format
fprintf('\nSample validation IDs:\n');
for i = 1:min(5, height(validation_data))
    fprintf('  %s\n', char(validation_data.SubjectID(i)));
end

fprintf('\nSample project IDs:\n');
for i = 1:min(5, height(project_data))
    if isnumeric(project_data.SubjectID(i))
        fprintf('  %d\n', project_data.SubjectID(i));
    else
        fprintf('  %s\n', char(project_data.SubjectID(i)));
    end
end

% Function to normalize subject IDs
normalize_id = @(id) regexprep(char(string(id)), '[^0-9]', '');

% Normalize validation IDs
validation_subjects = validation_data.SubjectID;
validation_ids_normalized = cell(size(validation_subjects));
for i = 1:length(validation_subjects)
    id = char(validation_subjects(i));
    % Remove 'sub-' prefix and any non-numeric characters
    id_num = normalize_id(id);
    validation_ids_normalized{i} = id_num;
end

% Normalize project IDs
project_subjects = project_data.SubjectID;
project_ids_normalized = cell(height(project_data), 1);
for i = 1:height(project_data)
    if isnumeric(project_subjects(i))
        id_num = sprintf('%d', project_subjects(i));
    else
        id_num = normalize_id(project_subjects(i));
    end
    project_ids_normalized{i} = id_num;
end

% Display normalized samples
fprintf('\nNormalized validation IDs:\n');
for i = 1:min(5, length(validation_ids_normalized))
    fprintf('  Original: %s -> Normalized: %s\n', char(validation_subjects(i)), validation_ids_normalized{i});
end

fprintf('\nNormalized project IDs:\n');
for i = 1:min(5, length(project_ids_normalized))
    if isnumeric(project_subjects(i))
        fprintf('  Original: %d -> Normalized: %s\n', project_subjects(i), project_ids_normalized{i});
    else
        fprintf('  Original: %s -> Normalized: %s\n', char(project_subjects(i)), project_ids_normalized{i});
    end
end

% Add new columns to project data
columns_to_add = {
    'Validation_Status', 'Overall_Status';
    'Total_Missing_Files', 'Total_Missing_Files';
    'ANAT_Missing', 'ANAT_Missing';
    'FUNC_Missing', 'FUNC_Missing';
    'FMAP_Missing', 'FMAP_Missing';
    'DWI_Missing', 'DWI_Missing';
    'PERF_Missing', 'PERF_Missing';
    'Has_Property_Issues', 'Has_Property_Issues';
    'DWI_Parameters_Status', 'DWI_Parameters';
    'Sbref_Direction_Status', 'Sbref_Direction';
    'IntendedFor_Status', 'IntendedFor';
    'Missing_Files_Details', 'Missing_Files_List';
    'Unexpected_Files_Count', 'Total_Unexpected_Files'
};

% Initialize columns
for i = 1:size(columns_to_add, 1)
    new_col = columns_to_add{i, 1};
    if ~ismember(new_col, project_data.Properties.VariableNames)
        if contains(new_col, 'Status') || contains(new_col, 'Details')
            project_data.(new_col) = repmat({''}, height(project_data), 1);
        else
            project_data.(new_col) = NaN(height(project_data), 1);
        end
    end
end

% Match and fill data
matched_count = 0;
not_found_subjects = {};
match_details = {};

for i = 1:length(validation_ids_normalized)
    val_id_norm = validation_ids_normalized{i};
    val_id_orig = char(validation_subjects(i));
    
    % Try different matching strategies
    match_idx = [];
    
    % 1. Exact match on normalized IDs
    match_idx = find(strcmp(project_ids_normalized, val_id_norm));
    
    % 2. If no match, try with leading zeros removed
    if isempty(match_idx) && ~isempty(val_id_norm)
        val_id_no_zeros = regexprep(val_id_norm, '^0+', '');
        for j = 1:length(project_ids_normalized)
            proj_id_no_zeros = regexprep(project_ids_normalized{j}, '^0+', '');
            if strcmp(val_id_no_zeros, proj_id_no_zeros)
                match_idx = j;
                break;
            end
        end
    end
    
    % 3. If still no match, try numeric comparison
    if isempty(match_idx) && ~isempty(val_id_norm)
        val_num = str2double(val_id_norm);
        if ~isnan(val_num)
            for j = 1:length(project_ids_normalized)
                proj_num = str2double(project_ids_normalized{j});
                if ~isnan(proj_num) && val_num == proj_num
                    match_idx = j;
                    break;
                end
            end
        end
    end
    
    if ~isempty(match_idx)
        matched_count = matched_count + 1;
        if length(match_idx) > 1
            match_idx = match_idx(1); % Take first match if multiple
        end
        
        % Record match details
        if isnumeric(project_subjects(match_idx))
            match_details{end+1} = sprintf('Validation: %s -> Project: %d', val_id_orig, project_subjects(match_idx));
        else
            match_details{end+1} = sprintf('Validation: %s -> Project: %s', val_id_orig, char(project_subjects(match_idx)));
        end
        
        % Fill in the validation data
        for j = 1:size(columns_to_add, 1)
            project_col = columns_to_add{j, 1};
            validation_col = columns_to_add{j, 2};
            
            if ismember(validation_col, validation_data.Properties.VariableNames)
                value = validation_data.(validation_col)(i);
                
                % Handle different data types
                if iscell(value)
                    project_data.(project_col)(match_idx) = value;
                elseif isstring(value)
                    project_data.(project_col)(match_idx) = {char(value)};
                elseif isnumeric(value)
                    project_data.(project_col)(match_idx) = value;
                elseif islogical(value)
                    project_data.(project_col)(match_idx) = value;
                end
            end
        end
        
        if mod(matched_count, 10) == 0
            fprintf('Processed %d subjects...\n', matched_count);
        end
    else
        not_found_subjects{end+1} = val_id_orig;
    end
end

% Summary
fprintf('\n=== Summary ===\n');
fprintf('Total validation subjects: %d\n', length(validation_subjects));
fprintf('Successfully matched: %d\n', matched_count);
fprintf('Not found in project data: %d\n', length(not_found_subjects));

% Show some successful matches
if matched_count > 0
    fprintf('\nExample successful matches:\n');
    for i = 1:min(5, length(match_details))
        fprintf('  %s\n', match_details{i});
    end
end

% Show unmatched subjects
if ~isempty(not_found_subjects)
    fprintf('\nExamples of unmatched validation subjects:\n');
    for i = 1:min(10, length(not_found_subjects))
        fprintf('  %s\n', not_found_subjects{i});
    end
    if length(not_found_subjects) > 10
        fprintf('  ... and %d more\n', length(not_found_subjects) - 10);
    end
end

% Save the updated file
fprintf('\nSaving updated project file...\n');
writetable(project_data, output_file);

% Create detailed merge report
merge_report = table();
merge_report.Metric = {'Total Validation Subjects'; 'Total Project Subjects'; 'Successfully Matched'; 
                       'Validation Not In Project'; 'Project Without Validation'};
merge_report.Count = [length(validation_subjects); height(project_data); matched_count; 
                      length(not_found_subjects); height(project_data) - matched_count];

% Add unmatched lists
if ~isempty(not_found_subjects)
    unmatched_table = table(not_found_subjects', 'VariableNames', {'UnmatchedValidationSubjects'});
    writetable(unmatched_table, output_file, 'Sheet', 'UnmatchedSubjects');
end

writetable(merge_report, output_file, 'Sheet', 'MergeReport');

fprintf('Updated file saved to: %s\n', output_file);
fprintf('\nMerge complete! Check the updated file for results.\n');