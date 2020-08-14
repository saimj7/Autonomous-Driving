clc
close all
clear all
load Loading-Preprocessing-data.mat

Images = Irs;

Labels = Classes;
Labels(Labels == 0) = 43;    % 0 --> 43
% hotcode encoding check for 0
rng(1);
% random seed
% Learning
%
Wc = 1e-2*randn([9 9 20]);
Wph = (2*rand(100, 21780) - 1) * sqrt(6) / sqrt(360 + 21780);
Who = (2*rand( 43,  100) - 1) * sqrt(6) / sqrt( 43 +  100);

%traning data using which we train back propogation
X = Images(:, :, 1:4500);
O = Labels(1:4500);

for epoch = 1:1
  epoch
  [Wc, Wph, Who] = BackPropogationlayer1(Wc, Wph, Who, X, O);
end

save('trafficsign.mat');


