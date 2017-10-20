function volume_visualization_segments_batches(volume_3D)

[x_dim,y_dim,z_dim] = size(volume_3D);
batch_size = 10;
counter = 1;

labels = unique(volume_3D(:));
labels(labels==0) = [];

while counter <= length(labels)
    
    label_start = counter;
    label_end = counter + batch_size - 1;
    if label_end > length(labels);label_end = length(labels);end 
    
    labels_small = labels(label_start:label_end);    
    
    figure
    hold on
    for l=1:length(labels_small)
        
        lin_ind = find(volume_3D==labels_small(l));
        
        if isempty(lin_ind);continue;end
        
        [x_el,y_el,z_el] = ind2sub(size(volume_3D),lin_ind);
        plot3(x_el,y_el,z_el,'.','MarkerSize',1);
        
    end
    hold off
    grid on,axis equal;
    axis([0 x_dim 0 y_dim 0 z_dim]);
    xlabel('X');ylabel('Y');zlabel('Z');
    view(3)
    
    counter = label_end + 1;
    
end

end

