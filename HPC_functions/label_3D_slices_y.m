function [ L3D ] = ...
    label_3D_slices_y(L3D_S_y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L3D = zeros(size(L3D_S_y));
[~,yDim,~] = size(L3D_S_y);

% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y

L = 0;
for i = 1:yDim
    
    if ~max(max(L3D_S_y(:,i,:)));continue;end
    
    if ~max(L3D(:))% first layer with object
        split_local = unique(unique(L3D_S_y(:,i,:)));
        split_local(~split_local) = [];
        for s=1:length(split_local)%loop over all labels
            L = L +1;% additional global label for each local label in the first layer
            [Ry,Cy] = find (squeeze(L3D_S_y(:,i,:)) == s);
            local_label = zeros(length(Ry),1);
            for l=1:length(Ry);local_label(l) = L3D_S_y(Ry(l),i,Cy(l));end
            if length(unique(local_label))>1;disp(['Problem: Dim-',Dim,'|slice-',num2str(i)]);end
            % if ~max(L3D(:));L = 1;else L = max(L3D(:)) + 1;end
            for p = 1:length(Ry)
                if ~L3D(Ry(p),i,Cy(p)) && L3D_S_y(Ry(p),i,Cy(p)); L3D(Ry(p),i,Cy(p)) = L;end % current
                if ~L3D(Ry(p),i+1,Cy(p)) && L3D_S_y(Ry(p),i+1,Cy(p)); L3D(Ry(p),i+1,Cy(p)) = L;end % above
                if ~L3D(Ry(p)-1,i,Cy(p)) && L3D_S_y(Ry(p)-1,i,Cy(p)); L3D(Ry(p)-1,i,Cy(p)) = L;end % back
                if ~L3D(Ry(p)+1,i,Cy(p)) && L3D_S_y(Ry(p)+1,i,Cy(p)); L3D(Ry(p)+1,i,Cy(p)) = L;end % front
                if ~L3D(Ry(p),i,Cy(p)-1) && L3D_S_y(Ry(p),i,Cy(p)-1); L3D(Ry(p),i,Cy(p)-1) = L;end % right
                if ~L3D(Ry(p),i,Cy(p)+1) && L3D_S_y(Ry(p),i,Cy(p)+1); L3D(Ry(p),i,Cy(p)+1) = L;end % left
            end
        end
        
    elseif  max(L3D(:))% other layers that are not the first one
        split_local = unique(unique(L3D_S_y(:,i,:)));
        split_local(~split_local) = [];
        
        n_local = max(split_local);
        
        for s=1:n_local
            [Ry,Cy] = find (squeeze(L3D_S_y(:,i,:)) == s);
            local_label = zeros(length(Ry),1);
            global_label = zeros(length(Ry),1);
            for l=1:length(Ry);local_label(l) = L3D_S_y(Ry(l),i,Cy(l));end
            for l=1:length(Ry);global_label(l) = L3D(Ry(l),i,Cy(l));end
            
            n_global = length(unique(global_label(logical(global_label))));
            
            switch n_global
                case 0 % New global object
                    L = max(L3D(:)) + 1;
                    for p = 1:length(Ry)
                        if ~L3D(Ry(p),i,Cy(p)) && L3D_S_y(Ry(p),i,Cy(p)); L3D(Ry(p),i,Cy(p)) = L;end
                        if ~L3D(Ry(p),i+1,Cy(p)) && L3D_S_y(Ry(p),i+1,Cy(p)); L3D(Ry(p),i+1,Cy(p)) = L;end
                        if ~L3D(Ry(p)-1,i,Cy(p)) && L3D_S_y(Ry(p)-1,i,Cy(p)); L3D(Ry(p)-1,i,Cy(p)) = L;end
                        if ~L3D(Ry(p)+1,i,Cy(p)) && L3D_S_y(Ry(p)+1,i,Cy(p)); L3D(Ry(p)+1,i,Cy(p)) = L;end
                        if ~L3D(Ry(p),i,Cy(p)-1) && L3D_S_y(Ry(p),i,Cy(p)-1); L3D(Ry(p),i,Cy(p)-1) = L;end
                        if ~L3D(Ry(p),i,Cy(p)+1) && L3D_S_y(Ry(p),i,Cy(p)+1); L3D(Ry(p),i,Cy(p)+1) = L;end
                    end
                    
                case 1 % One local and one global
                    L = unique(global_label(logical(global_label)));
                    for p = 1:length(Ry)
                        if ~L3D(Ry(p),i,Cy(p)) && L3D_S_y(Ry(p),i,Cy(p)); L3D(Ry(p),i,Cy(p)) = L;end
                        if ~L3D(Ry(p),i+1,Cy(p)) && L3D_S_y(Ry(p),i+1,Cy(p)); L3D(Ry(p),i+1,Cy(p)) = L;end
                        if ~L3D(Ry(p)-1,i,Cy(p)) && L3D_S_y(Ry(p)-1,i,Cy(p)); L3D(Ry(p)-1,i,Cy(p)) = L;end
                        if ~L3D(Ry(p)+1,i,Cy(p)) && L3D_S_y(Ry(p)+1,i,Cy(p)); L3D(Ry(p)+1,i,Cy(p)) = L;end
                        if ~L3D(Ry(p),i,Cy(p)-1) && L3D_S_y(Ry(p),i,Cy(p)-1); L3D(Ry(p),i,Cy(p)-1) = L;end
                        if ~L3D(Ry(p),i,Cy(p)+1) && L3D_S_y(Ry(p),i,Cy(p)+1); L3D(Ry(p),i,Cy(p)+1) = L;end
                    end
                    
                otherwise % One local object that should be splitted to 2 or more objects
                    unigue_golbal = unique(global_label(logical(global_label)));
                    
                    for u = 1:length(unigue_golbal)
                        t = unigue_golbal(u);
                        [Ry_g,Cy_g] = find (squeeze(L3D(:,i,:)) == t);
                        L = t;
                        for p = 1:length(Ry_g)
                            if ~L3D(Ry_g(p),i+1,Cy_g(p)) && L3D_S_y(Ry_g(p),i+1,Cy_g(p)); L3D(Ry_g(p),i+1,Cy_g(p)) = L;end
                            if ~L3D(Ry_g(p)-1,i,Cy_g(p)) && L3D_S_y(Ry_g(p)-1,i,Cy_g(p)); L3D(Ry_g(p)-1,i,Cy_g(p)) = L;end
                            if ~L3D(Ry_g(p)+1,i,Cy_g(p)) && L3D_S_y(Ry_g(p)+1,i,Cy_g(p)); L3D(Ry_g(p)+1,i,Cy_g(p)) = L;end
                            if ~L3D(Ry_g(p),i,Cy_g(p)-1) && L3D_S_y(Ry_g(p),i,Cy_g(p)-1); L3D(Ry_g(p),i,Cy_g(p)-1) = L;end
                            if ~L3D(Ry_g(p),i,Cy_g(p)+1) && L3D_S_y(Ry_g(p),i,Cy_g(p)+1); L3D(Ry_g(p),i,Cy_g(p)+1) = L;end
                        end
                    end
                    
                    [Ry_g,Cy_g] = find (squeeze(L3D(:,i,:)));
                    [IDX] = knnsearch([Ry_g,Cy_g],[Ry,Cy]);
                    
                    for p=1:length(Ry)
                        if ~L3D(Ry(p),i,Cy(p))
                            L3D(Ry(p),i,Cy(p)) = L3D(Ry_g(IDX(p)),i,Cy_g(IDX(p)));
                        end
                    end                    
            end
            
        end
        
    end
    
end

end




