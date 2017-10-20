function DEVELOPMENT_plot_fibers_group( XYZ , ImageSize , stats )
%plot_fibers plots the connected fibers of only one group of connected
%fiber
%   input: XYZ - x,y,z coordinates of the fiber group
%          stats

Box = stats.BoundingBox;
Center = stats.Centroid;

x_min = round(min(XYZ(:,1)),-2)-100;x_max = round(max(XYZ(:,1)),-2)+100;
y_min = round(min(XYZ(:,2)),-2)-100;y_max = round(max(XYZ(:,3)),-2)+100;
z_min = round(min(XYZ(:,3)),-2)-100;z_max = round(max(XYZ(:,3)),-2)+100;

figure;
subplot(1,2,1)
hold on
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.','MarkerSize',1);
plot3(Center(2),Center(1),Center(3),'*r','MarkerSize',10);
grid on
xlabel('x');ylabel('y');zlabel('z');
axis equal
axis([1 ImageSize(1) 1 ImageSize(2) 1 ImageSize(3)])
view(3)
hold off

subplot(1,2,2);
hold on
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.','MarkerSize',1);
plot3(Center(2),Center(1),Center(3),'*r','MarkerSize',10);
voxel(Box([2,1,3]),Box([5,4,6]),'b',0.01);
grid on
xlabel('x');ylabel('y');zlabel('z');
axis equal
axis([x_min x_max y_min y_max z_min z_max])
view(3)
hold off
end

