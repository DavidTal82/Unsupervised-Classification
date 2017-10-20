function [ points_out ] = fix_labels_connectivity(points_in,labels2fix)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

problem =  find(~(labels2fix(:,2)==labels2fix(:,3)));

points_out = points_in;

for l = 1:length(problem)
    
    ind_local = find(points_out(:,3)==labels2fix(problem(l),1));
    ind_global = find(points_out(:,4)==labels2fix(problem(l),2));
    
    ind2fix = intersect(ind_local,ind_global);
    
    points_out(ind2fix,4) = labels2fix(problem(l),3);
    
 
end

end

