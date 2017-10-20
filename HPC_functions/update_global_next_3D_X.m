function [ G_X ] = update_global_next_3D_X( G_X, L3D_X, points, ix )
%update_global_3D_Z Updates the global labels of points
% input - G_y, points to update and iy
% output - updated G_Y

for p=1:length(points(:,4))
    G_X(ix,points(p,1),points(p,2)) = points(p,4);
end % for p=1:length(points_n(:,4))

for p=1:length(points(:,4))
    if L3D_X(ix+1,points(p,1),points(p,2)) &&...
            ~G_X(ix+1,points(p,1),points(p,2))
        G_X(ix+1,points(p,1),points(p,2)) = points(p,4);
    end
end % for p=1:length(r)
end

