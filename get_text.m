% Path to the RTF file
filename = '/Volumes/Vision/MRI/recon-bank/derivatives/freesurfer/sub-0037/tmp/lh.camera.txt';

% Open the file
fid = fopen(filename, 'rt');
if fid == -1
    error('File cannot be opened');
end

% Read the contents
fileContents = fread(fid, '*char')';

% Close the file
fclose(fid);

% Process the contents to extract text (basic example)
% You might need a more complex function depending on RTF formatting
plainText = extractPlainTextFromRTF(fileContents);
