function plot_single_slice_8HW( points, Data, plot_title, x_label, y_label )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


labels = unique(points(:,4));
zero_flag = 0;
figure
hold on
for l=1:length(labels)
    if ~labels(l);zero_flag=1;continue;end
    r = points(points(:,4)==labels(l),1);
    c = points(points(:,4)==labels(l),2);
    plot(r,c,'.')
end
if zero_flag
    r = points(points(:,4)==0,1);
    c = points(points(:,4)==0,2);
    plot(r,c,'or')
end
hold off
grid on
if exist('plot_title','var');title(plot_title);end
if exist('x_label','var');xlabel(x_label);end
if exist('y_label','var');ylabel(y_label);end
%axis equal;
axis([0 Data.ImageSize(2) 0 Data.ImageSize(3)]);



end

