%%
voxelSize = 0.7; % 
bidsDir = '/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis';
subject = 'sub-001';
whichScan = 'Output_2D';
segDir = 'output_segmentation';

 
t21 = '/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis/sub-001/Output_2D/output_lesion_pipeline_20240219-130954/output_segmentation/tp001/mode02_bias_corrected.nii.gz';
t22 = '/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis/sub-001/Output_2D/output_lesion_pipeline_20240219-130954/output_segmentation/tp002/mode02_bias_corrected.nii.gz';
niiPath = '/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis/sub-001/Output_2D/output_lesion_pipeline_20240219-130954/dummy/T1w/T1w_acpc_brain_mask.nii.gz';
lesnii ='/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis/sub-001/Output_2D/output_lesion_pipeline_20240219-130954/output_segmentation/tp001/tp001_lesions.nii.gz';
les1 ='/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis/sub-001/Output_2D/output_lesion_pipeline_20240219-130954/output_segmentation/tp001/tp001_lesions_manual.nii.gz';
les2 = '/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis/sub-001/Output_2D/output_lesion_pipeline_20240219-130954/output_segmentation/tp002/tp002_lesions_manual.nii.gz';
les3 = '/Users/pw1246/Documents/MRI/osamaMS/ses-01/anat/ples_lpa_mrsub-001_ses-01_FLAIR_2D.nii';
t22 = niftiread(t22);
t22 = permute(t22, [2 3 1]);
t21 = niftiread(t21);
t21 = permute(t21, [2 3 1]);
% head(head<130) = 0;

vol1 = niftiread(niiPath);
vol = permute(vol1, [2 3 1]);
lesn = niftiread(lesnii);
lesn = permute(lesn, [2 3 1]);
les1 = niftiread(les1);
les1 = permute(les1, [2 3 1]);
les2 = niftiread(les2);
les2 = permute(les2, [2 3 1]);
les3 = niftiread(les3);
les3 = permute(les3, [2 3 1]);
%%
figure(1); clf; hold on;


[x, y, z] = meshgrid(1:size(vol,2), 1:size(vol,1), 1:size(vol,3));


[f, v] = isosurface(x, y, z, les3>0.9, 0.1,'FaceColor', 'blue');
p1 = patch('Faces', f, 'Vertices', v);
set(p1, 'FaceColor', [0 0 0.5], 'EdgeColor', 'none'); % Change lesion color here
material(p1, 'shiny'); % Make the lesion reflective


lighting phong;
light('Position', [1 1 0], 'Style', 'local'); % Position a light to emphasize the lesion

% % Keep the aspect ratio 1:1:1 and use grayscale colormap for context visualization
daspect([1 1 1]);
% colormap('gray');
%
[f, v] = isosurface(x, y, z, vol, 0.5);
p = patch('Faces', f, 'Vertices', v);
p.FaceColor = [1 1 1];
p.EdgeColor = 'none';
p.FaceAlpha = 0.08; % Transparent white matter surface
camlight;

xlabel('x');
ylabel('y');
zlabel('z');


axis equal;
%axis off;

view(-90, 90);
set(gcf, 'Color', 'white');
% for ii = [-40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40]
% view(0, ii);
% drawnow
% pause(0.02)
% end
% for ii =1:20
% rotate(p, [0 1 0], -10)
% rotate(p0, [0 1 0], -10)
% rotate(p1, [0 1 0], -10)
% 
% drawnow
% end
%%
% each distinct lesion gets a unique label
[L1, num1] = bwlabeln(les1 > 0.8);
[L2, num2] = bwlabeln(les2 > 0.8);

lesionVolumes1 = zeros(num1, 1);
lesionVolumes2 = zeros(num2, 1);

% Calculate volume for each lesion
for i = 1:num1
    lesionVolumes1(i) = nnz(L1 == i); % Number of voxels in the ith lesion
