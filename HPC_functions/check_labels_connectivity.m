function [ problem_flag_2, labels ] = ...
    check_labels_connectivity( Data, I, I_local , ix,  problem_flag_1)
%check_labels_connectivity - checks the connectivity of the labels. if one
%label appears in two objects (or more) the function returnes a problem
%flag and the list of labels to fix

problem_flag_2 = 0;
problem_flag_3 = 0;
problem_flag_4 = 0;

% [Rows,Columns] = size(I);

l_locals = unique(I_local(I_local>0));
l_globals = unique(I(I>0));

% if ix >= 200
%     set(0, 'DefaultFigurePosition', [-735     -550   560   420]); %figure position
%     figure;
%     subplot(211);imagesc(I_local');title([num2str(ix),'-local']);
%     subplot(212);imagesc(I');title([num2str(ix),'-global']);
%     
% end

labels = zeros(length(l_locals)*length(l_globals),7);

l_ind = 0;

for m = 1: length(l_locals)
    
    local_temp = l_locals(m);
    
    for n = 1:length(l_globals)
        
        global_temp = l_globals(n);
        
        if any(any(I(I_local == local_temp)==global_temp))
            l_ind = l_ind + 1;
            labels(l_ind,1) = local_temp;
            labels(l_ind,2) = global_temp;
            
            labels(l_ind,4) = length(find(I_local == local_temp));  %area local
            labels(l_ind,5) = length(find(I == global_temp));       %area global        
            
            [~, NUM_global_in_local] = bwlabeln(I==global_temp);
            if NUM_global_in_local > 1
                labels(l_ind,6) = NUM_global_in_local;
            else
                labels(l_ind,3) = global_temp;
            end
            
            [~, NUM_local_in_global] = bwlabeln(I_local==local_temp);
            if NUM_local_in_global > 1
                labels(l_ind,7) = NUM_local_in_global;
            end
        end
    end
end

labels(labels(:,1)==0,:) = [];


if any(labels(:,6))
    
    % temp = labels(labels(:,1) == labels(find(labels(:,3)==0,1)),:);
    % temp = labels(labels(:,1) == labels(find(labels(:,3)==0,1)),:);
    % labels = labels(~labels(:,3),:);
    
    problem_flag_2 = 1;
    if problem_flag_1
        for m = 1:size(labels,1)
            if labels(m,3)==0
                ind_temp = I_local == labels(m,1);
                labels(m,3) = mode(I(ind_temp));
            end
        end
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

labels(labels(:,3)==0,:) = [];

if length(unique(labels(:,2))) < length(unique(labels(labels(:,3)>0,3)))
    problem_flag_4 = 1;

elseif length(unique(labels(:,2))) > length(unique(labels(labels(:,3)>0,3)))
    problem_flag_2 = 0;
    problem_flag_3 = 1;
    
    ind_duplicate = find(labels(:,3) == mode(labels(:,3)));
    for i = 1:length(ind_duplicate)
        if labels(ind_duplicate(i),2) ~= labels(ind_duplicate(i),3)
            labels(ind_duplicate(i),3) = labels(ind_duplicate(i),2);
        end
    end
    
end




labels = labels(logical(labels(:,2)-labels(:,3)),:);

if isempty(labels)
    problem_flag_2 = 0;
    % elseif max(labels(:,7)) > 1 || max(labels(:,9)) > 1
    %     problem_flag_2 = 0;
end




end

