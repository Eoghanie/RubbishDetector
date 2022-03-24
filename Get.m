clc
close all
clear all

SetDir = fullfile('C:\Users\emcka\MATLAB Drive\ObjectDetection\Training data');
Imds = imageDatastore(SetDir,'IncludeSubfolders',true);

annotationFile = jsondecode(fileread("annotations.json"));
save('Annotations.mat',"annotationFile")

trainClassNames = {'Bottle', 'Can','Bottle cap'};
numClasses = length(trainClassNames);
imageSizeTrain = [800 800 3];




