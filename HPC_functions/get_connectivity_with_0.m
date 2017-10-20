function [ G_lin] = get_connectivity_with_0(Labels_matrix,Data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% clear
% load('Data.mat')
% load('Labels_matrix.mat')

min_vol = Data.min_volume_rearrange;
w_l_ratio = Data.w_l_ratio;

G_lin = Labels_matrix(:,[1,5]);

%lin index | xlabel | y label | z label
unique_combinations = unique(Labels_matrix(:,2:4),'rows');
% unique_combinations(~all(unique_combinations,2),:) = [];

% golbal | xlabel | y label | z label 
% approximating to an ellipsoid and finding the c/a ratio
labeling_conn = zeros(size(unique_combinations,1),4);
labeling_conn(:,1) = (1:size(unique_combinations,1))';
labeling_conn(:,2:4) = unique_combinations;

% loop for volume and new labeling matrix
for n = 1:size(labeling_conn(:,4),1)
    Lia = ismember(Labels_matrix(:,2:4),labeling_conn(n,2:4),'rows');
    % treats each row of A and each row of B as single entities and returns
    % a column vector containing logical 1 (true) where the rows of A are
    % also rows of B. Elsewhere, the array contains logical 0 (false).
    G_lin(Lia,2) = n;
end

end

