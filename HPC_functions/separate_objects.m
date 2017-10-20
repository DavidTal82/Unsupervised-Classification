function [ output_args ] = ...
    separate_objects( Data,PixelIdxList )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

V3D_temp = false(Data.ImageSize);
L3D_Z = zeros(Data.ImageSize);
L3D_Y = zeros(Data.ImageSize);
L3D_X = zeros(Data.ImageSize);

V3D_temp(PixelIdxList) = 1;

% points of the object
[x,y,z] = ind2sub(Data.ImageSize,PixelIdxList);

%% Z plane
[slices_3D_z,~] = label_2D_slices( V3D_temp , z , 'z' , Data.min_2D_area);
L3D_Z = label_3D_slices( slices_3D_z, min(z), max(z), 'z' , Data );

% %% Y plane
% [slices_3D_y,~] = label_2D_slices( V3D_temp , y , 'y' , Data.min_2D_area);
% Ymin = min(y);Ymax = max(y);
% 
% 
% %% X plane
% [slices_3D_x,~] = label_2D_slices( V3D_temp , x , 'x' , Data.min_2D_area);
% Xmin = min(x);Xmax = max(x);


end

