function [ conn_mat , split_flag ] = get_connectiviey( p_in_slice , L_max)
%UNTITLED2 Summary of this function goes here
%  Detailed explanation goes here

split_flag = 0;

% unique_l = unique(p_in_slice(:,3));
% unique_g = unique(p_in_slice(:,4));

% conn_mat = zeros(length(unique_l)*length(unique_g),3);


% ind = 0;
% for i = 1:length(unique_l)
%     unique_g_in_l = unique(p_in_slice(p_in_slice(:,3)==(unique_l(i)),4));
%     if ~max(unique_g_in_l) % new global
%         ind = ind + 1;
%         conn_mat(ind,1) = unique_l(i);
%         conn_mat(ind,3) = L_max + 1;
%         L_max = L_max + 1;
%     else
%         unique_g_in_l(unique_g_in_l==0) = [];
%         for j = 1:length(unique_g_in_l)
%             ind = ind + 1;
%             conn_mat(ind,1) = unique_l(i);
%             conn_mat(ind,2) = unique_g_in_l(j);
%             conn_mat(ind,3) = unique_g_in_l(j);
%             if j > 1
%                 conn_mat(ind,3) = L_max + 1;
%                 L_max = L_max + 1;
%             end
%         end
%     end
% end
% 
% 
% 
% conn_mat(conn_mat(:,1)==0,:) = [];

unique_combinations = unique(p_in_slice(:,3:4),'rows');
conn_mat_new = [unique_combinations,unique_combinations(:,2)];
conn_mat = conn_mat_new;
% tf = isequal(conn_mat,conn_mat_new);
% 
% if ~tf
%     disp(['conn dont match']);
% end


for k=2:length(conn_mat(:,1))
    
    if ismember(conn_mat(k,3),conn_mat(1:k-1,3))
        conn_mat(k,3) = L_max + 1;
        L_max = L_max + 1;
        split_flag = 1;
    end
end



end


