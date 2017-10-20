function plot_slice_8HW( P_1 , P_2, I_1 , I_2, plot_title, x_label, y_label )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


labels = unique(points(:,4));

figure
hold on
for l=1:length(labels)
    
    r = points(points(:,4)==labels(l),1);
    c = points(points(:,4)==labels(l),2);
    plot(r,c,'.')
end
hold off
grid on
if exist('plot_title','var');title(plot_title);end
if exist('x_label','var');xlabel(x_label);end
if exist('y_label','var');ylabel(y_label);end
axis equal



end

