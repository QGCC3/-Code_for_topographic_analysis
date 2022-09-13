% 
% Skeleton code to demonstrate analysis of saltmarsh topography
% 
% September 2022 - MSc Environmental Modelling Dissertation
%
% Notes:
% 1. This script reads lidar tiles in the GeoTIFF format used by
%    Defra, which has replaced the older ESRI grid format.
% 2. The outline workflow including Pre-processing, Segmentation and 
%    Save data. The details are shown below.
% 3. The code for reading LiDAR data is modified from the code of 
%    Professor Jon French.
%
% Tested:       MATLAB 2020a
% Dependencies: Mapping Toolbox
%
% Workflow:
% Pre-processing: 
%   Set the HAT and MSL for thresholding DEM
%   Define the polygon for region of interest in site
% Segmentation:
%   Change binary image to indexed type
%   Change indexed image to RGB type
%   Use RGB colour space to segmentation
%   Calculate area ratio for each sub-environment
% Save Data:
%   Build a struct for all the topographic data

clear
close all

%% Pre-processing: Set the HAT and MSL for thresholding DEM

HAT= 3.2; % highest astronomical tide 
MSL = 0.2; % mean sea level
%% Pre-processing: Define the polygon for region of interest in site

% Read LiDAR DEM
% Select a lidar tile
[file,path,indx] = uigetfile('*.tif');
if isequal(file,0)
   disp('User selected Cancel')
else
   filepath = fullfile(path, file);
   disp(['User selected ', filepath,... 
         ' and filter index: ', num2str(indx)])
end

% Display metadata
info = georasterinfo(filepath);
disp(info)
[Z1,R] = readgeoraster(filepath,'OutputType','double');

% Setup spatial coordinates for DEM
cellsize = R.CellExtentInWorldX;  %assume cells are square so just use x
X = R.XWorldLimits(1):cellsize:R.XWorldLimits(2)-1;
Y = R.YWorldLimits(1):cellsize:R.YWorldLimits(2)-1;

% Trim elevation range to threshold high ground and subtidal areas
Z1(Z1 > HAT) = HAT;
Z1(Z1 < MSL) = MSL;

% Visualise DEM raster as georeferenced image
[Xg,Yg] = meshgrid(X,Y);
figure(1)
imagesc(X,Y,Z2)
colormap gray %change color to gray
axis equal

% Crop image using ROI to reduce memory use
% Interactively define a polygon (digitise, right-click > create mask)
I = mat2gray(Z1);  % a grayscale image is needed to use ROIPOLY function
[BW, xi,yi] = roipoly(I);

% Save the polygon for the following topographic analysis
bw1=imcomplement(BW);
save('Polygon2SB.mat','xi','yi','bw1');
%% Segmentation: Change binary image to indexed type
% Read LiDAR DEM again but load the saved polygon

% Set threshold
HAT= 3.2; 
MSL = 0.2; 

% Select a lidar tile
[file,path,indx] = uigetfile('*.tif');
if isequal(file,0)
   disp('User selected Cancel')
else
   filepath = fullfile(path, file);
   disp(['User selected ', filepath,... 
         ' and filter index: ', num2str(indx)])
end

% Display metadata
info = georasterinfo(filepath);
disp(info)
[Z1,R] = readgeoraster(filepath,'OutputType','double');

% Setup spatial coordinates for DEM
cellsize = R.CellExtentInWorldX;  %assume cells are square so just use x
X = R.XWorldLimits(1):cellsize:R.XWorldLimits(2)-1;
Y = R.YWorldLimits(1):cellsize:R.YWorldLimits(2)-1;

% Trim elevation range to threshold high ground and subtidal areas
Z1(Z1 > HAT) = HAT;
Z1(Z1 < MSL) = MSL;

% LOAD THE MASK
load('Polygon2SB.mat');
Z2=Z1;
Z2(bw1>0)=nan;

% Visualise DEM raster as georeferenced image
[Xg,Yg] = meshgrid(X,Y);
figure(1)
imagesc(X,Y,Z2)
colormap gray %change color to gray
axis equal

% Change the gray image to index image
% Set the number of colormap colors
Z3 = gray2ind(Z2,100);
figure(2)
imagesc(X,Y,Z3)
axis equal
%% Segmentation: Change indexed image to RGB type
cmap = colormap;
Z4 = ind2rgb(Z3,cmap);
figure(3)
imagesc(X,Y,Z4)
axis equal
%% Segmentation: Use RGB colour space to segmentation
% Define thresholds for Salt pans
sliderBW1 = (Z4(:,:,1) <= 0.958) & (Z4(:,:,2) >= 0.200)...
    &(Z4(:,:,3) <= 0.530);
