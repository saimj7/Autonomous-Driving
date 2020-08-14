clc;close all;clear all
%with augmentation
%load('epochs51lr0.07acc91.6.mat','net')

GTSRBPath = fullfile(matlabroot,'toolbox','GTSRB');
imds = imageDatastore(GTSRBPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');


GTRSBTest = fullfile(matlabroot,'testdata');
imds_test = imageDatastore(GTRSBTest, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');


labelCount = countEachLabel(imds)

% img = readimage(imds,1);
% imshow(img)
% size(img)

numTrainFiles = 0.90    
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles);

% pixelRange = [-30 30];
%scaleRange = [0.9 1.1];
%    'RandXTranslation',pixelRange, ...
 %   'RandYTranslation',pixelRange, ...
  %  'RandXScale',scaleRange, ...
   % 'RandYScale',scaleRange)
   
augmenter = imageDataAugmenter( ...
    'RandRotation',[-20,20], ...
    'RandXTranslation',[-3 3], ...
    'RandYTranslation',[-3 3],...    
    'RandXshear',[0  0.3], ...
    'RandYshear',[0 0.3],...
    'RandScale',[0.8 1]);

imageSize = [48 48 3];
augimdsTrain = augmentedImageDatastore(imageSize,imdsTrain,'DataAugmentation',augmenter)

augimdsValidation = augmentedImageDatastore(imageSize,imdsValidation);
minibatch=preview(augimdsTrain)
imshow(imtile(minibatch.input))

%%
ds1 = augmentedImageDatastore(imageSize,imds_test);


layers = [
imageInputLayer([48 48 3])
    
    %'BiasL2Factor',1
    convolution2dLayer(1,1,'Stride',1,'Padding',0)
    batchNormalizationLayer
    reluLayer
  
    convolution2dLayer(5,29,'Stride',1,'Padding',0)
    batchNormalizationLayer
    reluLayer
     
    maxPooling2dLayer(3,'Stride',2,'Padding',0) %padding 1 means zero padding same padding one to get zero padding
    dropoutLayer(0.1)
    
    convolution2dLayer(3,59,'Stride',1,'Padding',0)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(3,'Stride',2,'Padding',0)
    dropoutLayer(0.1)
    
    convolution2dLayer(3,74,'Stride',1,'Padding',0)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(3,'Stride',2,'Padding',0)
    dropoutLayer(0.1)
    
    %'WeightL2Factor',1,'BiasL2Factor',1
    fullyConnectedLayer(300)
    dropoutLayer(0.5)
    fullyConnectedLayer(225)
    dropoutLayer(0.5)
    fullyConnectedLayer(43)
    softmaxLayer
    classificationLayer];

% 'adam','GradientDecayFactor',0.95,'SquaredGradientDecayFactor',0.99, ...
% 'L2Regularization',0.0005, ...
% 'LearnRateSchedule','piecewise', ...
% 'LearnRateDropFactor', 0.0004,'LearnRateDropPeriod',10, ...
%'InitialLearnRate',0.005, ...
%'LearnRateDropFactor', 0.2,'LearnRateDropPeriod',3, ...


options = trainingOptions('adam', ...
    'MiniBatchSize',128, ...
    'MaxEpochs',80, ...
    'L2Regularization',0.00001, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',500, ...
    'Verbose',true,'VerboseFrequency',500,'CheckpointPath','C:\temp\checkpoint\3', ...
    'ExecutionEnvironment','gpu', ...
    'Plots','training-progress');

net2 = trainNetwork(augimdsTrain,layers,options);

figure
[YPred,probs] = classify(net2,augimdsValidation);
YValidation = imdsValidation.Labels;

%accuracy = sum(YPred == YValidation)/numel(YValidation)
accuracy = mean(YPred == YValidation)

%%
%four sample validation images with predicted labels and predicted
%probabilities of images having those labels
idx = randperm(numel(imdsValidation.Files),4);
figure(1)
for i = 1:4
    subplot(2,2,i)
    I = readimage(imdsValidation,idx(i))        ;
    imshow(I)
    label = YPred(idx(i));
    title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
end

% previews 6 images in augimds
%ims = augimdsTrain.preview();
%montage(ims{1:6,1})
%Testing against new data from official benchmark
%%
[predtestlabels,probs1] = classify(net2, ds1)
load("germantestlabels.mat")
Ytest=Testlabels;
%%
idx1 = randperm(numel(imds_test.Files),4);

figure(2)
for i1 = 1:4
    subplot(2,2,i1)
    I2 = readimage(imds_test,idx1(i1));
    imshow(I2)
    label1 = predtestlabels(idx1(i1));
    title(string(label1) + ", " + num2str(100*max(probs1(idx1(i1),:)),3) + "%");
end
testaccuracy = mean(predtestlabels == Ytest)

save('gtsignsLabels.mat','Ytest','predtestlabels');