end
[~, whichLes] = sort(lesionVolumes1);
lessort1 = flip(whichLes);
for i = 1:num2
    lesionVolumes2(i) = nnz(L2 == i); % Number of voxels in the ith lesion
end
[~, whichLes] = sort(lesionVolumes2);
lessort2 = flip(whichLes);

% for ii = 1:3
% firstLesion = L2 == whichLes(ii); % Binary matrix for the first lesion
% isosurface(firstLesion, 0.5); % Adjust the second argument as needed for visualization
% drawnow
% end


% make a 3D mat for each lesion at each time point
lesionMat1 = cell(num1,1);
for whichLes = 1:num1
lesionMat1{whichLes,1} = L1 == lessort1(whichLes);
end
lesionMat2 = cell(num2,1);
for whichLes = 1:num2
lesionMat2{whichLes,1} = L2 == lessort2(whichLes);
end


%% which lesion in time 2 is new lesion
whichNew = zeros(num2,1); 

for whichLes2 = 1:num2
    % for every lesion at time point 2
    % look through if there's a match of time point 1

    isnew = zeros(num1,1);
    for whichles1 = 1:num1

        match = lesionMat2{whichLes2,1} & lesionMat1{whichles1,1};

        if sum(match(:)) > 0 % we have a match

        else
           isnew(whichles1) = 1; % no match
        end
            
    end

    if sum(isnew) == num1
        whichNew(whichLes2) = 1;
    end

end

%%
figure(1); clf; hold on;
[x, y, z] = meshgrid(1:size(vol,2), 1:size(vol,1), 1:size(vol,3));

plotLes = find(~whichNew);
for whichles = 1:numel(plotLes)   
    [f, v] = isosurface(x, y, z, lesionMat2{plotLes(whichles)});
    p0 = patch('Faces', f, 'Vertices', v);
    set(p0, 'FaceColor', [0 0 0], 'FaceAlpha',0.1,'EdgeColor', 'none');
    material(p0, 'shiny');
    drawnow
end

plotLes = find(whichNew);
for whichles = 1:numel(plotLes)   
    [f, v] = isosurface(x, y, z, lesionMat2{plotLes(whichles)});
    p0 = patch('Faces', f, 'Vertices', v);
    set(p0, 'FaceColor', 'red', 'EdgeColor', 'none'); 
   % material(p0, 'shiny');
    drawnow
end

%light('Position', [1 0 0], 'Style', 'infinite'); % Position a light to emphasize the lesion
[f, v] = isosurface(x, y, z, vol, 0.5);
p = patch('Faces', f, 'Vertices', v);
p.FaceColor = [1 1 1];
p.EdgeColor = 'none';
p.FaceAlpha = 0.05; % Transparent white matter surface
view(90, 0); 
camlight;
axis equal;
axis off;

set(gcf, 'Color', 'white');
%% which lesion in time 2 is new lesion plot in slice

figure(5);clf;hold on;
plotLes = find(whichNew);
for whichles = 1%:numel(plotLes)   
binaryMat = lesionMat2{plotLes(whichles)} > 0.99; % Example binary matrix

% Sum along each dimension
sumX = squeeze(sum(sum(binaryMat, 2), 3)); % Sum over Y and Z, resulting in a vector of sums for each X slice
sumY = squeeze(sum(sum(binaryMat, 1), 3)); % Sum over X and Z
sumZ = squeeze(sum(sum(binaryMat, 1), 2)); % Sum over X and Y

% Find the index of the maximum sum for each dimension
[~, largestX] = max(sumX);
[~, largestY] = max(sumY);
[~, largestZ] = max(sumZ);

imshow(reshape(t22(largestX,:,:),260,260),[0 300]);
hold on
imshow(reshape(binaryMat(largestX,:,:),260,260),[0 1]);

    %drawnow
end