% Define thresholds for Saltmarsh
sliderBW2 = (Z4(:,:,1) >= 0.958);
% Define thresholds for channel
sliderBW3 = (Z4(:,:,3) >= 0.530)& (Z4(:,:,2) >= 0.200);

% Initialize output masked image based on input image.
Z5 = Z4;
Z6 = Z4;
Z7 = Z4;

% Set background pixels where BW is false to zero.
Z5(repmat(~sliderBW1,[1 1 3])) = 0;
Z6(repmat(~sliderBW2,[1 1 3])) = 0;
Z7(repmat(~sliderBW3,[1 1 3])) = 0;

figure
imshow(Z5);
figure
imshow(Z6);
figure
imshow(Z7)
%% Segmentation: Calculate area ratio for each sub-environment

% Absolute site area
site=Z2;
site(isnan(site))=0;
site(site>0.1)=1;
% Use regionprops to get the pixel area of each site
siteProps= regionprops("table",site,"Area");
sitearea=sum(siteProps.Area);
% the area is calculated by the resolution and pixel
% Euation: AA(ha)=R^2 (m^2 )×P×0.0001
% Where AA is the absolute area of each site, 
% R is the resolution (m) of LiDAR data and 
% the area for one cell is the square of the resolution, 
% P is the number of pixels in each site. 
Resolution = 1;
AbsoluteAreaHa=sprintf('%2.1f%',sitearea*Resolution*0.0001);

%Salt Pans:Percentage area and mean elevation
PansColor = rgb2ind(Z5,cmap);
Pans=Z1;
Pans(PansColor<0.2)=0;
Pans(PansColor>=0.2)=1;
PansProps = regionprops("table",Pans,"Area");
PansArea = sum(PansProps.Area);
PansArea=(PansArea/sitearea);
PansAR=sprintf('%2.1f%%', PansArea*100);

MeanPansDEM=mean(mean(Z1(PansColor>0)));
PansElevation=sprintf('%2.2f%', MeanPansDEM);

% Saltmarsh:Percentage area and mean elevation
SaltmarshColor = rgb2ind(Z6,cmap);
Saltmarsh=Z1;
Saltmarsh(SaltmarshColor<0.2)=0;
Saltmarsh(SaltmarshColor>=0.2)=1;
SaltmarshProps = regionprops("table",Saltmarsh,"Area");
SaltmarshArea = sum(SaltmarshProps.Area);
SaltmarshArea=(SaltmarshArea/sitearea);
saltmarshAR=sprintf('%2.1f%%', SaltmarshArea*100);

MeanSaltmarshDEM=mean(mean(Z1(SaltmarshColor>0)));
SaltmarshElevation=sprintf('%2.2f%', MeanSaltmarshDEM);

% Channel: area
ChannelColor = rgb2ind(Z7,cmap);
Channel=Z1;
Channel(ChannelColor<0.2)=0;
Channel(ChannelColor>=0.2)=1;
ChannelProps = regionprops("table",Channel,"Area");
ChannelArea = sum(ChannelProps.Area);
ChannelArea=(ChannelArea/sitearea);
ChannelAR=sprintf('%2.1f%%', ChannelArea*100);
%% Save all topographic data
Zdata_bwSteepleBay.DEM=Z1;
Zdata_bwSteepleBay.maskedDEM=Z2;
Zdata_bwSteepleBay.ind=Z3;
Zdata_bwSteepleBay.rgb=Z4;
Zdata_bwSteepleBay.pans=Z5;
Zdata_bwSteepleBay.saltmarsh=Z6;
Zdata_bwSteepleBay.channel=Z7;
Zdata_bwSteepleBay.SiteArea=AbsoluteAreaHa;
Zdata_bwSteepleBay.pansarea=PansAR;
Zdata_bwSteepleBay.meanpansdem=PansElevation;
Zdata_bwSteepleBay.saltmarsharea=saltmarshAR;
Zdata_bwSteepleBay.meansaltmarshdem=SaltmarshElevation;
Zdata_bwSteepleBay.channelarea=ChannelAR;
save('Zdata_bwSteepleBay.mat','-v7.3','Zdata_bwSteepleBay')

