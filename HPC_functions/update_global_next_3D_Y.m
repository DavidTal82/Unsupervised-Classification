function [ G_Y ] = update_global_next_3D_Y( G_Y, L3D_Y, points, iy )
%update_global_3D_Z Updates the global labels of points
% input - G_y, points to update and iy
% output - updated G_Y

for p=1:length(points(:,4))
    G_Y(points(p,1),iy,points(p,2)) = points(p,4);
end % for p=1:length(points_n(:,4))

for p=1:length(points(:,4))
    if L3D_Y(points(p,1),iy+1,points(p,2)) &&...
            ~G_Y(points(p,1),iy+1,points(p,2))
        G_Y(points(p,1),iy+1,points(p,2)) = points(p,4);
    end
end % for p=1:length(r)
end

