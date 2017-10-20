function [ labeling_conn , Labels_matrix ] = rearrange_objects_vectors(labeling_conn,Labels_matrix,Data)
%rearrange_objects_vectors - combine segemnted fibers into a single fiber
%   input - labeling connectivity and labels matrix - containing splitted
%           fibers
%   output - labeling connectivity and labels matrix of combined fibers,
%           with ascending labels


% min_vol = Data.min_volume_rearrange;
max_angle = Data.max_angle;
max_dist = Data.max_dist;

% Labels_matrix: lin index | xlabel | y label | z label | global

objects_stats = cell(length(labeling_conn(:,1)),1);
centers_vectors = zeros(length(labeling_conn(:,1)),6);

% loop for vector, center, and pixel list
for n = 1:length(labeling_conn(:,1))
    
    Lia = ismember(Labels_matrix(:,2:4),labeling_conn(n,3:5),'rows');
    
    [x,y,z] = ind2sub(Data.ImageSize,Labels_matrix(Lia,1));
    
    [N,P_start,P_end] = ODR_3D_line_fit( [x,y,z] );
    
    objects_stats{n}.Vector = N;
    objects_stats{n}.Axis = [P_start;P_end];
    objects_stats{n}.Volume = labeling_conn(n,2);
    objects_stats{n}.Global = labeling_conn(n,1);
    objects_stats{n}.Center = [mean(x),mean(y),mean(z)];
    objects_stats{n}.PixelIdxList = Labels_matrix(Lia,1);
    
    centers_vectors(n,1:3) = [mean(x),mean(y),mean(z)];
    centers_vectors(n,4:6) = N;
    
end

% step 1 - finding pairwise angles
angles = zeros(length(labeling_conn(:,1)));

for n = 1:length(labeling_conn(:,1))
    for m = 1:length(labeling_conn(:,1))
        if m>=n;continue;end
        V1 = objects_stats{n}.Vector;
        V2 = objects_stats{m}.Vector;
        angles(n,m) = atan2(norm(cross(V1,V2)),dot(V1,V2));
    end
end

angles(angles > max_angle) = 0;
[r,c] =  find(angles);

% step 2 - checking the distance of the edge points of objects with a
% similar direction vector
connected = zeros(length(r),3);
connected_debuging = zeros(length(r),4);

for n = 1:length(r)
    
    D = pdist2(objects_stats{r(n)}.Axis,objects_stats{c(n)}.Axis);
    [i,j] = find(D <= max_dist);
    
    connected_debuging(n,1) = r(n);
    connected_debuging(n,2) = c(n);
    connected_debuging(n,4) = min(D(:));
    
    if isempty(i) || isempty(j);continue;end
    
    % finding the vector connecting the centers
    V1 = objects_stats{r(n)}.Vector;
    V2 = objects_stats{c(n)}.Vector;
    V_C = objects_stats{r(n)}.Center - objects_stats{c(n)}.Center;
    angle_V1VC = atan2(norm(cross(V1,V_C)),dot(V1,V_C));
    angle_V2VC = atan2(norm(cross(V2,V_C)),dot(V2,V_C));
    
    % angle between vectors and between centers is less than max_angle
    %     if max(angle_V1VC,angle_V2VC) >= max_angle
    %         if pi() - max(angle_V1VC,angle_V2VC) >= max_angle
    %         continue;
    %         end
    %     end
    
    connected(n,1) = r(n);
    connected(n,2) = c(n);
end

connected(connected(:,1)==0,:) = [];


for n = 1:size(connected,1)
    
    if n == 1
        connected(n,3) = min(connected(n,1:2));
        continue;
    end
    
    [r,~]=find(ismember(connected(1:n-1,1:2),connected(n,1:2)),1);

    if isempty(r)
        connected(n,3) = min(connected(n,1:2));
    else
        connected(n,3) = connected(r,3);
    end
end

for n = 1:size(connected,1)
    if connected(n,1)~=connected(n,3)
        labeling_conn(labeling_conn(:,1)==connected(n,1),1) = connected(n,3);
    end
    if connected(n,2)~=connected(n,3)
        labeling_conn(labeling_conn(:,1)==connected(n,2),1) = connected(n,3);
    end
end

labeling_conn = labels_renumbering( labeling_conn );

% relabeling connected objects
for n = 1:size(labeling_conn,1)
    Lia = ismember(Labels_matrix(:,2:4),labeling_conn(n,3:5),'rows');
    Labels_matrix(Lia,5) = labeling_conn(n,1);
end

end

