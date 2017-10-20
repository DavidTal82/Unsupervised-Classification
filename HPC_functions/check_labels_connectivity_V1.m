function [ problem_flag_2, labels ] = ...
    check_labels_connectivity( I, I_local , problem_flag_1)
%check_labels_connectivity - checks the connectivity of the labels. if one
%label appears in two objects (or more) the function returnes a problem
%flag and the list of labels to fix

problem_flag_2 = 0;

l_locals = unique(I_local(I_local>0));
l_globals = unique(I(I>0));

% local label | old global | new global | Area local | Area global | fix flag - NUM
labels = zeros(length(l_locals)*length(l_globals),6);

l_ind = 0;

for m = 1: length(l_locals)
    
    local_temp = l_locals(m);
    
    for n = 1:length(l_globals)
        
        global_temp = l_globals(n);
        
        if any(any(I(I_local == local_temp)==global_temp))
            l_ind = l_ind + 1;
            labels(l_ind,1) = local_temp;
            labels(l_ind,2) = global_temp;
            
            labels(l_ind,4) = length(find(I_local == local_temp));
            labels(l_ind,5) = length(find(I == global_temp));
            
            [~, NUM] = bwlabeln(I==global_temp);
            if NUM > 1
                labels(l_ind,6) = NUM;
            else
                labels(l_ind,3) = global_temp;
            end
        end
    end
end

labels(labels(:,1)==0,:) = [];
labels = labels(~labels(:,3),:);

if any(labels(:,6))
    problem_flag_2 = 1;
    
    if problem_flag_1
        
        for m = 1:size(labels,1)
            ind_temp = I_local == labels(m,1);
            labels(m,3) = mode(I(ind_temp));
        end

        %{
        labels(~ismember(labels(:,1),unique(labels(labels(:,6)>0,1))),:) = [];
        unique_local = unique(labels(:,1));
        for m = 1: length(unique_local)
            labels_temp = labels(labels(:,1)==unique_local(m),:);   
            if size(labels_temp,1) < 2
                labels(labels(:,1)==unique_local(m),6) = 0;
                labels(labels(:,1)==unique_local(m),3) = labels(labels(:,1)==unique_local(m),2);
                continue;
            end
            
            labels_temp = sortrows(labels_temp,5,'descend');
            
            new_global = labels_temp(logical(labels_temp(:,3)),3);
            
            if length(unique(new_global)) == 1
                labels_temp(:,3) = unique(new_global);
            else
                disp('problem - contrediction in global labels');
            end
            
            labels_temp(:,6) = 1;
            labels(labels(:,1)==unique_local(m),:) = labels_temp;
        end
        %}
    end
end

labels(labels(:,3)==0,:) = [];
labels = labels(logical(labels(:,2)-labels(:,3)),:);

if isempty(labels)
    problem_flag_2 = 0;
end



end

