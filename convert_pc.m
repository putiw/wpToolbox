function vals1 = convert_pc(vals0)

vals1 = zeros(size(vals0));

for ii = 1:size(vals0,2)

    tmp = sort(vals0(:,ii));
    [~, whichRank] = ismember(vals0(:,ii), tmp);
    vals1(:,ii) = whichRank / length(tmp) * 100;

end