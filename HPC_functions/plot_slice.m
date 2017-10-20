function plot_slice( L , plot_title, x_label, y_label )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



num = max(max(L));

figure
hold on
for i=1:num
    
    [r,c] = find(L==i);
    plot(r,c,'.')
end
hold off
grid on
axis equal;axis([0 Data.ImageSize(2) 0 Data.ImageSize(3)]);
title(plot_title);
xlabel(x_label);
ylabel(y_label)


end

