clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '~/Desktop/MRI/FSTloc';
serverDir = '/Volumes/Vision/MRI/recon-bank';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,serverDir,githubDir,fsDir);

subject = 'sub-0395';


func2DLabelLeft = read_ROIlabel(fullfile(serverDir, 'derivatives/freesurfer', subject, 'label/0localizer/lh.func2D.label'));
fstLabelLeft = read_ROIlabel(fullfile(serverDir, 'derivatives/freesurfer', subject, 'label/0localizer/lh.FST.label'));
% Add paths for right hemisphere ROIs if applicable
func2DLabelRight = read_ROIlabel(fullfile(serverDir, 'derivatives/freesurfer', subject, 'label/0localizer/rh.func2D.label'));
fstLabelRight = read_ROIlabel(fullfile(serverDir, 'derivatives/freesurfer', subject, 'label/0localizer/rh.FST.label'));

lcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'lh.curv'));
rcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'rh.curv'));
curv = [lcurv;rcurv];

%%

whichPlot = 'angle';
R2min = 0;

switch whichPlot

    case 'eccen'

        vals = load_mgz(subject,serverDir,'prfvista_mov/eccen');

        values = [0.23778274930271276, 3.2, 6.2, 9.2, 12.2];
        colors = [255, 0, 0;    % Red
            255, 255, 0;  %
            0, 255, 0;    %
            0, 255, 255;  %
            0, 0, 255]./255;   %

    case 'angle'

        vals = load_mgz(subject,serverDir,'prfvista_mov/angle_adj');
        values = [0 60 120 180];
        colors = [0, 255, 255;    % Red
            0, 129, 0;  %
            255, 255, 0;    %
            122, 8, 10]./255;

    case 'sigma'

        vals = load_mgz(subject,serverDir,'prfvista_mov/sigma');

        values = [0.23778274930271276, 3.2, 6.2, 9.2, 12.2];
        colors = [255, 0, 0;    % Red
            255, 255, 0;  %
            0, 255, 0;    %
            0, 255, 255;  %
            0, 0, 255]./255;   %

end

linearVals = linspace(min(values), max(values), 256);
tmpColorMap = zeros(256, 3);
for i = 1:3
    tmpColorMap(:, i) = interp1(values, colors(:, i), linearVals, 'linear');
end
tmpColorMap(isnan(tmpColorMap)) = 0;

R2 = load_mgz(subject,serverDir,'prfvista_mov/vexpl'); %'transparent/oppo3'

%view(90, 0); % Sets the view towards the negative Y-axis
%view(30, -30); % Sets the view towards the negative Y-axis

figure(2); clf; hold on
hemi = 1;
if hemi == 1
    roi2d = func2DLabelLeft;
    fst = fstLabelLeft;
    tmpSurf = ['/Volumes/Vision/MRI/recon-bank/derivatives/freesurfer/' subject '/surf/lh.inflated'];
    myval = vals(1:numel(lcurv),1);
    R2 = R2(1:numel(lcurv),1);
    view(-90, 0);

    surfacebase = ([lcurv lcurv lcurv]-min(lcurv))./(max(lcurv)-min(lcurv));
    surfacebase = zeros(size(lcurv,1),3);
    surfacebase(lcurv>0,:) = 0.2; % sulci
    surfacebase(lcurv<=0,:) = 0.5;

else
    % Assign right hemisphere ROIs
    roi2d = func2DLabelRight;
    fst = fstLabelRight;
    tmpSurf = ['/Volumes/Vision/MRI/recon-bank/derivatives/freesurfer/' subject '/surf/rh.inflated'];
    myval = vals(numel(lcurv)+1:end,1);
    view(90, 0);
    R2 =  R2(numel(lcurv)+1:end,1);
    surfacebase = ([rcurv rcurv rcurv]-min(rcurv))./(max(rcurv)-min(rcurv));
    surfacebase = zeros(size(rcurv,1),3);
    surfacebase(rcurv>0,:) = 0.2; % sulci
    surfacebase(rcurv<=0,:) = 0.5;

