function [ G_lin ] = Assign_unlabeled(Labels_matrix,no_Labels_matrix,Data)
%Assign_unlabeled takes the segmented objects and assign labels to unlabeld
%points
%   Labels assignment is done based on:
%       1 - proximity, using neares neighbor
%       2 - agreement with the existing vector direction

n_CC = Data.Neighbors;
max_angle = Data.max_angle; merge_angle = max_angle/3*4;
max_dist = Data.max_dist;
max_width = Data.max_width;
min_num_voxels = Data.min_2D_area; %using the 2D area for the number of voxels

%lin index | xlabel | y label | z label | global
G_lin_yes = Labels_matrix(:,[1,5]);
G_lin_no = no_Labels_matrix(:,[1,5]);

G_lin = [G_lin_yes;G_lin_no];

I_fiber = false(Data.ImageSize);
I_fiber(G_lin_no(:,1)) = 1;

CC = bwconncomp(I_fiber,n_CC);
clear I_fiber


%% removing small objects (less than min_num_voxels voxels)
CC.PixelIdxList(cellfun(@length,CC.PixelIdxList)<min_num_voxels) = [];
CC.NumObjects = length(CC.PixelIdxList);

%% isolating problematic volumes (too wide) and sorting based on b_box ratio
%[ul_corner width]
BoundingBox = regionprops(CC,'BoundingBox');
% sorted widths and ratio
% index |max |min | min | min/max ratio 
B_box_widths = zeros(CC.NumObjects,5);

for i = 1:CC.NumObjects
    B_box_widths(i,1) = i;
    B_box_widths(i,2:4) = BoundingBox(i).BoundingBox(4:6);
end

B_box_widths(:,2:5) = sort(B_box_widths(:,2:5),2,'descend');
B_box_widths(:,5) = B_box_widths(:,4)./B_box_widths(:,2);

% removing problematic objects
[r,~] = find(B_box_widths(:,3:5) > max_width);

if ~isempty(r)
    r = unique(r);
    % B_box_widths(r,:) = [];
    CC_Problem = CC;
    for i = 1:CC.NumObjects
        if ismember(i,r)
            CC.PixelIdxList{i} = [];
        else
            CC_Problem.PixelIdxList{i} = [];
        end            
    end
    CC_Problem.PixelIdxList(cellfun('isempty',CC_Problem.PixelIdxList)) = [];
    CC_Problem.NumObjects = length(CC_Problem.PixelIdxList);
end

%% Part 1 - connecting un labeled objects to labeled

B_box_widths(cellfun('isempty',CC.PixelIdxList),:) = [];
CC.PixelIdxList(cellfun('isempty',CC.PixelIdxList)) = [];
CC.NumObjects = length(CC.PixelIdxList);
B_box_widths = sortrows(B_box_widths,5);

unique_Labels = unique(Labels_matrix(:,5));
stats_labeled = cell(length(unique_Labels),1);
stats_not_labeled = cell(CC.NumObjects,1);
angles = zeros(CC.NumObjects,length(unique_Labels));
distance = zeros(CC.NumObjects,length(unique_Labels));

%% extracting vectors from exsiting labels
for i = 1:length(unique_Labels)
    
    %image size and  lin_ind 
    [ fiber_stats ] = ...
        get_fiber_vectors(Data.ImageSize,Labels_matrix(Labels_matrix(:,5)==unique_Labels(i),1));
    
    stats_labeled{i} = fiber_stats;
    
end

