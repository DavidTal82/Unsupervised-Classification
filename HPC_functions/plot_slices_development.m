function plot_slices_development( I_g_1, I_g_2 , I_l_1, I_l_2)
%plot_slice_local_global plots the local and global labeling of the same
%slice

C_g_min_1 = find(any(I_g_1,1),1,'first');
C_g_min_2 = find(any(I_g_2,1),1,'first');
C_l_min_1 = find(any(I_l_1,1),1,'first');
C_l_min_2 = find(any(I_l_2,1),1,'first');

C_g_max_1 = find(any(I_g_1,1),1,'last');
C_g_max_2 = find(any(I_g_2,1),1,'last');
C_l_max_1 = find(any(I_l_1,1),1,'last');
C_l_max_2 = find(any(I_l_2,1),1,'last');

R_g_min_1 = find(any(I_g_1,2),1,'first');
R_g_min_2 = find(any(I_g_2,2),1,'first');
R_l_min_1 = find(any(I_l_1,2),1,'first');
R_l_min_2 = find(any(I_l_2,2),1,'first');

R_g_max_1 = find(any(I_g_1,2),1,'last');
R_g_max_2 = find(any(I_g_2,2),1,'last');
R_l_max_1 = find(any(I_l_1,2),1,'last');
R_l_max_2 = find(any(I_l_2,2),1,'last');

C_min = min([C_g_min_1,C_g_min_2,C_l_min_1,C_l_min_2]);
C_max = max([C_g_max_1,C_g_max_2,C_l_max_1,C_l_max_2]);
R_min = min([R_g_min_1,R_g_min_2,R_l_min_1,R_l_min_2]);
R_max = max([R_g_max_1,R_g_max_2,R_l_max_1,R_l_max_2]);

y_min = round(floor(C_min-10),-1);
y_max = round(ceil(C_max+10),-1);

x_min = round(floor(R_min-10),-1);
x_max = round(ceil(R_max+10),-1);


figure;

subplot(2,2,1)
hold on
for m = 1:max(max(I_g_1))
    [x,y] = find(I_g_1==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off

subplot(2,2,2)
hold on
for m = 1:max(max(I_g_2))
    [x,y] = find(I_g_2==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off

subplot(2,2,3)
hold on
for m = 1:max(max(I_l_1))
    [x,y] = find(I_l_1==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off

subplot(2,2,4)
hold on
for m = 1:max(max(I_l_2))
    [x,y] = find(I_l_2==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off




end

