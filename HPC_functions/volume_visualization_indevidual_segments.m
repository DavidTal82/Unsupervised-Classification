function volume_visualization_indevidual_segments(volume_3D)


[x_size,y_size,z_size] = size(volume_3D);


for l=1:max(max(max(volume_3D)))
    lin_ind = find(volume_3D==l);
    
    if isempty(lin_ind);continue;end
    
    figure
    [x_el,y_el,z_el] = ind2sub(size(volume_3D),lin_ind);
    plot3(x_el,y_el,z_el,'.','MarkerSize',7);
	title(['global label: ',num2str(l),' | volume: ',num2str(length(lin_ind))])
    grid on,axis equal;
    axis([0 x_size 0 y_size 0 z_size]);
    xlabel('X');ylabel('Y');zlabel('Z');
    view(3)
end


end

