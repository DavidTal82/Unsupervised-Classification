function [ G_Y ] = Y_separation_8HW( Data, L3D_Y, y )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z

K_neighboors = Data.K_neighboors;

G_Y = zeros(Data.ImageSize);

for iy = min(y):max(y)
    
    problem_flag_1 = 0; 
    
    [r,c] = find(squeeze((L3D_Y(:,iy,:))));
    % r|c|local|global
    points = zeros(length(r),4);
    for p=1:length(r)
        points(p,1)=r(p);
        points(p,2)=c(p);
        points(p,3)=L3D_Y(r(p),iy,c(p));
        points(p,4)=G_Y(r(p),iy,c(p));
    end % for p=1:length(r)
    
    
    I_1 = squeeze(G_Y(:,iy,:));
    P_1 = points;
    
    % all global are labeled
    if min(points(:,4))>0
        [G_Y,L3D_Y] = update_global_3DL('y',iy,points,G_Y,L3D_Y);
        continue;
    end
    
    L_max = max(G_Y(:));
    
    local_global = unique(points(:,3:4),'rows');
    local = unique(points(:,3));              %unique local
    golbal = unique(points(points(:,4)>0,4)); %unique global
    
    
    % Case 1 - all new global labels
    if length(unique(local_global(:,2)))==1 && unique(local_global(:,2))==0
        for n = 1:length(local)
            L_max = L_max + 1;
            points(points(:,3)==local(n),4) = L_max;
        end
        [ G_Y, L3D_Y ] = update_global_3DL( 'y' , iy , points, G_Y, L3D_Y );
        continue
    end
    
    
    no_label = find(points(:,4)==0);                % un labeled points
    local_of_unlabeled = unique(points(no_label,3));% local of unlabeled
    
    
    for n = 1:length(local_of_unlabeled)            % loop over the local labels
        
        % finding the local-global overlap
        local_global_temp = local_global(local_global(:,1)==local_of_unlabeled(n),:);
        
        % Case 2 - un labeled points belong to one existing global
        % only one global and zeros
        if length(local_global_temp(local_global_temp(:,2)>0,2))==1
            
            Lia = ismember(points(:,3:4),[local_of_unlabeled(n),0],'rows');
            points(Lia,4) = local_global_temp(2,2);
            
            % Case 3 - unlabeld points belonge to more than one exsiting global
            % more than one global in the same local
        elseif length(local_global_temp(local_global_temp(:,2)>0,2)) > 1 && min(local_global_temp(:,2))==0
            
            Lia = ismember(points(:,3:4),local_global_temp,'rows');
            
            Lia_no = ismember(points(:,3:4),[local_of_unlabeled(n),0],'rows');
            Lia_yes = Lia;
            Lia_yes(Lia_no) = 0;
            
            ind_no = find(Lia_no);
            ind_yes = find(Lia_yes);
            
            [ points ] = assign_label( points, ind_yes, ind_no, K_neighboors );
            
            
        elseif length(local_global_temp(local_global_temp(:,2)>0,2)) > 1 && min(local_global_temp(:,2))>0
            disp(['despiute problem with labeled golbal: ',num2str(iy)]);
            
            % many small objects -> begining of a transverse tow
        elseif length(local_global_temp(:,2))==1 && local_global_temp(1,2)==0
            Lia = ismember(points(:,3:4),local_global_temp,'rows');
            points(Lia,4) = -1;
            
            
        else
            disp(['problem: ',num2str(iy)]);
        end
        
        ind_local = find(points(:,3)==local_of_unlabeled(n));
        g_in_l = unique(points(ind_local,4));
        
        % Case 3 problem_flage_1
        if length(g_in_l) > 1
            %disp(['problem in slice-',num2str(iy),', more than one global in local']);
            problem_flag_1 = 1;
        end
        
    end     % end of loop over local labels
    
    % This case is mostly for transverse tows
    if min(points(:,4)) == -1
        L_max = L_max + 1;
        points(points(:,4) == -1,4) = L_max;
        new_transverse = 1;
    end
    
    un_resolved = find(points(:,4)==0); % points under conflicting neighbors
    if ~isempty(un_resolved)
        points(un_resolved,4) = -2;
        IDX = knnsearch([points(:,1),points(:,2)],[points(un_resolved,1),points(un_resolved,1)],'k',K_neighboors);
        k_nearest = reshape(points(IDX,4),size(IDX));
        points(un_resolved,4) = mode(k_nearest,2);
    end
    
    I_2 = I_1;
    I_2_local = squeeze(L3D_Y(:,iy,:));
    for p=1:length(points(:,4))
        I_2(points(p,1),points(p,2)) = points(p,4);
    end % for p=1:length(r)
    
    % case 3 - un labeled points belong to extising and new globals
    %          in this case new globals are transverse tows
    [ problem_flag_2, labels2fix ] = ...
        check_labels_connectivity(Data,I_2,I_2_local,iy,problem_flag_1);
    
    if problem_flag_2 && problem_flag_1
        points = fix_labels_connectivity(points,labels2fix);
    end
    
    [ G_Y, L3D_Y ] = update_global_3DL( 'y' , iy , points, G_Y, L3D_Y );
    
    if problem_flag_2 && problem_flag_1
        G_Y = fix_backwards_labels_connectivity(iy,labels2fix,G_Y);
    end
    
    
end % for iy = min(y):max(y)


end

