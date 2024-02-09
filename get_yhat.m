function [yhat, yhatline] = get_yhat(betas,whichVertices)

yhat = cell(1,size(betas,2));

for iRun = 1:size(betas,2)
    ds = zeros(315,1);
    ds(1:30:300,1) = 1;
    ds(16:30:300,2) = 1;

    hrf = getcanonicalhrf(10,1);
    X = zeros(size(ds,1), 2);
    for i = 1:size(ds, 2)
        temp = conv(ds(:, i), hrf);
        X(:, i) = temp(1:size(ds,1));
    end
    %X = dsm{iRun};
    yhat{iRun} = (X * betas{iRun}(:,1:size(X,2))')'; % y_hat from only design matrix no noise

end

yhatline = mean(cell2mat(cellfun(@(x) x(whichVertices,:), yhat', 'UniformOutput', false)));

