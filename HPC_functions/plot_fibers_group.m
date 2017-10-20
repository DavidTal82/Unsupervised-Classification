function plot_fibers_group( XYZ , ImageSize)
%plot_fibers plots the connected fibers of only one group of connected
%fiber
%   input: XYZ - x,y,z coordinates of the fiber group

figure;
plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.','MarkerSize',1);
grid on
xlabel('x');ylabel('y');zlabel('z');
axis equal
axis([1 ImageSize(1) 1 ImageSize(2) 1 ImageSize(3)])
view(3)
end

