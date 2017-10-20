function [G_X] = fix_backwards_labels_connectivity(ix_start,labels2fix,G_X)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

problem =  find(~(labels2fix(:,2)==labels2fix(:,3)));

[~,NUM_start] = bwlabeln(squeeze(G_X(ix_start,:,:)));

for l = 1:length(problem)
       
    
    for ix = (ix_start-1):-1:1
        
        [r,c] = find(squeeze(G_X(ix,:,:))==labels2fix(problem(l),2));
        % r|c|local|global
        for p=1:length(r)
            if G_X(ix,r(p),c(p)) && G_X(ix+1,r(p),c(p)) && G_X(ix,r(p),c(p)) ~= G_X(ix+1,r(p),c(p))
                G_X(ix,r(p),c(p)) = G_X(ix+1,r(p),c(p));
            end
        end % for p=1:length(r)
        
        [~,NUM] = bwlabeln(squeeze(G_X(ix,:,:)));
        
        if NUM==NUM_start
            break
        end

    end
    
 
end

end

