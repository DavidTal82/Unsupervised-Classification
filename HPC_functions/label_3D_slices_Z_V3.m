function [ L3D ] = ...
    label_3D_slices_Z_V3(L3D_S_z)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L3D = zeros(size(L3D_S_z));
[~,~,zDim] = size(L3D_S_z);

% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y

for i = 1:zDim
    
    if ~max(max(L3D_S_z(:,:,i)));continue;end
    
    split_local = unique(unique(L3D_S_z(:,:,i)));
    split_local(~split_local) = [];
    
    n_local = max(split_local);
    
    for s=1:n_local %breaking each local object based on global segmentation
        [Rz,Cz] = find (squeeze(L3D_S_z(:,:,i)) == s);
        local_label = zeros(length(Rz),1);
        global_label = zeros(length(Rz),1);
        for l=1:length(Rz);local_label(l) = L3D_S_z(Rz(l),Cz(l),i);end
        for l=1:length(Rz);global_label(l) = L3D(Rz(l),Cz(l),i);end
        
        n_global_in_local = length(unique(global_label(logical(global_label))));
        
        switch n_global_in_local
            case 0 % New global object
                L = max(L3D(:)) + 1;
                for p = 1:length(Rz)
                    if ~L3D(Rz(p),Cz(p),i) && L3D_S_z(Rz(p),Cz(p),i); L3D(Rz(p),Cz(p),i) = L;end
                    if ~L3D(Rz(p),Cz(p),i+1) && L3D_S_z(Rz(p),Cz(p),i+1); L3D(Rz(p),Cz(p),i+1) = L;end
                    if ~L3D(Rz(p)-1,Cz(p),i) && L3D_S_z(Rz(p)-1,Cz(p),i); L3D(Rz(p)-1,Cz(p),i) = L;end
                    if ~L3D(Rz(p)+1,Cz(p),i) && L3D_S_z(Rz(p)+1,Cz(p),i); L3D(Rz(p)+1,Cz(p),i) = L;end
                    if ~L3D(Rz(p),Cz(p)-1,i) && L3D_S_z(Rz(p),Cz(p)-1,i); L3D(Rz(p),Cz(p)-1,i) = L;end
                    if ~L3D(Rz(p),Cz(p)+1,i) && L3D_S_z(Rz(p),Cz(p)+1,i); L3D(Rz(p),Cz(p)+1,i) = L;end
                end
            case 1 % One local and one global
                L = unique(global_label(logical(global_label)));
                for p = 1:length(Rz)
                    if ~L3D(Rz(p),Cz(p),i) && L3D_S_z(Rz(p),Cz(p),i); L3D(Rz(p),Cz(p),i) = L;end
                    if ~L3D(Rz(p),Cz(p),i+1) && L3D_S_z(Rz(p),Cz(p),i+1); L3D(Rz(p),Cz(p),i+1) = L;end
                    if ~L3D(Rz(p)-1,Cz(p),i) && L3D_S_z(Rz(p)-1,Cz(p),i); L3D(Rz(p)-1,Cz(p),i) = L;end
                    if ~L3D(Rz(p)+1,Cz(p),i) && L3D_S_z(Rz(p)+1,Cz(p),i); L3D(Rz(p)+1,Cz(p),i) = L;end
                    if ~L3D(Rz(p),Cz(p)-1,i) && L3D_S_z(Rz(p),Cz(p)-1,i); L3D(Rz(p),Cz(p)-1,i) = L;end
                    if ~L3D(Rz(p),Cz(p)+1,i) && L3D_S_z(Rz(p),Cz(p)+1,i); L3D(Rz(p),Cz(p)+1,i) = L;end
                end
            otherwise % One local object that should be splitted to 2 or more objects
                unigue_golbal = unique(global_label(logical(global_label)));
                for u = 1:length(unigue_golbal)
                    t = unigue_golbal(u);
                    [Rz_g,Cz_g] = find (squeeze(L3D(:,:,i)) == t);
                    L = t;
                    for p = 1:length(Rz_g)
                        if ~L3D(Rz_g(p),Cz_g(p),i+1) && L3D_S_z(Rz_g(p),Cz_g(p),i+1); L3D(Rz_g(p),Cz_g(p),i+1) = L;end
                        if ~L3D(Rz_g(p)-1,Cz_g(p),i) && L3D_S_z(Rz_g(p)-1,Cz_g(p),i); L3D(Rz_g(p)-1,Cz_g(p),i) = L;end
                        if ~L3D(Rz_g(p)+1,Cz_g(p),i) && L3D_S_z(Rz_g(p)+1,Cz_g(p),i); L3D(Rz_g(p)+1,Cz_g(p),i) = L;end
                        if ~L3D(Rz_g(p),Cz_g(p)-1,i) && L3D_S_z(Rz_g(p),Cz_g(p)-1,i); L3D(Rz_g(p),Cz_g(p)-1,i) = L;end
                        if ~L3D(Rz_g(p),Cz_g(p)+1,i) && L3D_S_z(Rz_g(p),Cz_g(p)+1,i); L3D(Rz_g(p),Cz_g(p)+1,i) = L;end
                    end
                end
                
                [Rz_g,Cz_g] = find (squeeze(L3D(:,:,i)));
                [IDX] = knnsearch([Rz_g,Cz_g],[Rz,Cz]);
                
                for p=1:length(Rz)
                    if ~L3D(Rz(p),Cz(p),i)
                        L3D(Rz(p),Cz(p),i) = L3D(Rz_g(IDX(p)),Cz_g(IDX(p)),i);
                    end
                end
        end
        
        % number of global labels in the i-th slice
        slice_global = squeeze(L3D(:,:,i));
        n_global = length(unique(slice_global(logical(slice_global(:)))));
        
        
    end
    
    if n_local > n_global
        
        %         plot_slice_local_global(L3D(:,:,i-1),L3D_S_z(:,:,i-1),i-1);
        %         plot_slice_local_global(L3D(:,:,i),L3D_S_z(:,:,i),i);
        %         plot_slice_local_global(L3D(:,:,i+1),L3D_S_z(:,:,i+1),i+1);
        
        disp([num2str(i),': local-',num2str(n_local),'|global-',num2str(n_global)]);
        split_index = zeros(n_local,3);
        
        for q = 1:n_local
            % local label | global | new global
            split_index(q,1) = q;
            [R,C] = find(squeeze(L3D_S_z(:,:,i)) == q);
            global_temp = zeros(length(R),1);
            for l=1:length(R);global_temp(l) = L3D(R(l),C(l),i);end
            split_index(q,2) = mode(global_temp);
        end
        
        v = split_index(:,2);
        sv = sort(v);
        id = sv(2:end) == sv(1:end-1);
        % copy the labels that should not be splitted
        split_index(~ismember(v,sv(id)),3) =  split_index(~ismember(v,sv(id)),2);
        common = ismember(v,sv(id));% returns the different objects with the same global label
        
        % find the first splitable label
        k = find(common,1);
        for m = 1:length(common)
            if ~common(m);continue;end
            switch m
                case k
                    % give the first splitable the exisiting label
                    split_index(m,3) = split_index(m,2);
                otherwise
                    % give the others nwe labels
                    L = max(L3D(:)) + 1;
                    split_index(m,3) = L;
            end
        end
        
        % clean global labels in i+1
        L3D(:,:,i+1) = 0;
        
        % isolate the splittable and
        global_to_split = unique(split_index(common,2),'stable');
        
        
        for ui_g = 1:length(global_to_split)
            gL_old = global_to_split(ui_g);
            split_temp = split_index(split_index(:,2)==gL_old,:);
            %fixing the current level:
            for ui_l = 1:size(split_temp,1)
                lL_current = split_temp(ui_l,1);
                [Rz_l,Cz_l] = find (squeeze(L3D_S_z(:,:,i))==lL_current);
                for l=1:length(Rz_l);L3D(Rz_l(l),Cz_l(l),i) = split_temp(ui_l,3);end
            end
            
            % fixing lower levels
            [~,~,z] = ind2sub(size(L3D),find(L3D(:,:,1:i-1)==gL_old));
            z = unique(z);
            
            for iz = max(z):-1:min(z)
                [Rz_g_old,Cz_g_old] = find (squeeze(L3D(:,:,iz))==gL_old);
                for l=1:length(Rz_g_old)
                    if L3D(Rz_g_old(l),Cz_g_old(l),iz+1)
                        L3D(Rz_g_old(l),Cz_g_old(l),iz) = L3D(Rz_g_old(l),Cz_g_old(l),iz+1);
                        Rz_g_old(l) = 0;Cz_g_old(l) = 0;
                    else
                        L3D(Rz_g_old(l),Cz_g_old(l),iz) = 0;
                    end
                end
                
                % undecided points
                Rz_q = Rz_g_old(logical(Rz_g_old));Cz_q = Cz_g_old(logical(Cz_g_old));
                
                [Rz_s,Cz_s] = find(squeeze(L3D(:,:,i)));%sample points
                [IDX] = knnsearch([Rz_s,Cz_s],[Rz_q,Cz_q]);
                
                for p=1:length(Rz_q)
                    if ~L3D(Rz_q(p),Cz_q(p),iz)
                        L3D(Rz_q(p),Cz_q(p),iz) = L3D(Rz_s(IDX(p)),Cz_s(IDX(p)),iz);
                    end
                end
            end            
        end
        [Rz_g_new,Cz_g_new] = find (squeeze(L3D(:,:,i)));
        
        for p = 1:length(Rz_g_new)
            if L3D(Rz_g_new(p),Cz_g_new(p),i) && L3D_S_z(Rz_g_new(p),Cz_g_new(p),i+1)
                L3D(Rz_g_new(p),Cz_g_new(p),i+1) = L3D(Rz_g_new(p),Cz_g_new(p),i);
            end
        end
        
    end
end

end