end
[vertex_coords, faces] = read_surf(tmpSurf);
faces = faces+1;

% Filter faces to include only those where all vertices are in the ROI
face2d = all(ismember(faces, roi2d), 2);
facefst = all(ismember(faces, fst), 2);



color2d = zeros(size(rcurv,1),3);
color2d(roi2d(rcurv(roi2d)<0),3) = 1;
color2d(roi2d(rcurv(roi2d)>=0),3) = 0.5;

colorfst = zeros(size(rcurv,1),3);
colorfst(fst(rcurv(fst)<0),1) = 1;
colorfst(fst(rcurv(fst)>=0),1) = 0.6;


% use val for color
colorfst = zeros(size(rcurv,1),1);
colorfst(fst) = myval(fst);
color2d = zeros(size(rcurv,1),1);
color2d(roi2d) = myval(roi2d);
mycolor = myval;


% %Number of vertices
% nVertices = max(faces(:));
% % Edges: each row represents an edge between two vertices
% edges = [faces(:, [1, 2]); faces(:, [2, 3]); faces(:, [3, 1])];
% % Ensure edges are in a consistent order (smaller index first)
% edges = sort(edges, 2);
% % Remove duplicate edges
% edges = unique(edges, 'rows');
% % Create the sparse adjacency matrix
% A = sparse(edges(:, 1), edges(:, 2), 1, nVertices, nVertices);
% A = A + A.';
% D = diag(sum(A, 2)); % Degree matrix
% L = D - A; % Unnormalized graph Laplacian
% alpha = 1; % Smoothing factor; adjust as necessary for your data
% I = speye(size(A)); % Identity matrix
% smoothedVals = (I + alpha * L) \ myval; % Solve for smoothed values
% mycolor = smoothedVals;

p0 = patch('Vertices', vertex_coords, 'Faces', faces,'FaceVertexCData',surfacebase, ...
    'EdgeColor', 'none','FaceColor','flat');
plotSurf = patch('Vertices', vertex_coords, 'Faces', faces,'FaceVertexCData',mycolor, ...
    'EdgeColor', 'none','FaceColor','flat');

colormap(tmpColorMap);

alphamask = zeros(size(mycolor));

switch whichPlot

    case 'eccen'

        alphamask = (mycolor>0.23)&(R2>R2min);
        clim([0.23 12.2]);

    case 'angle'

        alphamask = (mycolor>=0.1)&(R2>R2min);
        clim([0 180]);

    case 'sigma'
        alphamask = R2>R2min;
        
        clim([0.2 8]);

    otherwise
        alphamask = ones(size(mycolor));

end

set(plotSurf, 'FaceVertexAlphaData', double(alphamask), 'FaceAlpha', 'interp', 'AlphaDataMapping', 'none');


% patch2d = patch('Vertices', vertex_coords, 'Faces', faces(face2d, :),'FaceVertexCData',color2d, ...
%     'FaceColor','flat', 'EdgeColor', 'none');
% patch2d.CDataMapping = 'scaled';
% % patch2d.FaceAlpha = 0;
%
% patchfst = patch('Vertices', vertex_coords, 'Faces', faces(facefst, :),'FaceVertexCData',colorfst, ...
%     'FaceColor','flat', 'EdgeColor', 'none');
% patchfst.CDataMapping = 'scaled';
%
% patchfst.FaceAlpha = 0;
% %patchfst.FaceColor = [1 1 1]*0.5;


daspect([1 1 1]);


roi_faces = faces(face2d, :);
% Calculate edges and their occurrences across faces
edges = [roi_faces(:,[1,2]); roi_faces(:,[2,3]); roi_faces(:,[3,1])]; % Create edges
edges = sort(edges, 2); % Sort each row to ensure consistent ordering
[edge_unique, ~, ic] = unique(edges, 'rows'); % Find unique edges and indices
edge_counts = accumarray(ic, 1); % Count occurrences of each edge
boundary_edges = edge_unique(edge_counts == 1, :); % Keep only boundary edges

