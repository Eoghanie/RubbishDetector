%% Classification Tester
% Created by: Eoghan Mckay
% Date created: 25/03/2022
%% Image classification on single image
% Run a single image through a neural network for classifying

net = resnet101; % Changeable nnet
inputSize = net.Layers(1).InputSize;
classNames = net.Layers(end).ClassNames;
I = imread("C:\Users\emcka\MATLAB Drive\Image processing\Show images\plasticbag\pbag1.jpg");
new = imresize(I,inputSize((1:2)));
[label,scores] = classify(net,new);
figure
imshow(new)
title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");


%% Classify multiple images
% To run multiple images through an image classifier and show confidence.

% Prepare images
imds = dir('C:\Users\emcka\MATLAB Drive\Image processing\Show images\*\*.jpg');
num = numel(imds);

% Define network to use
net = efficientnetb0;
inputSize = net.Layers(1).InputSize;
classNames = net.Layers(end).ClassNames;


for i = 1:num
    nexttile
    imName = imds(i).name;
    image = imread(imName);
    currentImage =imresize(image,inputSize((1:2)));
    imshow(currentImage)
    [label,scores] = classify(net,currentImage);
    title(string(label) + ", " + num2str(100*scores(classNames == label),3) + "%");
end
