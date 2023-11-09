function run_power_anova(effectSize, nGroups, alpha, power)

% this scripts calculate the sample size needed to reach a certain power
% given alpha, effect size, power, and number of groups
% this assumes you already have the effect size calculated somewhere else
% the effect size can be cohen's d for two groups, or cohen's f for three
% and more. 
% cohen's f = sqrt(eta^2/(1-eta^2)) or something like that
% eta is a direct output from anova -> or SSB/SST -> both output from anova
   
nSub = 1; % assume we have one sub first and increase it until we get what we need
powerNow = 0; % assume we have no power now
while powerNow < power
    nSub = nSub + 1; % add a new sub
    nTotal = nSub * nGroups; % total sub across groups
    lambda = (nSub * effectSize^2); % non-centrality parameter lambda (use this one for (1 by n) anova)
    betweenDF = nGroups - 1; % between group degrees of freedom for the anova
    withinDF = nTotal-nGroups; % within-group degrees of freedom for the anova
    criticalVal = finv(1-alpha, betweenDF, withinDF);
    type2err = ncfcdf(criticalVal, betweenDF, withinDF, lambda);
    powerNow = 1 - type2err;
end

sprintf('if you have %s subjects, you will have a power of %s',num2str(nSub),num2str(round(powerNow,2)))