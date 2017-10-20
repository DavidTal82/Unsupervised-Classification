function [ labeling_conn_out ] = labels_renumbering( labeling_conn )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L_unique = unique(labeling_conn(:,1));
labeling_conn_out = labeling_conn;

for l = 1:length(L_unique)
    
    labeling_conn_out(labeling_conn_out(:,1)==L_unique(l),1) = l;
        
end

end

