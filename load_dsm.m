function [dsm, ds1, ds2, myNoise] = load_dsm(t)

% dsm - dsm matrix convolved with hrf
% ds1 - dsm matrix without convolving with hrf - 1s during onset
% ds2 - dsm matrix without convolving with hrf - 1s only at first TR after onset

nRuns = size(t,1);
dsm = cell(1,nRuns); % initialize for all the runs
ds1 = cell(1,nRuns);
ds2 = cell(1,nRuns);
myNoise = cell(1,nRuns); % initialize for all the runs

for iRun = 1:nRuns

    % condition onset

    switch t.task{1}
        case 'motion'
            ds = repelem(repmat(eye(4),3,1),2,1);
            ds(2:2:end,:) = repmat([0 0 0 0],size(ds,1)/2,1);
            ds = [ds repmat([0;1],size(ds,1)/2,1)];
            % make a version of design matrix that only first TR after
            % onset is 1 and the rest is 0
            ds0 = zeros(size(ds,1)*t.blockDur(iRun),size(ds,2)); 
            for ii = 1:size(ds,1)
                ds0(t.blockDur(iRun)*ii-t.blockDur(iRun)+1, :) = ds(ii,:);
            end
            % go back making the old version of design matrix, 1 for onset
            ds = repelem(ds,t.blockDur(iRun),1);
            if strcmp(t.subject{1}, 'sub-0392') && t.version(iRun) == 2
                ds = ds(1:t.nCon(iRun)*t.blockDur(iRun)*t.nRep(iRun)+t.mod(iRun),:);
                ds(end-t.mod(iRun):end,:) = 0;
                ds0 = ds(1:t.nCon(iRun)*t.blockDur(iRun)*t.nRep(iRun)+t.mod(iRun),:);
                ds0(end-t.mod(iRun):end,:) = 0;
            else
                ds = [ds; zeros(t.mod(iRun),size(ds,2))];
                ds0 = [ds0; zeros(t.mod(iRun),size(ds0,2))];
            end

        otherwise
            ds = repmat(eye(t.nCon(iRun)),t.nRep(iRun),1);
            ds0 = zeros(size(ds,1)*t.blockDur(iRun),size(ds,2)); 
            for ii = 1:size(ds,1)
                ds0(t.blockDur(iRun)*ii-t.blockDur(iRun)+1,:) = ds(ii,:);
            end
            ds0 = [ds0;zeros(t.mod(iRun),t.nCon(iRun))];
            ds = [repmat(repelem(eye(t.nCon(iRun)),t.blockDur(iRun),1),t.nRep(iRun),1);zeros(t.mod(iRun),t.nCon(iRun))];

    end
    hrf = getcanonicalhrf(1,1);
    % Initialize the convolved design matrix
    ds_conv = zeros(size(ds,1), 2);
    for i = 1:size(ds, 2)
        temp = conv(ds(:, i), hrf);
        % Truncate the convolution result to match the length of the original data
        ds_conv(:, i) = temp(1:size(ds,1));
    end
    dsm{iRun} = ds_conv;
    ds1{iRun} = ds;
    ds2{iRun} = ds0;

    const = ones(size(ds,1),1);

    % linear drift

    ldrift = 1:size(ds,1);

    % noise

    subDir = sprintf('%s/derivatives/fmriprep/%s/%s/func',t.bids{iRun},t.subject{iRun},t.session{iRun});

    switch t.task{1}
        case 'loc'
            fileName = sprintf('%s/%s_%s_task-%s_run-%s_desc-confounds_timeseries.tsv',subDir,t.subject{iRun},t.session{iRun},t.task{iRun},num2str(t.run(iRun)));

        otherwise
            fileName = sprintf('%s/%s_%s_task-%s_dir-PA_run-%s_desc-confounds_timeseries.tsv',subDir,t.subject{iRun},t.session{iRun},t.task{iRun},num2str(t.run(iRun)));

    end


    tmpregressor = readtable(fileName, 'FileType', 'text', 'Delimiter', '\t');
    % whichRegressor = {'trans_x', 'trans_y', 'trans_z', 'rot_x', 'rot_y', 'rot_z', ...
    %               'trans_x_derivative1', 'trans_y_derivative1', 'trans_z_derivative1', 'rot_x_derivative1', 'rot_y_derivative1', 'rot_z_derivative1', ...
    %               'trans_x_power2', 'trans_y_power2', 'trans_z_power2', 'rot_x_power2', 'rot_y_power2', 'rot_z_power2', ...
    %               'global_signal', 'white_matter', 'csf', ...
    %               'global_signal_derivative1', 'white_matter_derivative1', 'csf_derivative1', ...
    %               'global_signal_power2', 'white_matter_power2', 'csf_power2'};
    whichRegressor = {'trans_x', 'trans_y', 'trans_z', 'rot_x', 'rot_y', 'rot_z', ...
                  'global_signal', 'white_matter', 'csf'};    
    tmpregressor = table2array(tmpregressor(:,whichRegressor));
   
    myNoise{iRun} = [const ldrift' tmpregressor];

end




%%