%%
bidsDir = '/Volumes/Vision/UsersShare/Amna/Multiple_Sclerosis';
subject = 'sub-001';
whichScan = 'Output_2D';
segDir = 'output_segmentation';
timepoint1 = 'tp001';
timepoint2 = 'tp002';
%vol = permute(vol1, [2 3 1]);
t2tp1 = dir(sprintf('%s/%s/%s/*/%s/%s/mode02_bias_corrected.nii.gz',bidsDir,subject,whichScan,segDir,timepoint1));
t2tp1 = niftiread(fullfile(t2tp1.folder,t2tp1.name));
t2tp2 = dir(sprintf('%s/%s/%s/*/%s/%s/mode02_bias_corrected.nii.gz',bidsDir,subject,whichScan,segDir,timepoint2));
t2tp2 = niftiread(fullfile(t2tp2.folder,t2tp2.name));

t2tp2 = flip(t2tp2,2);t2tp2 = flip(t2tp2,3);
brainMask = dir(sprintf('%s/%s/%s/*/%s/T1w/T1w_acpc_brain_mask.nii.gz',bidsDir,subject,whichScan,'dummy'));
brainMask = niftiread(fullfile(brainMask.folder,brainMask.name));
les1 = dir(sprintf('%s/%s/%s/*/%s/%s/%s_lesions_manual.nii.gz',bidsDir,subject,whichScan,segDir,timepoint1,timepoint1));
app.Lesion1 = niftiread(fullfile(les1.folder,les1.name));
app.Les1Img = flip(app.Lesion1,2);app.Les1Img = flip(app.Les1Img,3);

les2 = dir(sprintf('%s/%s/%s/*/%s/%s/%s_lesions_manual.nii.gz',bidsDir,subject,whichScan,segDir,timepoint2,timepoint2));
app.Lesion2 = niftiread(fullfile(les2.folder,les2.name));
app.Les2Img = flip(app.Lesion2,2);app.Les2Img = flip(app.Les2Img,3);

%% debugging for new lesion index
% Label and calculate lesion volumes
[app.L1, ~] = bwlabeln(app.Lesion1 > 0.8,26);
[app.L2, ~] = bwlabeln(app.Lesion2 > 0.8,26);

lesion1index = nonzeros(unique(app.L1));
lesion2index = nonzeros(unique(app.L2));
lesion1indexNew = zeros(size(lesion1index));
lesion2indexNew = zeros(size(lesion2index));

disp(['Matching lesions across two time points ...'])

for i1 = 1:numel(lesion1index)
    disp([num2str(round(i1/numel(lesion1index)*100)) ' % done ...'])
    for i2 = 1:numel(lesion2index)
        match =  (app.L1==i1) & (app.L2==i2);
        if sum(match(:))>0
            if lesion2indexNew(i2) == 0 % if empty then sign new index
                lesion2indexNew(i2) = i1;
            else % if not empty it means more than one lesions in time1 has merged into same lesion in time 2
                % we set the lesion in time 1 same index with the other
                % lesion in time 1 that were merged
                lesion1indexNew(i1) = lesion2indexNew(i2);
            end
        end
    end
end

disp('Sorting lesions by size ...')

lesion1indexNew(lesion1indexNew==0) = lesion1index(lesion1indexNew==0);
lesion2indexNew(lesion2indexNew==0) = max(lesion1index)+1:max(lesion1index)+sum(lesion2indexNew==0);


[~, loc] = ismember(app.L1, lesion1index);
loc(loc > 0) = lesion1indexNew(loc(loc > 0));
app.L1(loc > 0) = loc(loc > 0);
[~, loc] = ismember(app.L2, lesion2index);
loc(loc > 0) = lesion2indexNew(loc(loc > 0));
app.L2(loc > 0) = loc(loc > 0);


newlist = unique([lesion1indexNew; lesion2indexNew]);
lesionVol = zeros(nnz(newlist), 1);
for ii = 1:nnz(newlist)
    lesionVol(ii) = max([nnz(app.L1 == ii) nnz(app.L2 == ii)]); % Number of voxels in the ith lesion
end

[~,newlistOrder] = sort(lesionVol,'descend');

[~, loc] = ismember(app.L1, newlistOrder);
loc(loc > 0) = newlist(loc(loc > 0));
app.L1(loc > 0) = loc(loc > 0);

[~, loc] = ismember(app.L2, newlistOrder);
loc(loc > 0) = newlist(loc(loc > 0));
app.L2(loc > 0) = loc(loc > 0);

% remove any lesion size less than xxx
app.L1(ismember(app.L1, find(sort(lesionVol,'descend')<1))) = 0;
app.L2(ismember(app.L2, find(sort(lesionVol,'descend')<1))) = 0;

disp('Calculating lesion centers ...')

