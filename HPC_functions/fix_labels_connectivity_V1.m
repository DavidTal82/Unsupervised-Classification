function [ points_out ] = fix_labels_connectivity(points_in,labels2fix , I )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

problem =  find(labels2fix(:,2)>1);

for l = 1:length(problem)
    
    [L_all,~] = bwlabeln(I);
    [L, NUM] = bwlabeln(I==labels2fix(problem(l),1));
    
    Area = zeros(NUM,2);
    
    for a =1:NUM
        Area(a,1) = a;
        Area(a,2) = length(find(L==a));
    end
    
    Area = sortrows(Area,2,'descend');
    
    for i = 2:length(Area)
        new_label = mode(I(L_all == mode(L_all(L==Area(i,1)))));
        I(L==Area(i,1)) = new_label;        
    end 
    
end


    [r,c] = find(I);
    % r|c|local|global
    points_out = zeros(length(r),4);
    for p=1:length(r)
        points_out(p,1)=r(p);
        points_out(p,2)=c(p);
        points_out(p,4)=I(r(p),c(p));
        if points_out(p,1)==points_in(p,1) && points_out(p,2)==points_in(p,2)
            points_out(p,3) = points_in(p,3);
        else
            disp('row-column mismatch');
        end
    end % for p=1:length(r)

end

