function [ G, L3D ] = update_global_3DL( Dim , i , points, G, L3D )
%update_global_3DL updates the global 3D label - G, based on the points
%table and the L3D table

% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z

switch Dim
    case 'x'
        for p=1:length(points(:,4))                         %updating the golobal volume
            G(i,points(p,1),points(p,2)) = points(p,4);
            if L3D(i+1,points(p,1),points(p,2)) &&...       %updating the next layer
                    ~G(i+1,points(p,1),points(p,2))
                G(i+1,points(p,1),points(p,2)) = points(p,4);
            end
        end % for p=1:length(points_n(:,4))
    
    case 'y'
        for p=1:length(points(:,4))                         %updating the golobal volume
            G(points(p,1),i,points(p,2)) = points(p,4);
            if L3D(points(p,1),i+1,points(p,2)) &&...       %updating the next layer
                    ~G(points(p,1),i+1,points(p,2))
                G(points(p,1),i+1,points(p,2)) = points(p,4);
            end
        end % for p=1:length(points_n(:,4))
    
    case 'z'
        for p=1:length(points(:,4))                         %updating the golobal volume
            G(points(p,1),points(p,2),i) = points(p,4);
            if L3D(points(p,1),points(p,2),i+1) &&...       %updating the next layer
                    ~G(points(p,1),points(p,2),i+1)
                G(points(p,1),points(p,2),i+1) = points(p,4);
            end
        end % for p=1:length(points_n(:,4))
end




end

