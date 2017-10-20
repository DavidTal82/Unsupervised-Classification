function [ labeling_conn ] = rearrange_objects(Labels_matrix,Data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% clear
% load('Data.mat')
% load('Labels_matrix.mat')

min_vol = Data.min_volume_rearrange;


%lin index | xlabel | y label | z label
unique_combinations = unique(Labels_matrix(:,2:end),'rows');
unique_combinations(~all(unique_combinations,2),:) = [];

%golbal | volume | xlabel | y label | z label
labeling_conn = zeros(size(unique_combinations,1),5);
labeling_conn(:,3:5) = unique_combinations;

% loop for volume and new labeling matrix
for n = 1:length(labeling_conn(:,4))
    Lia = ismember(Labels_matrix(:,2:end),labeling_conn(n,3:5),'rows');
    % treats each row of A and each row of B as single entities and returns
    % a column vector containing logical 1 (true) where the rows of A are
    % also rows of B. Elsewhere, the array contains logical 0 (false).
    labeling_conn(n,2) = length(Labels_matrix(Lia,1));
end

%golbal | volume | xlabel | y label | z label
labeling_conn(labeling_conn(:,2)<=min_vol,:) = [];
labeling_conn = sortrows(labeling_conn,2,'descend');

labeling_conn(:,1) = (1:size(labeling_conn,1))' + Data.max_L;

end

