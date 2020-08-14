clc;close all;clear all

%% loading of data one class only
%path of text file containign details
%images and code and .csv containing text must be same folder
path='D:\Data sets\GTSRB_Matlab_code\Matlab code for GTSRB\00000\GT-00000.csv'

[rImgFiles, rRois, rClasses]=readSignData(path)
% brackets instead of matrix notation for considering data of brackets
% a=rImgFiles{1,1} 
% b=imread(a)
% [x1,y1,z1]=size(b)

%% resizing by decimation-interpolation for fully connected layers (loss of features due to adding)

% which scaling to empploy based on minimum,maximum,fixed size in database (group of images).
% effects based on scaling

[m,n]=size(rImgFiles)

minrows=1000 % maximum of images which shouldnt cross to find max
mincolumns=1000 
for i=1:m
Images=imread(rImgFiles{i,1});
[rows, columns, numberOfColorChannels] = size(Images);
if rows < minrows
  minrows = rows;
end
if columns < mincolumns
  mincolumns = columns;
end
end

maxrows=0 
maxcolumns=0 
for i=1:m
Images=imread(rImgFiles{i,1});
[rows, columns, numberOfColorChannels] = size(Images);
if rows > minrows
  minrows = rows;
end
if columns > maxcolumns
  maxcolumns = columns;
end
end

%we get max rows and colunms in data using which we can change data however
%we like by scaling or etcccc

%one application to make same data since neural network needs same nodes in
%multilayer percepton or fully connected layers

%we can use adaptive pooling too

%imresize changes all images to equal indexes by interpolation or
%decimation for minimum size
    Images=imread(rImgFiles{1,1});
Images = imresize(Images, [minrows, mincolumns]);
