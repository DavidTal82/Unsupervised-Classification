function volume_visualization_segments_vectors(volume_3D)

    
stats = regionprops(volume_3D,'Centroid');

figure
hold on

if min(lin_IDX(:,2)) == 0
    lin_ind = lin_IDX(lin_IDX(:,2)==0,1);
    [x_el,y_el,z_el] = ind2sub(ImageSize,lin_ind);
    plot3(x_el,y_el,z_el,'or','MarkerSize',1);
end


for l=1:max(max(max(volume_3D)))
    
    lin_ind = find(volume_3D==l);
    if length(lin_ind)<=3;continue;end
    
    [x_el,y_el,z_el] = ind2sub(size(volume_3D),lin_ind);
    [N,~,~] = ODR_3D_line_fit([x_el,y_el,z_el]);
    x =  stats(l).Centroid(2);  % x and y are switched - image coordinates
    y =  stats(l).Centroid(1);  % are not the same as regular coordinates
    z =  stats(l).Centroid(3);
    
    plot3(x_el,y_el,z_el,'.','MarkerSize',1);
    quiver3(x,y,z,N(1),N(2),N(3),'k','LineWidth',1,'AutoScaleFactor',15,'MaxHeadSize',0.5);
    %text(x-10,y-10,z,num2str(l),'Color','black','FontSize',14,'FontWeight','bold');
end
hold off
grid on,axis equal;
xlabel('X');ylabel('Y');zlabel('Z');
view(3)

end

