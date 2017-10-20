function [ L3D ] = ...
    label_3D_slices( xyz, L3D_S_z , L3D_S_y , L3D_S_x , Dim)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L3D = zeros(size(L3D_S_z));
[xDim,yDim,zDim] = size(L3D_S_z);

%         [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z
%         [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
%         [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y

L = 0;
switch Dim
    case 'z'
        for i = 1:zDim
            
            if L > 85 && L <95
                disp(num2str(i));
            end
            
            if i > 175 && i <200
                disp(num2str(i));
            end            
            
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
            end
            
%             slice_global = squeeze(L3D(:,:,i));
%             n_global = length(unique(slice_global(logical(slice_global(:)))));
%             
%             if n_local > n_global
% 
%                 disp([num2str(i),': local-',num2str(n_local),...
%                     '|global-',num2str(n_global)]);
%                 
%                 split_global = zeros(n_local,3);
%                 
%                 for q = 1:n_local
%                     % local label | global | new global
%                     split_global(q,1) = q;
%                     [R,C] = find(squeeze(L3D_S_z(:,:,i)) == q);
%                     
%                     global_temp = zeros(length(R),1);
%                     for l=1:length(R);global_temp(l) = L3D(R(l),C(l),i);end
%                     split_global(q,2) = mode(global_temp);                  
%                 end
%                 
%                 v = split_global(:,2);
%                 sv = sort(v);
%                 id = sv(2:end) == sv(1:end-1);
%                 split_global(~ismember(v,sv(id)),3) =  split_global(~ismember(v,sv(id)),2); 
%                 result = v(ismember(v,sv(id)));
%                 
%                 for m = 1:length(result)
%                     if m==1;split_global(result(m),3) = split_global(result(m),2);continue;end
%                     L = max(L3D(:)) + 1;
%                     split_global(result(m),3) = L;
%                     
%                     [R,C] = find(squeeze(L3D_S_z(:,:,i)) == split_global(result(m),2));
%                     for l=1:length(R);L3D(R(l),C(l),i) = split_global(result(m),3);end
%                 end
%                 
%                 for ii = i:-1:1
%                     % go backward to fix previous layers
%                 end

  %          end
        
            
        end
        
end







end




