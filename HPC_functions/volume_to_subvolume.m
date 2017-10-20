function [ sub_I ] = volume_to_subvolume( I_path, sub )
%volume_to_subvolume takes the original image and returns a subvolume of
%that image, based on pre-determined size and coordinates
%   I_path - the path to the original image
%   sub_location - the size and location of the subvolume in the original
%   volume.

%load(I_path);% assuming the variable name is I
I = importdata(I_path);% loads data into array A.

sub_I = I(sub(1,1):sub(1,2),sub(2,1):sub(2,2),sub(3,1):sub(3,2));


end

