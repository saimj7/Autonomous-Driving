clc
close all
clear all
%path where you have images
sBasePath = 'C:\Users\asmna\Documents\ssd datasets\GTSRB_Final_Training_Images\GTSRB\Final_Training\Images'; 
%  sBasePath = 'C:\Program Files\MATLAB\R2018b\toolbox\GTSRB'
k2=0;
ImgClasses=zeros(42,1)
for nNumFolder = 0:42 %classes you want to take and train define here
    sFolder = num2str(nNumFolder, '%05d');
    sPath = [sBasePath, '\', sFolder, '\'];
    if isdir(sPath)
        [ImgFiles, Rois, Classes] = readSignData([sPath, '\GT-', num2str(nNumFolder, '%05d'), '.csv']);
        cl{nNumFolder+1}=Classes; %cell array
         Il{nNumFolder+1}=ImgFiles ;%cell array
       [m2 n2] = size(Classes)
        ImgClasses(nNumFolder+1,1)=m2
        for i = 1:numel(ImgFiles) %images in that particular class
            ImgFile = [sPath, '\', ImgFiles{i}];
          Img = imread(ImgFile);
             fprintf(1, 'Currently training: %s Class: %d Sample: %d / %d\n', ImgFiles{i}, Classes(i), i, numel(ImgFiles));
            % if you want to work with a border around the traffic sign
            %rois has different sizes too though less variations
            % comment the following line 
%             Img = Img(Rois(i, 2) + 1:Rois(i, 4) + 1, Rois(i, 1) + 1:Rois(i, 3) + 1);
%one preprocessing is simple grayscale conversion and reshaping which
%employs decimation-interpolation to each image in class
            Ig=rgb2gray(Img);
            Irshape = imresize(Ig, [74, 74]);
            Irs(:,:,i+k2)=Irshape;
        end
    end
end
Classes=cell2mat(cl')
%saves classes and images after preprocessing in the matfile
%in sequence from begining class or you can define if you want to train
%particular class
save('Loading-Preprocessing-data.mat','Classes','Irs','ImgClasses')