%%
for ii = largestX
figure(5);clf;
yy = ii;
img0 = reshape(t22(yy,:,:),260,260);
wherelesion = reshape(binaryMat(yy,:,:),260,260);
wherelesion = double(wherelesion);
wherelesion(wherelesion==0) = nan;
img1 = wherelesion;
img0 = mat2gray(img0); % Normalize img0 to the range [0, 1]
img0 = [img0 img0];
img0 = repelem(img0,4,4);
imshow(img0);
hold on;
img1 = [nan(size(img1)) img1];
img1 = repelem(img1,4,4);

nanMask = ~isnan(img1);
img1(~nanMask) = min(img1(:)); % Replace NaN with min of img1 for colormap indexing
h = imshow(ind2rgb(im2uint8(mat2gray(img1)), hot));
set(h, 'AlphaData', nanMask);
text('Units', 'normalized', 'Position', [0.9, 0.1], 'String', num2str(yy), 'Color', 'white', 'FontSize', 25, 'FontWeight', 'bold', 'FontAngle', 'italic');
drawnow
pause(0.1)

end
for ii = largestY
figure(6);clf;
yy = ii;
img0 = reshape(t22(:,yy,:),311,260);
wherelesion = reshape(binaryMat(:,yy,:),311,260);
wherelesion = double(wherelesion);
wherelesion(wherelesion==0) = nan;
img1 = wherelesion;
img0 = mat2gray(img0); % Normalize img0 to the range [0, 1]
img0 = [img0 img0];
img0 = repelem(img0,4,4);
imshow(img0);
hold on;
img1 = [nan(size(img1)) img1];
img1 = repelem(img1,4,4);

nanMask = ~isnan(img1);
img1(~nanMask) = min(img1(:)); % Replace NaN with min of img1 for colormap indexing
h = imshow(ind2rgb(im2uint8(mat2gray(img1)), hot));
set(h, 'AlphaData', nanMask);
text('Units', 'normalized', 'Position', [0.9, 0.1], 'String', num2str(yy), 'Color', 'white', 'FontSize', 25, 'FontWeight', 'bold', 'FontAngle', 'italic');
drawnow
pause(0.1)

end
%%
%% which lesion in time 1 went away

whichGone = zeros(num1,1); % which lesion in time 1 is no longer there
isMatch = zeros(num1,2);
for whichles1 = 1:num1
    % for every lesion at time point 1
    % look through if there's a match of time point 2
    isMatch(whichles1,1) = whichles1;

    isnew = zeros(num2,1);
    for whichles2 = 1:num2

        match = lesionMat1{whichles1,1} & lesionMat2{whichles2,1};

        if sum(match(:)) > 0 % we have a match
            isMatch(whichles1,2) = whichles2; % in time two this is the index

        else
           isnew(whichles2) = 1; % no match
        end
            
    end

    if sum(isnew) == num2
        whichGone(whichles1) = 1;
    end

end

