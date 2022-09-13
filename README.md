# Code_for_topographic_analysis
% Skeleton code to demonstrate analysis of saltmarsh topography
  
% September 2022 - MSc Environmental Modelling Dissertation
  
% Notes:  
% 1. This script reads lidar tiles in the GeoTIFF format used by  
%    Defra, which has replaced the older ESRI grid format.  
% 2. The outline workflow including Pre-processing, Segmentation and   
%    Save data. The details are shown below.  
% 3. The code for reading LiDAR data is modified from the code of  
%    Professor Jon French.  
% 4. Compatative analysis script reads all the mat files save in the topographic analysis,  
%    which includs the amsked elevation, the abslute area of site,  
%    percentage area of sub-environemts and mean elevation of  
%    sub-environments.  
  
% Tested:       MATLAB 2020a  
% Dependencies: Mapping Toolbox  
  
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
