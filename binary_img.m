function binary_pic=binary_img(image_in,Threshold)
%Given an input image and a Threshold value, returns the original image 
% and a binary image (black and white) centered around the threshold value.

image_in=myjpgload(image_in,1);
[m,n]=size(image_in);

%Splits image pixels according to what side of threshold value.
for row=1 : m
    for col=1 : n
        if image_in(row,col) < Threshold
            binary_pic(row,col) = 0;
        else
            binary_pic(row,col) = 1;
        end
    end
end
%Display the binary figure in a new window
figure;
imshow(binary_pic);

