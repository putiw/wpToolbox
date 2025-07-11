function plot_bar(varargin)

mm = [];
se = [];
figure;hold on;
% Iterate through each variable input argument
for ii = 1:length(varargin)
    val = varargin{ii}; % Current matrix

    for whichBar = 1:size(val,2)
        scatter(whichBar,val(:,whichBar),5,'MarkerFaceColor','w','MarkerEdgeColor','k','LineWidth',1.5);
    end

    % Calculate mean and standard error for each column
    means = mean(val); % Compute mean for each column
    stdErr = std(val) ./ sqrt(size(val, 1)); % Compute SEM for each column

    % Append the results to mm and se matrices
    mm = [mm, means(:)]; % Convert row to column vector and append
    se = [se, stdErr(:)]; % Convert row to column vector and append
end

% Create the bar graph
b = bar(mm,'LineWidth',2,'FaceColor','none');

% Get the number of groups and the number of bars in each group
[numGroups, numBars] = size(mm);

% Calculate the width of each group of bars
groupWidth = min(0.8, numBars/(numBars + 1.5));

% Add error bars
for ii = 1:numBars
    % Calculate the center positions of the bars in group i
    x = (1:numGroups) - groupWidth/2 + (2*ii-1) * groupWidth / (2*numBars);
    % Place the error bars at the center positions with the specified standard errors
    errorbar(x, mm(:,ii), se(:,ii), 'r', 'linestyle', 'none','CapSize',0,'LineWidth',2);
end

hold off;

set(gca,'LineWidth',2)
xlabel('');
set(gca,'FontSize',15,'XColor','k','YColor','k');
set(gca, 'TickDir', 'out');
set(gca, 'XTick', [], 'XTickLabel', []);

end
