function [ L3D_X, L3D_Y, L3D_Z ] = ...
    label_2D_slices( PixelIdxList, Data)
%label_2D_slices labels the 3D volume based on 2D slices in the x, y and z
%direction 
%   input: pixel list
%          image data
%   output: 3 3D volumes with 2D labeling

V3D = false(Data.ImageSize);
V3D(PixelIdxList) = 1;

L3D_Z = zeros(Data.ImageSize);%,'uint8');
L3D_Y = zeros(Data.ImageSize);%,'uint8');
L3D_X = zeros(Data.ImageSize);%,'uint8');

for ix=1:Data.ImageSize(1)
    L_temp = bwlabel(squeeze(V3D(ix,:,:)));
    if ~max(L_temp(:));continue;end    
    L3D_X(ix,:,:) = L_temp;   
end

for iy=1:Data.ImageSize(2)
    L_temp = bwlabel(squeeze(V3D(:,iy,:)));
    if ~max(L_temp(:));continue;end    
    L3D_Y(:,iy,:) = L_temp;   
end

for iz=1:Data.ImageSize(3)    
    L_temp = bwlabel(squeeze(V3D(:,:,iz)));
    if ~max(L_temp(:));continue;end    
    L3D_Z(:,:,iz) = L_temp;   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Permutaion - matlab switches x and y when dealing with a figure, to
% correct the prolem - permutaion of the 3D arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L3D_X = permute(L3D_X,[2,1,3]);
% L3D_Y = permute(L3D_Y,[2,1,3]);
% L3D_Z = permute(L3D_Z,[2,1,3]);



end

