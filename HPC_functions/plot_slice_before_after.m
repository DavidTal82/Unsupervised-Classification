function plot_slice_before_after( points_before , points_after )
%plot_slice_from_points Plots a slice
%   input - points array [r,c,local,global]

% before
unique_global_b = unique(points_before(:,4));
unique_local_b = unique(points_before(:,3));

% after
unique_global_a = unique(points_after(:,4));
unique_local_a = unique(points_after(:,3));

figure;

subplot(2,2,1);
hold on
for g = 1:length(unique_global_b)
    ind = find(points_before(:,4)==unique_global_b(g));
    switch unique_global_b(g)
        case -1
            marker = 'd';
        case 0
            marker = 'or';
        otherwise
            marker = '*';
    end
    plot(points_before(ind,1),points_before(ind,2),marker);
end
hold off
grid on
axis equal
axis tight
title('global before');
%legend('show','Location','best','Orientation','horizontal')

subplot(2,2,2);
hold on
for l = 1:length(unique_local_b)
    ind = find(points_before(:,3)==unique_local_b(l));
    
    switch unique_local_b(l)
        case -1
            marker = 'or';
        case 0
            marker = 'd';
        otherwise
            marker = '*';
    end
    plot(points_before(ind,1),points_before(ind,2),marker);
    
end
hold off
grid on
axis equal
axis tight
title('local before');







subplot(2,2,3);
hold on
for g = 1:length(unique_global_a)
    ind = find(points_after(:,4)==unique_global_a(g));
    switch unique_global_a(g)
        case -1
            marker = 'd';
        case 0
            marker = 'or';
        otherwise
            marker = '*';
    end
    plot(points_after(ind,1),points_after(ind,2),marker);
end
hold off
grid on
axis equal
axis tight
title('global after');
%legend('show','Location','best','Orientation','horizontal')

subplot(2,2,4);
hold on
for l = 1:length(unique_local_a)
    ind = find(points_after(:,3)==unique_local_a(l));
    
    switch unique_local_a(l)
        case -1
            marker = 'or';
        case 0
            marker = 'd';
        otherwise
            marker = '*';
    end
    plot(points_after(ind,1),points_after(ind,2),marker);
    
end
hold off
grid on
axis equal
axis tight
title('local after');


set(gcf, 'Position', [100 500 1680 420])
end

