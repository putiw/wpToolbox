function roimask = get_roi(sub,whichAtlas,whichRoi)

% Inputs:
%     sub:             Subject ID -e.g. 'sub-0201', or 'fsaverage'
%     whichAtlas:      ROI atlas -e.g. 'Glasser2016', 'Wang2015' 
%     whichRoi:        ROI labels -e.g. {'V1','V2','V3'}

% Outputs:
%     roimask:         ROI indices stored in 1 by #ROI cell matrix each
%     with the dimention  vertices (300k for example) by 1

if isempty(sub)
    sub = 'fsaverage';
end

if isempty(whichAtlas)
    whichAtlas = 'Glasser2016';
end

if isempty(whichRoi)
    whichRoi = 'V1';
end

roimask = cell(1,numel(whichRoi));

for iRoi = 1:numel(whichRoi)
    [tmpl, ~, ~] = cvnroimask(sub,'lh',whichAtlas,whichRoi{iRoi},[],[]);
    [tmpr,~,~] = cvnroimask(sub,'rh',whichAtlas,whichRoi{iRoi},[],[]);
    roimask{iRoi} = [tmpl{:};tmpr{:}];
end

end

 