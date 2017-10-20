function [ L3D ] = ...
    label_3D_slices_x(L3D_S_x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L3D = zeros(size(L3D_S_x));
[xDim,~,~] = size(L3D_S_x);

% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y

L = 0;
for i = 1:xDim
    
    if ~max(max(L3D_S_x(i,:,:)));continue;end
    
    if ~max(L3D(:))% first layer with object
        split_local = unique(unique(L3D_S_x(i,:,:)));
        split_local(~split_local) = [];
        for s=1:length(split_local)%loop over all labels
            L = L +1;% additional global label for each local label in the first layer
            [Rx,Cx] = find (squeeze(L3D_S_x(i,:,:)) == s);
            local_label = zeros(length(Rx),1);
            for l=1:length(Rx);local_label(l) = L3D_S_x(i,Rx(l),Cx(l));end
            if length(unique(local_label))>1;disp(['Problem: Dim-',Dim,'|slice-',num2str(i)]);end
            % if ~max(L3D(:));L = 1;else L = max(L3D(:)) + 1;end
            for p = 1:length(Rx)
                if ~L3D(i,Rx(p),Cx(p)) && L3D_S_x(i,Rx(p),Cx(p)); L3D(i,Rx(p),Cx(p)) = L;end % current
                if ~L3D(i+1,Rx(p),Cx(p)) && L3D_S_x(i+1,Rx(p),Cx(p)); L3D(i+1,Rx(p),Cx(p)) = L;end % above
                if ~L3D(i,Rx(p)-1,Cx(p)) && L3D_S_x(i,Rx(p)-1,Cx(p)); L3D(i,Rx(p)-1,Cx(p)) = L;end % back
                if ~L3D(i,Rx(p)+1,Cx(p)) && L3D_S_x(i,Rx(p)+1,Cx(p)); L3D(i,Rx(p)+1,Cx(p)) = L;end % front
                if ~L3D(i,Rx(p),Cx(p)-1) && L3D_S_x(i,Rx(p),Cx(p)-1); L3D(i,Rx(p),Cx(p)-1) = L;end % right
                if ~L3D(i,Rx(p),Cx(p)+1) && L3D_S_x(i,Rx(p),Cx(p)+1); L3D(i,Rx(p),Cx(p)+1) = L;end % left
            end
        end
        
    elseif  max(L3D(:))% other layers that are not the first one
        split_local = unique(unique(L3D_S_x(i,:,:)));
        split_local(~split_local) = [];
        
        n_local = max(split_local);
        
        for s=1:n_local
            [Rx,Cx] = find (squeeze(L3D_S_x(i,:,:)) == s);
            local_label = zeros(length(Rx),1);
            global_label = zeros(length(Rx),1);
            for l=1:length(Rx);local_label(l) = L3D_S_x(i,Rx(l),Cx(l));end
            for l=1:length(Rx);global_label(l) = L3D(i,Rx(l),Cx(l));end
            
            n_global = length(unique(global_label(logical(global_label))));
            
            switch n_global
                case 0 % New global object
                    L = max(L3D(:)) + 1;
                    for p = 1:length(Rx)
                        if ~L3D(i,Rx(p),Cx(p)) && L3D_S_x(i,Rx(p),Cx(p)); L3D(i,Rx(p),Cx(p)) = L;end
                        if ~L3D(i+1,Rx(p),Cx(p)) && L3D_S_x(i+1,Rx(p),Cx(p)); L3D(i+1,Rx(p),Cx(p)) = L;end
                        if ~L3D(i,Rx(p)-1,Cx(p)) && L3D_S_x(i,Rx(p)-1,Cx(p)); L3D(i,Rx(p)-1,Cx(p)) = L;end
                        if ~L3D(i,Rx(p)+1,Cx(p)) && L3D_S_x(i,Rx(p)+1,Cx(p)); L3D(i,Rx(p)+1,Cx(p)) = L;end
                        if ~L3D(i,Rx(p),Cx(p)-1) && L3D_S_x(i,Rx(p),Cx(p)-1); L3D(i,Rx(p),Cx(p)-1) = L;end
                        if ~L3D(i,Rx(p),Cx(p)+1) && L3D_S_x(i,Rx(p),Cx(p)+1); L3D(i,Rx(p),Cx(p)+1) = L;end
                    end
                    
                case 1 % One local and one global
                    L = unique(global_label(logical(global_label)));
                    for p = 1:length(Rx)
                        if ~L3D(i,Rx(p),Cx(p)) && L3D_S_x(i,Rx(p),Cx(p)); L3D(i,Rx(p),Cx(p)) = L;end
                        if ~L3D(i+1,Rx(p),Cx(p)) && L3D_S_x(i+1,Rx(p),Cx(p)); L3D(i+1,Rx(p),Cx(p)) = L;end
                        if ~L3D(i,Rx(p)-1,Cx(p)) && L3D_S_x(i,Rx(p)-1,Cx(p)); L3D(i,Rx(p)-1,Cx(p)) = L;end
                        if ~L3D(i,Rx(p)+1,Cx(p)) && L3D_S_x(i,Rx(p)+1,Cx(p)); L3D(i,Rx(p)+1,Cx(p)) = L;end
                        if ~L3D(i,Rx(p),Cx(p)-1) && L3D_S_x(i,Rx(p),Cx(p)-1); L3D(i,Rx(p),Cx(p)-1) = L;end
                        if ~L3D(i,Rx(p),Cx(p)+1) && L3D_S_x(i,Rx(p),Cx(p)+1); L3D(i,Rx(p),Cx(p)+1) = L;end
                    end
                    
                otherwise % One local object that should be splitted to 2 or more objects
                    unigue_golbal = unique(global_label(logical(global_label)));
                    
                    for u = 1:length(unigue_golbal)
                        t = unigue_golbal(u);
                        [Rx_g,Cx_g] = find (squeeze(L3D(i,:,:)) == t);
                        L = t;
                        for p = 1:length(Rx_g)
                            if ~L3D(i+1,Rx_g(p),Cx_g(p)) && L3D_S_x(i+1,Rx_g(p),Cx_g(p)); L3D(i+1,Rx_g(p),Cx_g(p)) = L;end
                            if ~L3D(i,Rx_g(p)-1,Cx_g(p)) && L3D_S_x(i,Rx_g(p)-1,Cx_g(p)); L3D(i,Rx_g(p)-1,Cx_g(p)) = L;end
                            if ~L3D(i,Rx_g(p)+1,Cx_g(p)) && L3D_S_x(i,Rx_g(p)+1,Cx_g(p)); L3D(i,Rx_g(p)+1,Cx_g(p)) = L;end
                            if ~L3D(i,Rx_g(p),Cx_g(p)-1) && L3D_S_x(i,Rx_g(p),Cx_g(p)-1); L3D(i,Rx_g(p),Cx_g(p)-1) = L;end
                            if ~L3D(i,Rx_g(p),Cx_g(p)+1) && L3D_S_x(i,Rx_g(p),Cx_g(p)+1); L3D(i,Rx_g(p),Cx_g(p)+1) = L;end
                        end
                    end
                    
                    [Rx_g,Cx_g] = find (squeeze(L3D(i,:,:)));
                    [IDX] = knnsearch([Rx_g,Cx_g],[Rx,Cx]);
                    
                    for p=1:length(Rx)
                        if ~L3D(i,Rx(p),Cx(p))
                            L3D(i,Rx(p),Cx(p)) = L3D(i,Rx_g(IDX(p)),Cx_g(IDX(p)));
                        end
                    end                    
            end
            
        end
        
    end
    
end

end




