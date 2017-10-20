function [ new_Labels_matrix ] = rearrange_objects_8HW(Labels_matrix,Data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% clear
% load('Data.mat')
% load('Labels_matrix.mat')

new_Labels_matrix = zeros(length(Labels_matrix),2);
new_Labels_matrix(:,1) = Labels_matrix(:,1);

%lin index | xlabel | y label | z label
unique_combinations = unique(Labels_matrix(:,2:end),'rows');

%golbal | volume | xlabel | y label | z label
labeling_conn = zeros(length(unique_combinations),5);
labeling_conn(:,3:5) = unique_combinations;
labeling_conn(:,1) = (1:length(labeling_conn))' + Data.max_L;

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

objects_stats = cell(length(labeling_conn(:,1)),1);

% loop for vector, center, and pixel list
for n = 1:length(labeling_conn(:,1))
    
    Lia = ismember(Labels_matrix(:,2:end),labeling_conn(n,3:5),'rows');
    new_Labels_matrix(Lia,2) = labeling_conn(n,1);
    [x,y,z] = ind2sub(Data.ImageSize,Labels_matrix(Lia,1));
    
    [~,N,~] = ODR_3D_line_fit( [x,y,z] );
    
    objects_stats{n}.Vector = N;
    objects_stats{n}.Volume = labeling_conn(n,2);
    objects_stats{n}.Global = labeling_conn(n,1);
    objects_stats{n}.Center = [mean(x),mean(y),mean(z)];
    objects_stats{n}.PixelIdxList = Labels_matrix(Lia,1);
end

% loop for finding connections between objects
connected = zeros(length(labeling_conn(:,1)),1);
for n = 1:length(labeling_conn(:,1))
    
    if labeling_conn(n,2)<min_vol;continue;end
    if connected(n);continue;end
    connected(n) = n;
    
    for m = 1:1:length(labeling_conn(:,1))
        if m==n;continue;end
        v1 = objects_stats{n}.Vector;
        vc = objects_stats{m}.Center - objects_stats{n}.Center;
        vc = vc/norm(vc);
        angle_centers = atan2(norm(cross(v1,vc)),dot(v1,vc));
        if angle_centers >= max_angle;continue;end
        if connected(m);continue;end
        connected(m) = n;
%         disp([num2str(objects_stats{n}.Global),'-',...
%             num2str(objects_stats{m}.Global),'|angle centers:',...
%             num2str(angle_centers)]);        
    end
    
end

for n = 1:length(connected)
    new_Labels_matrix(new_Labels_matrix(:,2)==labeling_conn(n,1),2) = ...
        labeling_conn(connected(n),1);
end

% no_label = new_Labels_matrix(new_Labels_matrix(:,2)==0,1);
% yes_label = new_Labels_matrix(new_Labels_matrix(:,2)~=0,1);
no_label = find(new_Labels_matrix(:,2)==0);
yes_label = find(new_Labels_matrix(:,2)~=0);

[x_yes,y_yes,z_yes] = ind2sub(Data.ImageSize,new_Labels_matrix(yes_label,1));
[x_no,y_no,z_no] = ind2sub(Data.ImageSize,new_Labels_matrix(no_label,1));

IDX = knnsearch([x_yes,y_yes,z_yes],[x_no,y_no,z_no]);
new_Labels_matrix(no_label,2) = new_Labels_matrix(yes_label(IDX),2);

%{
L3D = zeros(Data.ImageSize);
L3D(new_Labels_matrix(:,1)) = new_Labels_matrix(:,2);
volume_visualization_segments_vectors(L3D)
%}



end

