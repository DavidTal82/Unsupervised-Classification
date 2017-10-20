function volume_visualization(volume_3D)

[x_dim,y_dim,z_dim] = size(volume_3D);
[x,y,z] = ndgrid(1:x_dim,1:y_dim,1:z_dim);
    

lin_ind = find(volume_3D);
[x_el,y_el,z_el] = ind2sub(size(volume_3D),lin_ind);
%{
% The alpha radios is a problem
shp = alphaShape(x_el,y_el,z_el,1);
figure
plot(shp);
grid on;
xlabel('x'),ylabel('y'),zlabel('z');
%}
%figure
plot3(x_el,y_el,z_el,'.','MarkerSize',1);
grid on,axis equal;
xlabel('x'),ylabel('y'),zlabel('z');

% figure
% p = patch(isosurface(x,y,z,volume_3D,0.5));
% set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
% view(3)
% camlight
% lighting gouraud
% grid on,axis([1 x_dim 1 y_dim 1 z_dim]);
% axis equal
% xlabel('X'),ylabel('Y'),zlabel('Z')

end

