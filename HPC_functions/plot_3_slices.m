function plot_3_slices( L_golbal, L_local , slice)
%plot_slice_local_global plots the local and global labeling of the same
%slice 

% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y

L_golbal_1 = squeeze(L_golbal(:,:,1));
L_golbal_2 = squeeze(L_golbal(:,:,2));
L_golbal_3 = squeeze(L_golbal(:,:,3));

L_local_1 = squeeze(L_local(:,:,1));
L_local_2 = squeeze(L_local(:,:,2));
L_local_3 = squeeze(L_local(:,:,3));

C_g_min_1 = find(any(L_golbal_1,1),1,'first');
C_g_min_2 = find(any(L_golbal_2,1),1,'first');
C_g_min_3 = find(any(L_golbal_3,1),1,'first');

C_g_min = [C_g_min_1,C_g_min_2,C_g_min_3];

C_g_max_1 = find(any(L_golbal_1,1),1,'last');
C_g_max_2 = find(any(L_golbal_2,1),1,'last');
C_g_max_3 = find(any(L_golbal_3,1),1,'last');

C_g_max = [C_g_max_1,C_g_max_2,C_g_max_3];

R_g_min_1 = find(any(L_golbal_1,2),1,'first');
R_g_min_2 = find(any(L_golbal_2,2),1,'first');
R_g_min_3 = find(any(L_golbal_3,2),1,'first');

R_g_min = [R_g_min_1,R_g_min_2,R_g_min_3];

R_g_max_1 = find(any(L_golbal_1,2),1,'last');
R_g_max_2 = find(any(L_golbal_2,2),1,'last');
R_g_max_3 = find(any(L_golbal_3,2),1,'last');

R_g_max = [R_g_max_1,R_g_max_2,R_g_max_3];

C_l_min_1 = find(any(L_local_1,1),1,'first');
C_l_min_2 = find(any(L_local_2,1),1,'first');
C_l_min_3 = find(any(L_local_3,1),1,'first');

C_l_min = [C_l_min_1,C_l_min_2,C_l_min_3];

C_l_max_1 = find(any(L_local_1,1),1,'last');
C_l_max_2 = find(any(L_local_2,1),1,'last');
C_l_max_3 = find(any(L_local_3,1),1,'last');

C_l_max = [C_l_max_1,C_l_max_2,C_l_max_3];

R_l_min_1 = find(any(L_local_1,2),1,'first');
R_l_min_2 = find(any(L_local_2,2),1,'first');
R_l_min_3 = find(any(L_local_3,2),1,'first');

R_l_min = [R_l_min_1,R_l_min_2,R_l_min_3];

R_l_max_1 = find(any(L_local_1,2),1,'last');
R_l_max_2 = find(any(L_local_2,2),1,'last');
R_l_max_3 = find(any(L_local_3,2),1,'last');

R_l_max = [R_l_max_1,R_l_max_2,R_l_max_3];

y_min = round(floor(min([C_g_min,C_l_min])-10),-1);
y_max = round(ceil(max([C_g_max,C_l_max])+10),-1);

x_min = round(floor(min([R_g_min,R_l_min])-10),-1);
x_max = round(ceil(max([R_g_max,R_l_max])+10),-1);




figure;

subplot(2,3,1)
hold on
for m = 1:max(max(L_golbal_1))
    [x,y] = find(L_golbal_1==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off
title(['G-',num2str(slice-1)]);

subplot(2,3,2)
hold on
for m = 1:max(max(L_golbal_2))
    [x,y] = find(L_golbal_2==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off
title(['G-',num2str(slice)]);

subplot(2,3,3)
hold on
for m = 1:max(max(L_golbal_3))
    [x,y] = find(L_golbal_3==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off
title(['G-',num2str(slice+1)]);

subplot(2,3,4)
hold on
for m = 1:max(max(L_local_1))
    [x,y] = find(L_local_1==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off
title(['L-',num2str(slice-1)]);

subplot(2,3,5)
hold on
for m = 1:max(max(L_local_2))
    [x,y] = find(L_local_2==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off
title(['L-',num2str(slice)]);

subplot(2,3,6)
hold on
for m = 1:max(max(L_local_3))
    [x,y] = find(L_local_3==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off
title(['L-',num2str(slice+1)]);

end

