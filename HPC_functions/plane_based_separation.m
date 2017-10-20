function [ output_args ] = ...
    plane_based_separation( obj3D, xyz, Dim, min_2D_area)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x = xyz(:,1);
y = xyz(:,2);
z = xyz(:,3);

% 2D connectivity in 3 directions
switch Dim
    case 'x'
        [ L3D_slices_x, slice_objects_x ] = label_2D_slices( obj3D , x , 'x' , min_2D_area);
    case 'y'
        [ L3D_slices_y, slice_objects_y ] = label_2D_slices( obj3D , y , 'y' , min_2D_area);
    case 'z'        
        [ L3D_slices_z, slice_objects_z ] = label_2D_slices( obj3D , z , 'z' , min_2D_area);
end




end

