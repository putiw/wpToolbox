subject = 'sub-0248';
bidsDir = '/Volumes/Vision/MRI/recon-bank';
[vertices, faces] = read_surf([bidsDir '/derivatives/freesurfer/' subject '/surf/lh.inflated']);

% Create a sparse adjacency matrix
n = size(vertices, 1); % Number of vertices
mySurf = sparse(n, n);
for i = 1:size(faces, 1)
    face = faces(i, :)+1;
    for j = 1:3
        for k = (j+1):3
            % Calculate Euclidean distance between vertices of each edge
            v1 = vertices(face(j), :);
            v2 = vertices(face(k), :);
            dist = sqrt(sum((v1 - v2).^2));
            
            % Update adjacency matrix
            mySurf(face(j), face(k)) = dist;
            mySurf(face(k), face(j)) = dist;
        end
    end
end
% Create graph from adjacency matrix
G = graph(mySurf);

% Indices of vertices of interest
vertex1_index = 7102; % replace with your first vertex index
vertex2_index = 2619; % replace with your second vertex index

% Calculate shortest path (geodesic distance)
[path, d] = shortestpath(G, vertex1_index, vertex2_index);

% d is the geodesic distance
disp(d);


%% load val
val = load_mgz(subject,bidsDir,'prfvista_mov/eccen');
val0 = max(min(val, 9), 0.3);
val0 = val0(1:size(vertices,1),:);
%%
% Convert distance to centimeters (if needed)
distance_cm = d / 10; % Assuming d is in millimeters

% Plot the mesh
figure(1);clf
% h = trimesh(faces+1, vertices(:, 1), vertices(:, 2), vertices(:, 3), ...
%     'EdgeColor', 'none','FaceColor', [0.5 0.5 0.5]); 
h = trisurf(faces+1, vertices(:, 1), vertices(:, 2), vertices(:, 3), val0, ...
    'EdgeColor', 'none'); 
axis equal;
view(3);
% Set fixed axis limits
xlim([min(vertices(:,1)) max(vertices(:,1))]);
ylim([min(vertices(:,2)) max(vertices(:,2))]);
zlim([min(vertices(:,3)) max(vertices(:,3))]);

% Flip the colormap
colormap(flipud(jet));
h.FaceAlpha = 0.8; % Adjust for desired transparency

% Improve lighting
camlight headlight;
lighting phong;
material dull;
hold on;

% Additional lighting from multiple angles
lightangle(45, 30);
lightangle(-45, -30);

% Extract coordinates of the geodesic path
pathVertices = vertices(path, :);

% Plot the line
plot3(pathVertices(:,1), pathVertices(:,2), pathVertices(:,3), ...
    'LineWidth', 5, 'Color', 'w');
plot3(pathVertices(:,1), pathVertices(:,2), pathVertices(:,3), ...
    'LineWidth', 4, 'Color', 'k');
% Add text for distance
midIndex = round(length(path) / 2);
midPoint = pathVertices(midIndex, :);
text(midPoint(1), midPoint(2), midPoint(3), ...
    [num2str(distance_cm, '%.2f'), ' cm'], ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', 'k');

hold off;
figure(2);plot(val0(path),'LineWidth', 2)