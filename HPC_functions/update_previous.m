function [ G_out ] = ...
    update_previous( Dim, i, L_in, G_in, conn_mat)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

l_current = conn_mat(1);
g_old = conn_mat(2);
g_new = conn_mat(3);


G_out = zeros(size(G_in));
G_in_temp = G_in;
G_in_temp(G_in==g_old) = 0;
G_in(G_in~=g_old) = 0;      % removing all other global

lin_ind = find(G_in);
[x,y,z] = ind2sub(size(G_in),lin_ind);

p_max = i;
switch Dim
    case 'z'
        slice_1 = squeeze(G_in(:,:,i));
        L_in = squeeze(L_in(:,:,i));
        slice_1(L_in == l_current) = g_new;
        G_out(:,:,i) = slice_1;
        p_min = min(z);
    case 'y'
        slice_1 = squeeze(G_in(:,i,:));
        L_in = squeeze(L_in(:,i,:));
        slice_1(L_in == l_current) = g_new;
        G_out(:,i,:) = slice_1;
        p_min = min(y);
    case 'x'
        slice_1 = squeeze(G_in(i,:,:));
        L_in = squeeze(L_in(i,:,:));
        slice_1(L_in == l_current) = g_new;
        G_out(i,:,:) = slice_1;
        p_min = min(x);
end


for ip = p_max-1:-1:p_min
    
    switch Dim
        case 'z'
            in_V_1 = squeeze(G_in(:,:,ip+1));   % the old i(+1)-th 3D label
            in_V_2 = squeeze(G_in(:,:,ip));     % the old i-th 3D label
            out_V_1 = squeeze(G_out(:,:,ip+1)); % the new i-th 3D label
            out_V_2 = squeeze(G_out(:,:,ip)); % the new i-th 3D label
        case 'y'
            in_V_1 = squeeze(G_in(:,ip+1,:));   % the old i(+1)-th 3D label
            in_V_2 = squeeze(G_in(:,ip,:));     % the old i-th 3D label
            out_V_1 = squeeze(G_out(:,ip+1,:)); % the new i-th 3D label
            out_V_2 = squeeze(G_out(:,ip,:)); % the new i-th 3D label
        case 'x'
            in_V_1 = squeeze(G_in(ip+1,:,:));   % the old i(+1)-th 3D label
            in_V_2 = squeeze(G_in(ip,:,:));     % the old i-th 3D label
            out_V_1 = squeeze(G_out(ip+1,:,:)); % the new i-th 3D label
            out_V_2 = squeeze(G_out(ip,:,:)); % the new i-th 3D label
    end
    
    ind_out_1_new = find(out_V_1 == g_new);
    ind_out_1_old = find(out_V_1 == g_old);
    ind_in_old_2 = find(in_V_2==g_old);
    
    out_V_2(intersect(ind_in_old_2,ind_out_1_new)) = g_new;
    out_V_2(intersect(ind_in_old_2,ind_out_1_old)) = g_old;
    
    ind_q = setdiff(ind_in_old_2,[ind_out_1_new;ind_out_1_old]);
    
    [r,c] = ind2sub(size(out_V_1),[ind_out_1_new;ind_out_1_old]);
    [r_q,c_q] = ind2sub(size(out_V_1),ind_q);
    
    if ~isempty(r_q)
        IDX = knnsearch([r,c],[r_q,c_q]);
        
        for m = 1:length(IDX)
            out_V_2(r_q(m),c_q(m)) = out_V_2(r(IDX(m)),c(IDX(m)));
        end
    end
    
    switch Dim
        case 'z'
            G_out(:,:,ip) = out_V_2;  % the i-th -1 3D label
        case 'y'
            G_out(:,ip,:) = out_V_2;  % the i-th -1 3D label
        case 'x'
            G_out(ip,:,:) = out_V_2;  % the i-th -1 3D label
    end
    
    
end

G_out = G_out + G_in_temp;

end

