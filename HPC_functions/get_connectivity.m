function [ labeling_conn , Labels_matrix] = get_connectivity(Labels_matrix,Data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% clear
% load('Data.mat')
% load('Labels_matrix.mat')

min_vol = Data.min_volume_rearrange;
w_l_ratio = Data.w_l_ratio;
%lin index | xlabel | y label | z label
unique_combinations = unique(Labels_matrix(:,2:4),'rows');
unique_combinations(~all(unique_combinations,2),:) = [];

%golbal | volume | xlabel | y label | z label | c/a ratio
% approximating to an ellipsoid and finding the c/a ratio
labeling_conn = zeros(size(unique_combinations,1),6);
labeling_conn(:,3:5) = unique_combinations;

% loop for volume and new labeling matrix
for n = 1:length(labeling_conn(:,4))
    Lia = ismember(Labels_matrix(:,2:4),labeling_conn(n,3:5),'rows');
    % treats each row of A and each row of B as single entities and returns
    % a column vector containing logical 1 (true) where the rows of A are
    % also rows of B. Elsewhere, the array contains logical 0 (false).
    
    % Volume
    labeling_conn(n,2) = length(Labels_matrix(Lia,1));
    
    % c/a ratio
    if labeling_conn(n,2) <= min_vol;continue;end
    [x,y,z] = ind2sub(Data.ImageSize,Labels_matrix(Lia,1));
    elli = inertiaEllipsoid([x,y,z]);
    labeling_conn(n,6) = elli(6)/elli(4);
    
end

%golbal | volume | xlabel | y label | z label
labeling_conn(labeling_conn(:,2) <= min_vol,:) = [];
labeling_conn = sortrows(labeling_conn,2,'descend');
labeling_conn(labeling_conn(:,6) >= w_l_ratio,:) = [];

labeling_conn(:,1) = (1:size(labeling_conn,1))' + Data.max_L;


% Lia_matrix = ismember(Labels_matrix(:,2:4),labeling_conn(:,3:5),'rows');
% 
% Labels_matrix = Labels_matrix(Lia_matrix,:);

end

