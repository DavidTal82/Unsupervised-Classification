function [ G_Z ] = update_global_next_3D_Z( G_Z, L3D_Z, points, iz )
%update_global_3D_Z Updates the global labels of points
% input - G_z, points to update and iz
% output - updated G_Z

for p=1:length(points(:,4))
    G_Z(points(p,1),points(p,2),iz) = points(p,4);
end % for p=1:length(points_n(:,4))

for p=1:length(points(:,4))
    if L3D_Z(points(p,1),points(p,2),iz+1) &&...
            ~G_Z(points(p,1),points(p,2),iz+1)
        G_Z(points(p,1),points(p,2),iz+1) = points(p,4);
    end
end % for p=1:length(r)
end

