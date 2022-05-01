%% Colour Threshold Function Test
% Created by: Eoghan Mckay
% Date created: 10/03/2022
% To test functions created with Color Thresholding App on
% multiple images at a time.

% Tidy up for test
clc, clear all, close all

% Add path to image folder
images = dir('C:\Users\emcka\MATLAB Drive\Image processing\Show images\bottlecap\*.jpg');
% Count number of images in the folder
nfiles = length(images);
% Specify size and shape of filtering element for cleaning up filtered image later
h = fspecial('disk',5);

% Reads all images in the folder specified.
% Each image is passed through the mask function and filtered.
% New mask and filtered images are written to the original image folder
for i = 1:nfiles
    imName = images(i).name;
    currentImage = imread(imName);
    mask = background(currentImage); % Change function here
    foldername = fullfile('C:\Users\emcka\MATLAB Drive\Image processing\Show images\bottlecap',  sprintf('backgroundZ_%d.jpg',i));
    imwrite(mask,foldername);
    filt = imfilter(mask,h,'symmetric');
    foldername = fullfile('C:\Users\emcka\MATLAB Drive\Image processing\Show images\bottlecap',  sprintf('background_%d.jpg',i));
    imwrite(filt,foldername);
end

% New written images are named so that the last number in the image name
% relates to an original image. Datastroes are created for each original
% image and their corresponding mask and filter images.
% This allows for viewing the effect of each step on the image using the
% 'montage' function on each datastore.
% Usin 'montage' on the entire image folder produces a low quality output
% of all images.
firstImages = 'C:\Users\emcka\MATLAB Drive\Image processing\Show images\bottlecap\*1.jpg';
firstds = imageDatastore(firstImages);
secondImages = 'C:\Users\emcka\MATLAB Drive\Image processing\Show images\bottlecap\*2.jpg';
secondds = imageDatastore(secondImages);
thirdImages = 'C:\Users\emcka\MATLAB Drive\Image processing\Show images\bottlecap\*3.jpg';
thirdds = imageDatastore(thirdImages);
%fourImages = 'C:\Users\emcka\MATLAB Drive\Image processing\Show images\Multiple\*4.jpg';
%fourdds = imageDatastore(fourImages);

figure, montage(firstds,'Size',[1 3])
figure, montage(secondds,'Size',[1 3])
figure, montage(thirdds,'Size',[1 3])
%figure, montage(fourdds,'Size',[1 3])