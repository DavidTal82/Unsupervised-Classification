function [ G_Z ] = Z_separation( Data, L3D_Z, z )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z

G_Z = zeros(Data.ImageSize);

for iz = min(z):max(z)
    
    L_max = max(G_Z(:));
    
    current_local_slice = squeeze(L3D_Z(:,:,iz));
    current_global_slice = squeeze(G_Z(:,:,iz));
    
    lin_ind = find(current_local_slice);
    [r,c] = ind2sub([Data.ImageSize(1),Data.ImageSize(1)],lin_ind);
    
    
    % r|c|local|global|lin_ind|action
    % action: 0 - do nothing, dont change global
    %         1 - global is zero, need to find it
    %        -1 - global assigned
    %         2 - 
    points = zeros(length(r),6);
    points(:,1) = r;
    points(:,2) = c;
	points(:,3) = current_local_slice(lin_ind);
    points(:,4) = current_global_slice(lin_ind);
    points(:,5) = lin_ind;
    points(~points(:,4),6) = 1;
    
    p_empty = find(points(:,6)==1);
    
    n_local = unique(points(:,3));              %unique local
    n_golbal = unique(points(points(:,4)>0,4)); %unique global
    
    for n = 1:length(n_local)
        p_ind = find(points(:,3)==n_local(n));           %local label n
        p_empty_in_n = intersect(p_empty,p_ind);%empty global in local n
        
        if isempty(p_empty_in_n);continue;end
        
        points_n = points(p_ind,:);             %only points in local label n
        n_g_in_l = unique(points_n(points_n(:,4)>0,4));
        
        if isempty(n_g_in_l)            %no global in local
            L_max = L_max+1;
            points_n(:,4) = L_max;
            points_n(:,6) = -1;
        
        elseif length(n_g_in_l) == 1    %one global in the n-th local
            points_n(points_n(:,6)==1,4) = n_g_in_l;
            points_n(points_n(:,6)==1,6) = -1;
        
        elseif length(n_g_in_l) > 1     %more than one global in the n-th local
            p2l = find(points_n(:,6)==1);   %points to label
            pl = find(points_n(:,6)~=1);    %points that are labeld
            
            [IDX] = knnsearch([points_n(pl,1),points_n(pl,2)],...
                [points_n(p2l,1),points_n(p2l,2)]);
            
            points_n(p2l,4) = points_n(pl(IDX),4);
            points_n(p2l,6) = -1;            
        end
        
        if length(p_empty_in_n)~=length(p_ind(points_n(:,6)==-1))
            disp('problem');
        end
        
        %updating the points table - only where changed
        points(p_ind(points_n(:,6)==-1),4:6) = points_n(points_n(:,6)==-1,4:6);                %updating the points table
        % points(p_ind,4) = points_n(:,4); % updating everywhere    
    end % n = 1:length(n_local)
    
    
    %updating the golobal volume
    [G_Z] = update_global_3D_Z(G_Z,points(points(:,6)==-1,:),iz); 
    
    [ conn_mat, split_flag ] = get_connectiviey( points ,max(G_Z(:)));
    
    % if length(unique(conn_mat(:,2)))~=length(unique(conn_mat(:,3)))
    if ~isequal(conn_mat(:,2),conn_mat(:,3)) && split_flag
        for m = 1:length(conn_mat(:,1))
            ind_l = find(points(:,3)==conn_mat(m,1));
            ind_g = find(points(:,4)==conn_mat(m,2));
            ind = intersect(ind_l,ind_g);
            points(ind,4) = conn_mat(m,3);
        end % for m = 1:length(conn_mat(:,1))
    end
    
    % updating the previous slices if needed
    if ~isequal(conn_mat(:,2),conn_mat(:,3)) && split_flag
        g2change = find(conn_mat(:,2)~=conn_mat(:,3));
        for m = 1:length(g2change)
            G_Z = update_previous('z',iz,L3D_Z,G_Z,conn_mat(g2change(m),:));
        end %for m = 1:length(g2change)
    else
        [G_Z] = update_global_3D_Z(G_Z,points(points(:,6)==-1,:),iz);
    end
    
    % update the next slice
    [ G_Z ] = update_global_next_3D_Z( G_Z, L3D_Z, points, iz );

end % for iz = min(z):max(z)


end

