function [ L3D_out ] = remove_empty_labels( L3D_in )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L_unique = unique(L3D_in);
L_unique(~L_unique) = [];

for l = 1:length(L_unique)
    
    L3D_in(L3D_in==L_unique(l)) = l;
%     disp(num2str(l));
        
end

L3D_out = L3D_in;


end

