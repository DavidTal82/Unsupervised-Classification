function plot_fibers_boxed( CC, num_objects, plot_title )
%plot_fibers plots the connected fibers
%   input: CC - connectivity structure CC
%          num_objects - number of fibers to plot

if nargin < 2;num_objects = 5;end
if nargin < 3;add_title = 0;else add_title = 1;end

stats = regionprops(CC,'Area','BoundingBox','Centroid');

xdim = CC.ImageSize(1);
ydim = CC.ImageSize(2);
zdim = CC.ImageSize(3);

figure;
hold on

for i = 1:num_objects
    
    [x,y,z] = ind2sub(CC.ImageSize,CC.PixelIdxList{i});
    if length(x) < 2;continue;end
    
    
    
    [XYZ_1] = max([x,y,z]);
    [XYZ_2] = min([x,y,z]);
    x_1 = XYZ_1(1);y_1 = XYZ_1(2);z_1 = XYZ_1(3);
    x_2 = XYZ_2(1);y_2 = XYZ_2(2);z_2 = XYZ_2(3);
    
    Box = stats(i).BoundingBox;
    Box([1,2]) = Box([2,1]);% replacing x-y (probably image to xyz axes problem)
    Box([4,5]) = Box([5,4]);% replacing x-y width (probably image to xyz axes problem)
    
    Points = [x_1,y_1,z_1;
        x_1,y_1,z_2;
        x_1,y_2,z_1;
        x_1,y_2,z_2;
        x_2,y_1,z_1;
        x_2,y_1,z_2;
        x_2,y_2,z_1;
        x_2,y_2,z_2];
    
    plot3(x,y,z,'.','MarkerSize',1);
    %plot3(Points(:,1),Points(:,2),Points(:,3),'*r','MarkerSize',5)
    voxel(Box(1:3),Box(4:6),'b',0.01);
    
end

hold off
grid on
xlabel('x');ylabel('y');zlabel('z');
axis equal
axis([1 xdim 1 ydim 1 zdim])
view(3)
if add_title;title(plot_title);end


ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];


end

