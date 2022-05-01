%% Transfe learning on resnet50 neural netwrork for image classification
% Reference: MathWorks/Help Center/Documantation/Train Deep Learning 
% Network to Classify New Images
% Trained by: Eoghan Mckay
% Date: 26/02/2022
% Trained on batch_9, 7 classes (see batch_9 & subfolders)

% Load training images in to current folder
imds = imageDatastore('ClassifyImages', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames'); 
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7); % Divide images into training (70%) and validation (30%)
% Vary the data split, use more for training

%% Load pretrained network
net = resnet50; % Other networks can be used here and trained
analyzeNetwork(net) % Shows network
net.Layers(1); % Extract info from first layer 
inputSize = net.Layers(1).InputSize; % Resizes images to correct size for 
% network

%% Replace final layers
lgraph = layerGraph(net);
% 'findLayerToReplace' is a Matlab function
% it finds and replaces the two layers that combine the features the
% network extracts.
% New layers must be created for the new network
[learnableLayer,classLayer] = findLayersToReplace(lgraph);
[learnableLayer,classLayer]
% Replaces the number new fully connected layer with a layer that has an
% output for each new class (7) 
numClasses = numel(categories(imdsTrain.Labels));

% 'isa' is a Matlab function that determines if the input has a specified
% data type
if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);
% Classifiaction layer replaced by  a classification layer that has no
% class labels. These will be created automatically after training
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);
% Checks if new layers are connected correctly
figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])

layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

%% Train Network
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);
augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);
miniBatchSize = 10;
valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(augimdsTrain,lgraph,options);
% Classifies the validation images using the trained network
[YPred,probs] = classify(net,augimdsValidation);
accuracy = mean(YPred == imdsValidation.Labels) % Calculate accuracy of 
% trained network
% Dispalys four random sample images from validation with labels and
% probabilities
idx = randperm(numel(imdsValidation.Files),4);
figure
for i = 1:4
    subplot(2,2,i)
    I = readimage(imdsValidation,idx(i));
    imshow(I)
    label = YPred(idx(i));
    title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
end
