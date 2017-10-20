function plot_fibers( CC, num_objects, plot_title )
%plot_fibers plots the connected fibers
%   input: CC - connectivity structure CC
%          num_objects - number of fibers to plot

if nargin < 2;num_objects = 5;end
if nargin < 3;add_title = 0;else;add_title = 1;end

xdim = CC.ImageSize(1);
ydim = CC.ImageSize(2);
zdim = CC.ImageSize(3);

figure;
hold on
for i = 1:num_objects
    
    [x,y,z] = ind2sub(CC.ImageSize,CC.PixelIdxList{i});
    
    plot3(x,y,z,'.','MarkerSize',1);


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

