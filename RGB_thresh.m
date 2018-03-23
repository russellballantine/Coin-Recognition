function [ threshold_RGB ] = RGB_thesh( image_RGB,perThresh_ )
%This function is to be used to trial and error the best colour threshold
%values for a given RGB image array. 

image_RGB = ImWithBackgroundOut;
redChannel = image_RGB(:, :, 1);
greenChannel = image_RGB(:, :, 2);
blueChannel = image_RGB(:, :, 3);
maxGrayLevel_Red = max(redChannel(:));
minGrayLevel_Red = min(redChannel(:));
maxGrayLevel_Green = max(greenChannel(:));
minGrayLevel_Green = min(greenChannel(:));
maxGrayLevel_Blue = max(blueChannel(:));
minGrayLevel_Blue = min(blueChannel(:));

% Convert percentage threshold into an actual number.

thresholdLevel = minGrayLevel_Red + perThresh*(maxGrayLevel_Red  - minGrayLevel_Red);
binaryImage_Red = redChannel  > thresholdLevel;

thresholdLevel = minGrayLevel_Green + perThresh*(maxGrayLevel_Green  - minGrayLevel_Green);
binaryImage_Green = greenChannel  > thresholdLevel;

thresholdLevel = minGrayLevel_Blue + perThresh*(maxGrayLevel_Blue  - minGrayLevel_Blue);
binaryImage_Blue = blueChannel  > thresholdLevel;

figure;
imagesc(binaryImage_Red);
figure;
imagesc(binaryImage_Green);
figure;
imagesc(binaryImage_Blue);



end

