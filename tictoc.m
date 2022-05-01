%% Time tests for different networks
% Written by: Eoghan Mckay
% Date written: 02/02/2022
% Use 'tic, toc' to estimate the time taken for networks to output a result
% and functions to mask objects. The same image is used for each test.
I = imread("C:\Users\emcka\MATLAB Drive\Image processing\" + ...
    "Show images\plasticbag\pbag1.jpg");


%% Time test for IP functions
h = fspecial('disk',15);
tic
mask =  background(I); % Change function
filt = imfilter(mask,h,'symmetric');
toc
figure, imshow(filt)

%% Time test for neural networks
net = inceptionv3; % Changeable nnet
inputSize = net.Layers(1).InputSize;
classNames = net.Layers(end).ClassNames;
tic
new = imresize(I,inputSize((1:2)));
[label,scores] = classify(net,new);
toc
figure
imshow(new)
title(string(label) + ", " + ...
    num2str(100*scores(classNames == label),3) + "%");
%% Time test for untrained Mark R-CNN w/ resnet50
detector = ssdObjectDetector('resnet50-coco');
load resnet50
pretrained = resnet50;
tic
net = pretrained.net;
[masks,labels,scores,boxes] = segmentObjects(detector,I,Threshold=0.5);
toc
overlayedImage = insertObjectMask(I,masks);
imshow(overlayedImage)
showShape("rectangle",boxes,Label=labels,LineColor=[1 0 0])
