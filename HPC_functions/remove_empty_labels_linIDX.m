function [ G_lin ] = remove_empty_labels_linIDX( G_lin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L_unique = unique(G_lin(:,2));
L_unique(~L_unique) = [];

for l = 1:length(L_unique)
    
    G_lin(G_lin(:,2)==L_unique(l),2) = l;
%     disp(num2str(l));
        
end

end

