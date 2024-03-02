% Specify paths
whichVid = 'CCW';
inputPath = ['/Users/pw1246/RVL Dropbox/Puti Wen/pw1246/share/forJan/Loc4Jan/stimulus movie/'  whichVid '.mov'];
outputPath = ['~/Desktop/'  whichVid '_cropped.mp4']; % Using .mp4 for broader compatibility

% Create a VideoReader to get properties of the input video
videoFile = VideoReader(inputPath);

% Prepare the output file with explicit format specification
outputFile = VideoWriter(outputPath, 'MPEG-4'); % Specifying MPEG-4 format for output
outputFile.FrameRate = videoFile.FrameRate;

% Open the output video file for writing
open(outputFile);

% Determine square dimensions based on the max height (to maintain aspect ratio)
maxDimension = videoFile.Height; % Assuming height is the limiting dimension for square cropping
cropWidth = maxDimension;
cropHeight = maxDimension;

% Calculate the starting point for cropping to center the crop area horizontally
startX = max(0, round((videoFile.Width - cropWidth) / 2));
startY = 0; % Assuming the desire is to use the full height

while hasFrame(videoFile)
    frame = readFrame(videoFile);
    
    % Crop the frame to a square, centered
    croppedFrame = imcrop(frame, [startX, startY, cropWidth-1, cropHeight-1]);
    
    % Write the cropped frame to the new video file
    writeVideo(outputFile, croppedFrame);
end

% Close the output video file
close(outputFile);

% Confirmation
disp('Cropping and saving completed.');
