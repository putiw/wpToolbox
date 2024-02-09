function [data, betas, R2] = get_beta(datafiles,dsm,myNoise)

data = cell(1,numel(datafiles));
betas = cell(1,numel(datafiles));
R2 = cell(1,numel(datafiles));

for iRun  = 1:numel(datafiles)

    % X(isnan(X))=0;
    X = [dsm{iRun} myNoise{iRun}];
    tmp = ((datafiles{iRun}./mean(datafiles{iRun},2))-1)*100;
    betas{iRun} = (pinv(X) * tmp')';

    data{iRun} = (X(:,1:size(dsm{iRun},2)) * betas{iRun}(:,1:size(dsm{iRun},2))')'; % y_hat from only design matrix no noise
    %data{iRun} = tmp; % y%
    %data{iRun} = (X * betas{iRun}')'; % y_hat

    % % % Regress out the effect of myNoise from the data
     % myNoiseEffect = (X(:,size(dsm{iRun},2)+1:end) * betas{iRun}(:,size(dsm{iRun},2)+1:end)')';
     % data{iRun} = tmp - myNoiseEffect; % y - y_noise_hat
     % 
    %data{iRun} = myNoiseEffect; % just the noise
end
