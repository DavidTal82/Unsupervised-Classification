function [ conn_mat ] = ...
    get_connectiviey_8HW( p_in_slice , L_max_old, L_max_new)
%UNTITLED2 Summary of this function goes here
%  Detailed explanation goes here

unique_l = unique(p_in_slice(:,3));
unique_g = unique(p_in_slice(:,4));

conn_mat = zeros(length(unique_l)*length(unique_g),3);

ind = 0;
for i = 1:length(unique_l)
    unique_g_in_l = unique(p_in_slice(p_in_slice(:,3)==(unique_l(i)),4));
    if ~max(unique_g_in_l) && (L_max_new - L_max_old) ==1 % new global
        ind = ind + 1;
        conn_mat(ind,1) = unique_l(i);
        conn_mat(ind,3) = L_max_new;
    else
        unique_g_in_l(unique_g_in_l==0) = [];
        for j = 1:length(unique_g_in_l)
            ind = ind + 1;
            conn_mat(ind,1) = unique_l(i);
            conn_mat(ind,2) = unique_g_in_l(j);
            conn_mat(ind,3) = unique_g_in_l(j);
            if j > 1
                conn_mat(ind,3) = L_max_new + 1;
                L_max_new = L_max_new + 1;
            end
        end
    end
end

conn_mat(conn_mat(:,1)==0,:) = [];


end


