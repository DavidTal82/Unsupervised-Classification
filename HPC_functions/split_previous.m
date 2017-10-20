function [ L3D_out ] = ...
    split_previous( Dim, L3D_in, L)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

L3D_temp = zeros(size(L3D_in));
L3D_temp(L3D_in==L) = -1;
L_max = max(L3D_in(:));

lin_ind = find(L3D_temp);
[x,y,z] = ind2sub(size(L3D_temp),lin_ind);

switch Dim
    case 'z'
        p_min = min(z);
        p_max = max(z);
    case 'y'
        p_min = min(y);
        p_max = max(y);
    case 'x'
        p_min = min(x);
        p_max = max(x);
end

for ip = p_max:-1:p_min
    
    switch Dim
        case 'z'
            i_V_1 = squeeze(L3D_temp(:,:,ip));      % the i-th 3D label
            i_V_2 = squeeze(L3D_temp(:,:,ip-1));    % the i-th -1 3D label
        case 'y'
            i_V_1 = squeeze(L3D_temp(:,ip,:));
            i_V_2 = squeeze(L3D_temp(:,ip-1,:));
        case 'x'
            i_V_1 = squeeze(L3D_temp(ip,:,:));
            i_V_2 = squeeze(L3D_temp(ip-1,:,:));
    end
    
    [i_L_1,num_1] = bwlabeln(i_V_1);
    %[i_L_2,num_2] = bwlabeln(i_V_2);
    
    if ip == p_max
        i_V_1(i_L_1==1) = L;
        for u = 2:num_1
            i_V_1(i_L_1==u) = L_max+1;
            L_max = L_max+1;
        end
    end
    
    [r_1,c_1] = find(i_V_1);
    [r_2,c_2] = find(i_V_2 == -1);
    
    r_c = intersect([r_1,c_1],[r_2,c_2],'rows');
    for m=1:length(r_c)
        i_V_2(r_c(m,1),r_c(m,2))=i_V_1(r_c(m,1),r_c(m,2));
    end
    
    
    [r_non,c_non] = find(i_V_2 == -1);
    
    if ~isempty(r_non)
        [r_2,c_2] = find(i_V_2 > 0);
        [IDX] = knnsearch([r_2,c_2],[r_non,c_non]);
        for m=1:length(IDX)
            i_V_2(r_non(m),c_non(m))=i_V_2(r_2(IDX(m)),c_2(IDX(m)));
        end
    end
    
    
    switch Dim
        case 'z'
            L3D_temp(:,:,ip) = i_V_1;      % the i-th 3D label
            L3D_temp(:,:,ip-1) = i_V_2;    % the i-th -1 3D label
        case 'y'
            L3D_temp(:,ip,:) = i_V_1;
            L3D_temp(:,ip-1,:) = i_V_2;
        case 'x'
            L3D_temp(ip,:,:) = i_V_1;
            L3D_temp(ip-1,:,:) = i_V_2;
    end
    
    if min(i_V_2(:))<0
        disp('bug');
    end
    
end

if min(L3D_temp(:))<0
    disp('bug');
end

L3D_out = L3D_in;
L3D_out(L3D_in==L) = L3D_temp(L3D_in==L);
end

