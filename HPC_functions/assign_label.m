function [ points ] = assign_label( points, ind_yes_in, ind_no_in, Num_neighbors )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

all_ind = sort([ind_yes_in;ind_no_in]);

ind_yes = ind_yes_in;
ind_no = ind_no_in;

while ~isempty(points(ind_no,4)) && Num_neighbors > 1
    
    r_yes = points(ind_yes,1);c_yes = points(ind_yes,2);
    r_no = points(ind_no,1);c_no = points(ind_no,2);
    
    IDX = knnsearch([r_yes,c_yes],[r_no,c_no],'k',Num_neighbors);
    k_nearest = reshape(points(ind_yes(IDX(:)),4),size(IDX));
    
    for m=1:size(IDX,1)
        
        if min(k_nearest)==0;disp([num2str(ix),': zero neighboor']);end
        
        unique_k = unique(k_nearest(m,:));
        if ~points(ind_no(m),4) && length(unique_k)==1
            points(ind_no(m),4) = unique_k;
        end
    end
    
    Num_neighbors = Num_neighbors - 1;
    ind_yes = all_ind(logical(points(all_ind,4)));
    ind_no = all_ind(~logical(points(all_ind,4)));
    
end



end