% Initialize variables for plotting
smooth_boundary = boundary_edges(1,:); % Start with the first boundary edge
remaining_edges = boundary_edges(2:end,:); % Remaining edges to be processed

% Loop until no remaining edges or unable to find a connected edge
while ~isempty(remaining_edges)
    last_vertex = smooth_boundary(end, end); % Last vertex of the current smooth boundary
    % Find the next edge that is connected to the last vertex
    found = false;
    for i = 1:size(remaining_edges, 1)
        if any(remaining_edges(i,:) == last_vertex)
            % If found, append this edge to the smooth boundary, ensuring continuity
            if remaining_edges(i, 1) == last_vertex
                smooth_boundary = [smooth_boundary, remaining_edges(i, 2)];
            else
                smooth_boundary = [smooth_boundary, remaining_edges(i, 1)];
            end
            % Remove the found edge from remaining_edges
            remaining_edges(i,:) = [];
            found = true;
            break; % Exit the loop after finding a connected edge
        end
    end
    % If no connected edge is found, break the loop to prevent infinite loop
    if ~found
        break;
    end
end

% Plot the smooth boundary
plot3(vertex_coords(smooth_boundary,1), ...
    vertex_coords(smooth_boundary,2), ...
    vertex_coords(smooth_boundary,3), 'b-', 'LineWidth', 1);

roi_faces = faces(facefst, :);
% Calculate edges and their occurrences across faces
edges = [roi_faces(:,[1,2]); roi_faces(:,[2,3]); roi_faces(:,[3,1])]; % Create edges
edges = sort(edges, 2); % Sort each row to ensure consistent ordering
[edge_unique, ~, ic] = unique(edges, 'rows'); % Find unique edges and indices
edge_counts = accumarray(ic, 1); % Count occurrences of each edge
boundary_edges = edge_unique(edge_counts == 1, :); % Keep only boundary edges
% Initialize variables for plotting
smooth_boundary = boundary_edges(1,:); % Start with the first boundary edge
remaining_edges = boundary_edges(2:end,:); % Remaining edges to be processed

% Loop until no remaining edges or unable to find a connected edge
while ~isempty(remaining_edges)
    last_vertex = smooth_boundary(end, end); % Last vertex of the current smooth boundary
    % Find the next edge that is connected to the last vertex
    found = false;
    for i = 1:size(remaining_edges, 1)
        if any(remaining_edges(i,:) == last_vertex)
            % If found, append this edge to the smooth boundary, ensuring continuity
            if remaining_edges(i, 1) == last_vertex
                smooth_boundary = [smooth_boundary, remaining_edges(i, 2)];
            else
                smooth_boundary = [smooth_boundary, remaining_edges(i, 1)];
            end
            % Remove the found edge from remaining_edges
            remaining_edges(i,:) = [];
            found = true;
            break; % Exit the loop after finding a connected edge
        end
    end
    % If no connected edge is found, break the loop to prevent infinite loop
    if ~found
        break;
    end
end

plot3(vertex_coords(smooth_boundary,1), ...
    vertex_coords(smooth_boundary,2), ...
    vertex_coords(smooth_boundary,3), 'w-', 'LineWidth', 1);

hold off;



camlight headlight; % Adds a light in front of the camera
hlight = camlight('headlight');
hlight.Color = [1 1 1]* 0.5;%camlight right; % Adds another light to the left
material dull; %
lighting gouraud; % Smooth and nice lighting effects

axis vis3d;
axis off
set(gcf,'Position', [100, 100, 640*2, 480*2]); % Adjust position and size as needed

%
% %
% ylim([-90 -30])
% zlim([-20 55])
% %xlim([-70 -20])
% xlim([20 70])

%plotSurf.FaceAlpha = 0;
%
% %% holes no curv
% plotSurf = patch('Vertices', vertex_coords, 'Faces', faces(all(ismember(faces, setdiff(1:size(vertex_coords, 1), [roi2d;fst])), 2), :), ...
%     'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none');