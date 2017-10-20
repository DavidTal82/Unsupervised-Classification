function plot_slice_from_points( points )
%plot_slice_from_points Plots a slice
%   input - points array [r,c,local,global]

unique_global = unique(points(:,4));
unique_local = unique(points(:,3));

figure;

subplot(2,1,1);
hold on
for g = 1:length(unique_global)
    ind = find(points(:,4)==unique_global(g));
    
    switch unique_global(g)
        case -1
            marker = 'd';
        case 0
            marker = 'o';
        otherwise
            marker = '*';
    end
    plot(points(ind,1),points(ind,2),marker);
end
hold off
grid on
axis equal
axis tight
legend('show','Location','best','Orientation','horizontal')

subplot(2,1,2);
hold on
for l = 1:length(unique_local)
    ind = find(points(:,4)==unique_local(l));
    
    switch unique_global(g)
        case -1
            marker = 'o';
        case 0
            marker = 'd';
        otherwise
            marker = '*';
    end
    plot(points(ind,1),points(ind,2),marker);
    
end
hold off
grid on
axis equal
axis tight
legend('show','Location','best','Orientation','horizontal')
end