isMatch(size(isMatch,1)+1:size(isMatch,1)+numel(find(whichNew)),:) = [(size(isMatch,1)+1:size(isMatch,1)+numel(find(whichNew)))' find(whichNew)];
%%
figure(2); clf; hold on;
[x, y, z] = meshgrid(1:size(vol,2), 1:size(vol,1), 1:size(vol,3));

plotLes = find(~whichGone);
for whichles = 1:numel(plotLes)   
[f, v] = isosurface(x, y, z, lesionMat1{plotLes(whichles)});
p0 = patch('Faces', f, 'Vertices', v);
set(p0, 'FaceColor', [0 0 0], 'FaceAlpha',0.1,'EdgeColor', 'none');
material(p0, 'shiny');
end

plotLes = find(whichGone);
for whichles = 1:numel(plotLes)   
    [f, v] = isosurface(x, y, z, lesionMat1{plotLes(whichles)});
    p0 = patch('Faces', f, 'Vertices', v);
    set(p0, 'FaceColor', 'green', 'EdgeColor', 'none'); 
    material(p0, 'shiny');   
end

lighting phong;
light('Position', [1 0 0], 'Style', 'local'); % Position a light to emphasize the lesion
[f, v] = isosurface(x, y, z, vol, 0.5);
p = patch('Faces', f, 'Vertices', v);
p.FaceColor = [1 1 1];
p.EdgeColor = 'none';
p.FaceAlpha = 0.05; % Transparent white matter surface
camlight;
axis equal;
axis off;

set(gcf, 'Color', 'white');
 view(90, 0); %top left is back right

%% how much size change there is

sizeChange = zeros(size(isMatch,1),3);
for whichles = 1:size(isMatch,1)

    if whichles > numel(lesionMat1)
        l1 = 0;
    else
        l1 = lesionMat1{isMatch(whichles,1)};
    end
    if isMatch(whichles,2) == 0
        l2 = 0;
    else
    l2 = lesionMat2{isMatch(whichles,2)};
    end
    sizeChange(whichles,:) = [sum(l1(:)) sum(l2(:)) sum(l2(:))-sum(l1(:))].*voxelSize;
end
%%
figure(3);clf;hold on;
x1 = 1:size(sizeChange,1);
x2 = x1(sizeChange(:,3)>0) + 0.4;
x3 = x1(sizeChange(:,3)<0) + 0.4;

bar(x1,sizeChange(:,1),0.4,'k','FaceAlpha',0.5,'EdgeColor','none');
bar(x2,sizeChange(sizeChange(:,3)>0,2),0.4,'FaceColor',[237 106 94]./255,'EdgeColor','none');
bar(x3,sizeChange(sizeChange(:,3)<0,2),0.4,'FaceColor',[83 131 236]./255,'EdgeColor','none');
set(gca,'LineWidth',2)


set(gca,'FontSize',15,'FontWeight','bold','FontAngle', 'italic','TickDir', 'out','LineWidth',2,'XTick', [], 'XTickLabel', []);


%% plot the lesions in time 2 by size change

figure(4); clf; hold on;
[x, y, z] = meshgrid(1:size(vol,2), 1:size(vol,1), 1:size(vol,3));

plotLes = isMatch(sizeChange(:,3)>0,2);
for whichles = 1:numel(plotLes)   
[f, v] = isosurface(x, y, z, lesionMat2{plotLes(whichles)});
p0 = patch('Faces', f, 'Vertices', v);
set(p0, 'FaceColor', [1 0 0], 'FaceAlpha',0.4,'EdgeColor', 'none');
material(p0, 'shiny');
end

plotLes = nonzeros(isMatch(sizeChange(:,3)<0,2));
for whichles = 1:numel(plotLes)   
    [f, v] = isosurface(x, y, z, lesionMat2{plotLes(whichles)});
    p0 = patch('Faces', f, 'Vertices', v);
    set(p0, 'FaceColor', 'blue', 'FaceAlpha',0.4, 'EdgeColor', 'none'); 
    material(p0, 'shiny');   
end

lighting phong;
light('Position', [1 0 0], 'Style', 'local'); % Position a light to emphasize the lesion
[f, v] = isosurface(x, y, z, vol, 0.5);
p = patch('Faces', f, 'Vertices', v);
p.FaceColor = [1 1 1];
p.EdgeColor = 'none';
p.FaceAlpha = 0.05; % Transparent white matter surface
camlight;
axis equal;
axis off;

set(gcf, 'Color', 'white');
 view(90, 0); %top left is back right


%% plot 1 lesion
l1flip = flip(L1,1);
mat1 = find(lessort1==L1(102,109,168));
mat1 = 1;
mat2 = isMatch(isMatch(:,1)==mat1,2);
figure(7); clf; hold on;
[x, y, z] = meshgrid(1:size(vol,2), 1:size(vol,1), 1:size(vol,3));
  
drawMat = lesionMat1{mat1};

[f, v] = isosurface(x, y, z, drawMat);
p0 = patch('Faces', f, 'Vertices', v);
set(p0, 'FaceColor', [1 0 0], 'FaceAlpha',0.6,'EdgeColor', 'none');
material(p0, 'shiny');

% [f, v] = isosurface(x, y, z, lesionMat2{plotLes(whichles)});
% p0 = patch('Faces', f, 'Vertices', v);
% set(p0, 'FaceColor', 'blue', 'FaceAlpha',0.4, 'EdgeColor', 'none');
% material(p0, 'shiny');


lighting phong;
light('Position', [1 0 0], 'Style', 'local'); % Position a light to emphasize the lesion
[f, v] = isosurface(x, y, z, vol, 0.5);
p = patch('Faces', f, 'Vertices', v);
p.FaceColor = [1 1 1];
p.EdgeColor = 'none';
p.FaceAlpha = 0.05; % Transparent white matter surface
camlight;
axis equal;
axis off;

set(gcf, 'Color', 'white');
 view(90, 0); %top left is back right

%%

%% look at lesion with largest change in size
[~,whichLarge] = sort(sizeChange(:,3));
whichLarge = flip(whichLarge);

%binaryMat = lesionMat2{isMatch(whichLarge(2),2)} > 0.99; % Example binary matrix
binaryMat = lesionMat2{19} > 0.99; % Example binary matrix

binaryMat = flip(binaryMat,1);
sumX = squeeze(sum(sum(binaryMat, 2), 3)); % Sum over Y and Z, resulting in a vector of sums for each X slice
sumY = squeeze(sum(sum(binaryMat, 1), 3)); % Sum over X and Z
sumZ = squeeze(sum(sum(binaryMat, 1), 2)); % Sum over X and Y

% Find the index of the maximum sum for each dimension
[~, largestX] = max(sumX);
[~, largestY] = max(sumY);
[~, largestZ] = max(sumZ);


binaryMat = binaryMat./2;
for ii = largestY
figure(7);clf;
yy = ii;
img0 = reshape(t21(:,yy,:),311,260);
wherelesion = reshape(binaryMat(:,yy,:),311,260);
wherelesion = double(wherelesion);
wherelesion(wherelesion==0) = nan;
img1 = wherelesion;
img0 = mat2gray(img0); % Normalize img0 to the range [0, 1]
img0 = [img0 img0];
img0 = repelem(img0,4,4);
imshow(img0);
hold on;
img1 = [nan(size(img1)) img1];
img1 = repelem(img1,4,4);

nanMask = ~isnan(img1);
img1(~nanMask) = min(img1(:)); % Replace NaN with min of img1 for colormap indexing
h = imshow(ind2rgb(im2uint8(mat2gray(img1)), hot(256)));
%h = imshow(mat2gray(img1));

set(h, 'AlphaData', nanMask);
text('Units', 'normalized', 'Position', [0.9, 0.1], 'String', num2str(yy), 'Color', 'white', 'FontSize', 25, 'FontWeight', 'bold', 'FontAngle', 'italic');
drawnow
pause(0.1)

end


%%
% for ii = [-40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40 -40:-1:-90 -90:1:-40]
% view(0, ii);
% drawnow
% pause(0.02)
% end

for i = whichLes(1)
    [x, y, z] = ind2sub(size(L), find(L == i)); % Find the indices of the i-th lesion
    
    % Calculate bounding box dimensions
    minX = min(x); maxX = max(x);
    minY = min(y); maxY = max(y);
    minZ = min(z); maxZ = max(z);
    
    % Determine the lengths of the bounding box sides
    lengthX = maxX - minX;
    lengthY = maxY - minY;
    lengthZ = maxZ - minZ;
    
    % Approximate diameter is the largest dimension of the bounding box
    approxDiameter = max([lengthX, lengthY, lengthZ]);

    fprintf('Lesion %d approximate diameter: %d units\n', i, approxDiameter);
end
