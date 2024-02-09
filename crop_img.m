

imgDir = '/Users/pw1246/Desktop/figures/Localizers/screenshots/';
cropDir = '/Users/pw1246/Desktop/figures/Localizers/cropped_sc/';
%% 0037
imDir = dir(fullfile(imgDir, 'lh.0037*.png'));
topLeft = [318,740];
hw = [400,300];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end
imDir = dir(fullfile(imgDir, 'rh.0037*.png'));
topLeft = [306,272];
hw = [400,300];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end
%% 0248
imDir = dir(fullfile(imgDir, 'lh.0248*.png'));
topLeft = [228,665];
hw = [500,430];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end
imDir = dir(fullfile(imgDir, 'rh.*.png'));
topLeft = [239,210];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end
%% 0201
imDir = dir(fullfile(imgDir, 'lh.0201*.png'));
topLeft = [312,861];
hw = [400,300];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end
imDir = dir(fullfile(imgDir, 'rh.0201*.png'));
topLeft = [364,283];
hw = [400,300];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end
%% 0426
imDir = dir(fullfile(imgDir, 'lh.0426*.png'));
topLeft = [391,817];
hw = [400,300];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end
imDir = dir(fullfile(imgDir, 'rh.0426*.png'));
topLeft = [368,193];
hw = [400,300];
for ii = 1:numel(imDir)
    whichImage = imread(fullfile(imDir(ii).folder,imDir(ii).name));
    newImage = whichImage(topLeft(1):topLeft(1)+hw(1),topLeft(2):topLeft(2)+hw(2),:);
    newname = fullfile(cropDir,imDir(ii).name);
    imwrite(newImage,newname);
end