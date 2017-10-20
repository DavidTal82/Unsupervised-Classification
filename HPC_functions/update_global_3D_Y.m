function [ G_Y ] = update_global_3D_Y( G_Y, points, iy )
%update_global_3D_Z Updates the global labels of points
% input - G_Y, points to update and iy
% output - updated G_Y

for p=1:length(points(:,4))
    G_Y(points(p,1),iy,points(p,2)) = points(p,4);
end % for p=1:length(points_n(:,4))


end

