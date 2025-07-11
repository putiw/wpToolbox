niftiPath = '/Volumes/MS_osama/MS100/MsBIDS/derivatives/TractoFlow/ses-01/sub-SP003/Eddy_Topup/sub-SP003__dwi_corrected.nii.gz';

info = niftiinfo(niftiPath);
vol  = niftiread(info);
if numel(size(vol)) == 4
    vol = vol(:,:,:,1);
end
slice120 = vol(:,:,167);

figure;
imshow(slice120, [], 'InitialMagnification', 'fit');
colormap gray;
axis off;