%% extracting vectors from non labels (sorted according to B_box ratio
for i = 1:CC.NumObjects
    
    [ fiber_stats ] = ...
        get_fiber_vectors(Data.ImageSize,CC.PixelIdxList{i});
    
    stats_not_labeled{i} = fiber_stats;
    
    for j = 1:length(unique_Labels)
        % if i > j;continue;end
        
        V1 = stats_not_labeled{i}.Vector';
        V2 = stats_labeled{j}.Vector';
        
        angles(i,j) = atan2(norm(cross(V1,V2)),dot(V1,V2));
        
        % distance(i,j) = pdist2(stats_not_labeled{i}.Center,stats_labeled{j}.Center);
        D = pdist2(stats_not_labeled{i}.Axis,stats_labeled{j}.Axis);
        distance(i,j) = min(D(:));
        
    end
end

angles(angles > max_angle) = 0;
distance(~angles) = 0;
distance(~distance) = NaN;
[M,i_min] = min(distance,[],2);
i_min(isnan(M)) = [];

%% labeling the non problematic objects
for i = 1:length(i_min)
    Lia = ismember(G_lin(:,1),CC.PixelIdxList{i});
    G_lin(Lia,2) = unique_Labels(i_min(i));
    
    Lia = ismember(no_Labels_matrix(:,1),CC.PixelIdxList{i});
    no_Labels_matrix(Lia,5) = unique_Labels(i_min(i));
end

%% Merging objects with
% 1 - same direction
% 2 - the vector connecting their centers has the same direction.

% updating the vectors and centers - First update - before merging 
stats_labeled = cell(length(unique_Labels),1);
for i = 1:length(unique_Labels)
    [ fiber_stats ] = ...
        get_fiber_vectors(Data.ImageSize,G_lin(G_lin(:,2)==unique_Labels(i),1));    
    stats_labeled{i} = fiber_stats;
end

% pairwise angle between V1-V2, and V1-VC, V2-VC (vector connecting centers),
angles = zeros(length(unique_Labels),length(unique_Labels),3);
merging = false(length(unique_Labels));

for i = 1:length(unique_Labels)
    for j = 1:length(unique_Labels)
        
        V1 = stats_labeled{i}.Vector';
        V2 = stats_labeled{j}.Vector';
        VC1C2 = stats_labeled{j}.Center - stats_labeled{i}.Center;
        
        a1 = atan2(norm(cross(V1,V2)),dot(V1,V2));
        a2 = atan2(norm(cross(V1,VC1C2)),dot(V1,VC1C2));
        a3 = atan2(norm(cross(VC1C2,V2)),dot(VC1C2,V2));

        if a1 > pi/2 && a1 < pi; a1 = pi - a1;end
        if a2 > pi/2 && a2 < pi; a2 = pi - a2;end
        if a3 > pi/2 && a3 < pi; a3 = pi - a3;end
        
        angles(i,j,1) = a1;
        angles(i,j,2) = a2;
        angles(i,j,3) = a3;
        
        if a1<merge_angle && a2<merge_angle && a3<merge_angle && i~=j
            if j<i; continue; end
            merging(i,j) = 1;
        end     
        
        %{
        disp(['(i,j):(',num2str(i),',',num2str(j),') | angles: ',...
            num2str(rad2deg(anglesDistance(i,j,1))),', ',...
            num2str(rad2deg(anglesDistance(i,j,2))),', ',...
            num2str(rad2deg(anglesDistance(i,j,3))),' | distance',...
            num2str(rad2deg(anglesDistance(i,j,4))),', ',...
            num2str(rad2deg(anglesDistance(i,j,5)))]);
        
        
                P1_1 = stats_labeled{i}.Axis(1,:);
        P1_2 = stats_labeled{i}.Axis(2,:);
        P1_c = stats_labeled{i}.Center;

        P2_1 = stats_labeled{j}.Axis(1,:);
        P2_2 = stats_labeled{j}.Axis(2,:);
        
        d1 = point_to_line(P1_1,P2_1,P2_2);
        d2 = point_to_line(P1_2,P2_1,P2_2);
        d3 = point_to_line(P1_c,P2_1,P2_2);
%}

    end
end

[r,c] = find(merging);

if isempty(intersect(r,c))
    for i = 1:length(r)
        G_lin(G_lin(:,2)==r(i),2) = c(i);
    end
else
    disp('prolem - more than one merger');
end

%% renumbering

new_unique_Labels = unique(G_lin(:,2));
new_unique_Labels(new_unique_Labels==0) = [];

if max(new_unique_Labels) ~= length(new_unique_Labels)
    
    relabel = [new_unique_Labels,(1:length(new_unique_Labels))'];
    G_lin_temp = G_lin;
    
    for i =1:length(new_unique_Labels)
        G_lin_temp(G_lin(:,2)==relabel(i,1),2) = relabel(i,2);
    end
    G_lin = G_lin_temp;    
end

% updating the vectors and centers - second update - after merging 
stats_labeled = cell(length(relabel(:,2)),1);
for i = 1:length(relabel(:,2))
    [ fiber_stats ] = ...
        get_fiber_vectors(Data.ImageSize,G_lin(G_lin(:,2)==relabel(i,2),1));    
    stats_labeled{i} = fiber_stats;
end




%% Part 2 - Addressing the problematic objects 

if ~exist('CC_Problem','var');return;end

% Vertices = zeros(size(relabel,1),6);
% 
% for i = 1:size(Vertices,1)
%     [x,y,z] = ind2sub(Data.ImageSize,G_lin(G_lin(:,2)==relabel(i,2),1));    
%     Vertices(i,:) = [min(x),max(x),min(y),max(y),min(z),max(z)];
% end

% in_area - a logical array
% dim 1 - for each point
% dim 2 - for each exsiting label
% dim 3 - 1:x 2:y 3:z 

for i = 1:length(CC_Problem.PixelIdxList)
    
    dist = zeros(length(CC_Problem.PixelIdxList{i}),size(relabel,1));
    [x,y,z] = ind2sub(Data.ImageSize,CC_Problem.PixelIdxList{i});
    
    for k = 1:length(stats_labeled)
        
        P1 = stats_labeled{k}.Axis(1,:);
        P2 = stats_labeled{k}.Axis(2,:);
        
        for j = 1:length(x)
            Pq = [x(j),y(j),z(j)];
            dist(j,k) = point_to_line(Pq,P1,P2);
        end
        
        [~,ind_min] = min(dist,[],2);
        Lia = ismember(G_lin(:,1),CC_Problem.PixelIdxList{i});
        G_lin(Lia,2) = relabel(ind_min(:),2);
    end
end
 


end

