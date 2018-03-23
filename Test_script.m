eval(['load ',modelfilename,' maxclasses Means Invcors Aprioris']);
imagestem = input('Test image file stem(filestem)\n?','s');
Coins = input('How many coins do you want me to count (int)\n?');
run=1;
imagenum=0;
N=11;
Dim=3;
while ~(run == 0)
	imagenum = imagenum + 1;
	currentimagergb = imread([imagestem,int2str(imagenum),'.jpg'],'jpg');
	imagergb = double(currentimagergb);
	image_red = imagergb(:,:,1)./(imagergb(:,:,1) + imagergb(:,:,2) + imagergb(:,:,3));
	image_green = imagergb(:,:,2)./(imagergb(:,:,2) + imagergb(:,:,2) + imagergb(:,:,2));
	image_blue = imagergb(:,:,3)./(imagergb(:,:,3) + imagergb(:,:,3) + imagergb(:,:,3));
	imagergb_UD=flipud(imagergb);
	image_UD_red=imagergb_UD(:,:,1)./(imagergb_UD(:,:,1) + imagergb_UD(:,:,2) + imagergb_UD(:,:,3));
	image_UD_green=imagergb_UD(:,:,2)./(imagergb_UD(:,:,1) + imagergb_UD(:,:,2) + imagergb_UD(:,:,3));
	image_UD_blue=imagergb_UD(:,:,3)./(imagergb_UD(:,:,1) + imagergb_UD(:,:,2) + imagergb_UD(:,:,3));
	imagergb_LR=fliplr(imagergb);
	image_LR_red=imagergb_LR(:,:,1)./(imagergb_LR(:,:,1) + imagergb_LR(:,:,2) + imagergb_LR(:,:,3));
	image_LR_green=imagergb_LR(:,:,2)./(imagergb_LR(:,:,1) + imagergb_LR(:,:,2) + imagergb_LR(:,:,3));
	image_LR_blue=imagergb_LR(:,:,3)./(imagergb_LR(:,:,1) + imagergb_LR(:,:,2) + imagergb_LR(:,:,3));

	
	Big_Matrix_red=cat(3,cat(3,image_red,image_UD_red,image_LR_red));
	Big_Matrix_green = cat(3,cat(3,image_green,image_UD_green,image_LR_green));
	Big_Matrix_blue = cat(3,cat(3,image_blue,image_UD_blue,image_LR_blue));

	Median_red = median(Big_Matrix_red,3);
	Median_green = median(Big_Matrix_green,3);
	Median_blue = median(Big_Matrix_blue,3);

	Median_BackgroundRGB=cat(3,cat(3,Median_red,Median_green,Median_blue));

	%imagesc(Median_BackgroundRGB);

	%==============================================

	% Section 2 Performing background removal
	%
	%==============================================

	imagergb = imread([imagestem,int2str(imagenum),'.jpg'],'jpg');
	imagergb = double(imagergb);
	image_red = imagergb(:,:,1)./(imagergb(:,:,1) + imagergb(:,:,2) + imagergb(:,:,3));
	image_green = imagergb(:,:,2)./(imagergb(:,:,1) + imagergb(:,:,2) + imagergb(:,:,3));
	image_blue = imagergb(:,:,3)./(imagergb(:,:,1) + imagergb(:,:,2) + imagergb(:,:,3));

	%recreate a 3D image with the now normalised colour

	imagergb(:,:,1)=image_red;
	imagergb(:,:,2)=image_green;
	imagergb(:,:,3)=image_blue;

	imagergb =cat(3,imagergb(:,:,1),imagergb(:,:,2),imagergb(:,:,3));

	%imagesc(I_norm_primary);

	%perform background removal
	ImBackgroundOut_Red=abs(imagergb(:,:,1)-Median_BackgroundRGB(:,:,1));
	ImBackgroundOut_Green=abs(imagergb(:,:,2)-Median_BackgroundRGB(:,:,2));
	ImBackgroundOut_Blue=abs(imagergb(:,:,3)-Median_BackgroundRGB(:,:,3));

	%Concatenate image together

	ImWithBackgroundOut=cat(3,ImBackgroundOut_Red,ImBackgroundOut_Green,ImBackgroundOut_Blue);

	%imagesc(ImWithBackgroundOut);

	%====================================================================
	%Section 3: Perform thresholding in the colour domain
	%using an OR operation
	%====================================================================

	%function [threshold_RGB] = Perform_RGB_threshold(image_RGB, perThresh)

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

	thresholdLevel = minGrayLevel_Red + 0.07*(maxGrayLevel_Red  - minGrayLevel_Red);
	binaryImage_Red = redChannel  > thresholdLevel;

	thresholdLevel = minGrayLevel_Green + 0.025*(maxGrayLevel_Green  - minGrayLevel_Green);
	binaryImage_Green = greenChannel  > thresholdLevel;

	thresholdLevel = minGrayLevel_Blue + 0.07*(maxGrayLevel_Blue  - minGrayLevel_Blue);
	binaryImage_Blue = blueChannel  > thresholdLevel;

	%figure;
	%imagesc(binaryImage_Red);
	%figure;
	%imagesc(binaryImage_Green);
	%figure;
	%imagesc(binaryImage_Blue);

	%Clean up the thresholded images using bwmorph

	BW2 = bwmorph(binaryImage_Red,'clean',1);
	BW3 = bwmorph(binaryImage_Green,'clean',1);
	BW4 = bwmorph(binaryImage_Blue,'clean',1);

	%Use image dilation to enhance broken objects

	SE=ones(3,3);
	binaryImage_Red = myimdilate(BW2,SE);
	binaryImage_Green = myimdilate(BW3,SE);
	binaryImage_Blue = myimdilate(BW4,SE);

	%re-examine the images after treatment by bwmorph.m and myimdilate.m

	%figure;
	%imagesc(binaryImage_Red);
	%figure;
	%imagesc(binaryImage_Green);
	%figure;
	%imagesc(binaryImage_Blue);

	%-------------------------------
	% Use logical OR of all three RGB planes.
	%

	binary_image_thresh= binaryImage_Red + binaryImage_Green + binaryImage_Blue;

	[H,W]=size(binary_image_thresh)
	for r=1:H;
		for c=1:W;
			value=binary_image_thresh(r,c);
			if value > 0;
				binary_image_thresh(r,c) = 1;
			elseif value == 0;
			binary_image_thresh(r,c) = 0;
			end
		end
	end

	%imagesc(binary_image_thresh);

	for classnum=1:Coins
		shape=getlargest(binary_image_thresh,1);
		figure;
		imagesc(shape);
		v = getproperties(shape);
		class=classify(v,N,Means,Invcors,Dim,Aprioris)
		
		binary_image_thresh=binary_image_thresh-shape;
		%figure;
		%imagesc(shape); 
		classnum=classnum+1;
	end



run = input(['Want to process another image ',int2str(imagenum+1),' (0,1)\n?']);

end