app.lesionIndex = nonzeros(unique([app.L1; app.L2]));
app.lesionCenter = zeros(numel(app.lesionIndex),3);

% orientation in imshow and patch are not the same
tmpL1 = flip(app.L1,2);
tmpL1 = flip(tmpL1,3);
tmpL2 = flip(app.L2,2);
tmpL2 = flip(tmpL2,3);

for ii = 1:numel(app.lesionIndex)
    binaryMat = tmpL1 == app.lesionIndex(ii); % Example binary matrix
    if sum(binaryMat(:)) < 1
        binaryMat = tmpL2 == app.lesionIndex(ii);
    end
    % Find the index of the maximum sum for each dimension
    [~, app.lesionCenter(app.lesionIndex(ii),1)] = max(squeeze(sum(sum(binaryMat, 2), 3)));
    [~, app.lesionCenter(app.lesionIndex(ii),2)] = max(squeeze(sum(sum(binaryMat, 1), 3)));
    [~, app.lesionCenter(app.lesionIndex(ii),3)] = max(squeeze(sum(sum(binaryMat, 1), 2)));
end

%% check which lesion is new

lesionList2 = unique(app.L2);
app.newLesionIndex = lesionList2(~ismember(unique(app.L2),unique(app.L1))); 


%% one image

x0 = 167;
y0 = 311-103;
z0 = 151;

sizeZoom = 26;
img21 =  mat2gray(squeeze(t2tp2(x0,:,:)))';
img22 =  mat2gray(squeeze(t2tp2(:,y0,:)))';
img23 =  mat2gray(squeeze(t2tp2(:,:,z0)));
botrow = [img21 img22 img23];

padding = (size(botrow,2)-size(botrow,1)*3)/2;
img11 = imresize(img21(z0 - sizeZoom:z0 + sizeZoom, y0 - sizeZoom:y0 + sizeZoom), [size(botrow,1) size(botrow,1)]);
img12 = imresize(img22(z0 - sizeZoom:z0 + sizeZoom, x0 - sizeZoom:x0 + sizeZoom), [size(botrow,1) size(botrow,1)]);
img13 = imresize(img23(x0 - sizeZoom:x0 + sizeZoom, y0 - sizeZoom:y0 + sizeZoom), [size(botrow,1) size(botrow,1)]);
toprow = [zeros(size(botrow,1),padding-20) img11 zeros(size(botrow,1),20) img12 zeros(size(botrow,1),20) img13 zeros(size(botrow,1),padding-20)];
img = [toprow;botrow];
imshow(img);hold on;

les21 = mat2gray(squeeze(app.whichLes(x0,:,:)))';
les22 = mat2gray(squeeze(app.whichLes(:,y0,:)))';
les23 = mat2gray(squeeze(app.whichLes(:,:,z0)));
botles = [les21 les22 les23];

les11 = imresize(les21(z0 - sizeZoom:z0 + sizeZoom, y0 - sizeZoom:y0 + sizeZoom), [size(botrow,1) size(botrow,1)]);
les12 = imresize(les22(z0 - sizeZoom:z0 + sizeZoom, x0 - sizeZoom:x0 + sizeZoom), [size(botrow,1) size(botrow,1)]);
les13 = imresize(les23(x0 - sizeZoom:x0 + sizeZoom, y0 - sizeZoom:y0 + sizeZoom), [size(botrow,1) size(botrow,1)]);
toples = [zeros(size(botrow,1),padding-20) les11 zeros(size(botrow,1),20) les12 zeros(size(botrow,1),20) les13 zeros(size(botrow,1),padding-20)];
img1 = [toples;botles];

nanMask = img1~=0;
h = imshow(ind2rgb(im2uint8(mat2gray(img1)), hot));
set(h, 'AlphaData', nanMask);


%%
voxelSize = 0.7; %

figure(1); clf; hold on;

[x, y, z] = meshgrid(1:size(brainMask,2), 1:size(brainMask,1), 1:size(brainMask,3));


[f, v] = isosurface(x, y, z, les1>0.9, 0.1,'FaceColor', 'blue');
p1 = patch('Faces', f, 'Vertices', v);
set(p1, 'FaceColor', [0 0 0.5], 'EdgeColor', 'none'); % Change lesion color here
material(p1, 'shiny'); % Make the lesion reflective


lighting phong;
light('Position', [1 1 0], 'Style', 'local'); % Position a light to emphasize the lesion

% % Keep the aspect ratio 1:1:1 and use grayscale colormap for context visualization
daspect([1 1 1]);
% colormap('gray');
%
[f, v] = isosurface(x, y, z, brainMask, 0.5);
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

b1 = bar(x1,sizeChange(:,1),0.4,'k','FaceAlpha',0.5,'EdgeColor','none');
b2 = bar(x2,sizeChange(sizeChange(:,3)>0,2),0.4,'FaceColor',[237 106 94]./255,'EdgeColor','none');
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
