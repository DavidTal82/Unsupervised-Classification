function [ output_args ] = ...
    label_3D_slices( slices_2D, p_min, p_max, Dim , Data )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

L3D_temp = zeros(Data.ImageSize);

for ip = p_min:p_max
    
    % getting 2 folloing sliced (in the Dim dimension)
    [ i_S_1, i_S_2, i_V_1, i_V_2 ] = ...
        get2slices( ip,Dim, L3D_temp, slices_2D);
    
    n_objects_in_slice = max(max(i_S_1));
    [points_r,points_c] = find(i_S_1);
    
    % r|c|l in slice|l in volume
    p_in_slice = zeros(length(points_r),4);
    for j=1:length(points_r)
        p_in_slice(j,1)=points_r(j);
        p_in_slice(j,2)=points_c(j);
        p_in_slice(j,3)=i_S_1(points_r(j),points_c(j));
        p_in_slice(j,4)=i_V_1(points_r(j),points_c(j));
    end
    
    
    for n = 1:n_objects_in_slice
        n_ind = find(p_in_slice(:,3)==n);
        
        %case 1 - no global label in local
        if ~any(p_in_slice(n_ind,4))
            L = max(L3D_temp(:))+1;
            p_in_slice(n_ind,4) = L;
            
            for m=1:length(n_ind)
                i_V_1(p_in_slice(n_ind(m),1),p_in_slice(n_ind(m),2)) =...
                    p_in_slice(n_ind(m),4);
                if ~i_V_2(p_in_slice(n_ind(m),1),p_in_slice(n_ind(m),2)) && ...
                        i_S_2(p_in_slice(n_ind(m),1),p_in_slice(n_ind(m),2))
                    i_V_2(p_in_slice(n_ind(m),1),p_in_slice(n_ind(m),2)) = ...
                        p_in_slice(n_ind(m),4);
                end
            end
            continue;
        end
        
        n_global_in_object = ...
            length(unique(p_in_slice(n_ind(p_in_slice(n_ind,4) > 0),4)));
        %case 2 - 1 global in local
        if n_global_in_object == 1
            L = max(p_in_slice(n_ind,4));
            p_in_slice(n_ind,4) = L;
        end
        
        %case 3 - more than 1 golbal in local
        if n_global_in_object > 1
            ind_0 = find(p_in_slice(n_ind,4)==0);% empty global
            ind_1 = find(p_in_slice(n_ind,4)~=0);% assigned golabl
            
            [IDX] = knnsearch([p_in_slice(ind_1,1),p_in_slice(ind_1,2)],...
                [p_in_slice(ind_0,1),p_in_slice(ind_0,2)]);
            
            p_in_slice(ind_0,4) = p_in_slice(ind_1(IDX),4);
        end
        
        for m=1:length(n_ind)
            i_V_1(p_in_slice(n_ind(m),1),p_in_slice(n_ind(m),2)) = ...
                p_in_slice(n_ind(m),4);
        end
        
        
        ind_l = find(p_in_slice(:,4)==-1);% ind split local
        ind_g = find(p_in_slice(:,4)==-2);% ind split global
        ind = find(p_in_slice(:,4) > 0);% assigned points
        
        if ~isempty(ind_l)
            [IDX_l] = knnsearch([p_in_slice(ind,1),p_in_slice(ind,2)],...
                [p_in_slice(ind_l,1),p_in_slice(ind_l,2)]);
            
            for m=1:length(ind_l)
                p_in_slice(ind_l(m),4) = p_in_slice(ind(IDX_l(m)),4);
                i_V_1(p_in_slice(ind_l(m),1),p_in_slice(ind_l(m),2)) = ...
                    p_in_slice(ind_l(m),4);
            end
        end
        
        if ~isempty(ind_g)
            [IDX_g] = knnsearch([p_in_slice(ind,1),p_in_slice(ind,2)],...
                [p_in_slice(ind_g,1),p_in_slice(ind_g,2)]);
            
            for m=1:length(ind_g)
                p_in_slice(ind_g(m),4) = p_in_slice(IDX_g(m),3);
                i_V_1(p_in_slice(ind_g(m),1),p_in_slice(ind_g(m),2)) = ...
                    p_in_slice(ind_g(m),4);
            end
        end
        
        for m = 1:size(p_in_slice,1)
            if ~i_V_2(p_in_slice(m,1),p_in_slice(m,2)) && ...
                    i_S_2(p_in_slice(m,1),p_in_slice(m,2))
                i_V_2(p_in_slice(m,1),p_in_slice(m,2)) = ...
                    p_in_slice(m,4);
            end
        end
    end
    
    
    %case 2a - the global is in other locals
    diff = setdiff(find(p_in_slice(:,4) == L),n_ind);
    if diff
        global2split = L;
        obj2split = unique(p_in_slice(diff,3));
        L3D_temp = ...
            split_previous('z',L3D_temp,global2split);
        
        for s = 1:length(obj2split)
            %ind_split = find(p_in_slice(diff,3)==obj2split(s));
            ind_split = p_in_slice(diff,3)==obj2split(s);
            p_in_slice(diff(ind_split),4) = max(L3D_temp(:))+1;
        end
    end
    
    switch Dim
        case 'z'
            L3D_temp(:,:,ip) = i_V_1;
            L3D_temp(:,:,ip+1) = i_V_2;
        case 'y'
            L3D_temp(:,ip,:) = i_V_1;
            L3D_temp(:,ip+1,:) = i_V_2;
        case 'x'
            L3D_temp(ip,:,:) = i_V_1;
            L3D_temp(ip+1,:,:) = i_V_2;
    end
    
    
end

end

