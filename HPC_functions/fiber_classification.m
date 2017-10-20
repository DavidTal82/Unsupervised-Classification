function [ XYZ_label ] = fiber_classification( p, k, XYZ_label, Mdl )
%fiber_classification classify points based on nearest neighbor
%   Detailed explanation goes here

[Ind,d] = knnsearch(Mdl , p , 'k' , k);
Ind=Ind';d=d';

% labelling all unclassified points with Label+1
if ~max(XYZ_label(Ind))
    XYZ_label(Ind) = max(XYZ_label) + 1;
    return
end


% labelling the unclassified points with the nearest neighbor
% classification
if length(unique(XYZ_label(Ind)))==2;
    XYZ_label(Ind) = max(XYZ_label(Ind));
    return
end

% if there are two different nighbors classification as -1;
if k == 2;
    XYZ_label(Ind) = -1;
    return
end

[ XYZ_label ] = fiber_classification( p, k, XYZ_label, Mdl );


end

