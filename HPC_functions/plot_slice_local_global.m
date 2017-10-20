function plot_slice_local_global( L_golbal, L_local , slice)
%plot_slice_local_global plots the local and global labeling of the same
%slice 

% [Rx,Cx] = find(Lx_temp==Lx_temp(y(p),z(p)));%Rx = y, Cx = z
% [Ry,Cy] = find(Ly_temp==Ly_temp(x(p),z(p)));%Ry = x, Cy = z
% [Rz,Cz] = find(Lz_temp==Lz_temp(x(p),y(p)));%Rz = x, Cz = y

L_golbal = squeeze(L_golbal);
L_local = squeeze(L_local);


C_g_min = find(any(L_golbal,1),1,'first');
C_g_max = find(any(L_golbal,1),1,'last');

R_g_min = find(any(L_golbal,2),1,'first');
R_g_max = find(any(L_golbal,2),1,'last');

C_l_min = find(any(L_local,1),1,'first');
C_l_max = find(any(L_local,1),1,'last');

R_l_min = find(any(L_local,2),1,'first');
R_l_max = find(any(L_local,2),1,'last');


y_min = round(floor(min(C_g_min,C_l_min)-10),-1);
y_max = round(ceil(max(C_g_max,C_l_max)+10),-1);

x_min = round(floor(min(R_g_min,R_l_min)-10),-1);
x_max = round(ceil(max(R_g_max,R_l_max)+10),-1);




figure;
subplot(1,2,1)
hold on
for m = 1:max(max(L_golbal))
    [x,y] = find(L_golbal==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off

subplot(1,2,2)
hold on
for m = 1:max(max(L_local))
    [x,y] = find(L_local==m);
    plot(x,y,'.')
end
axis([x_min x_max y_min y_max])
grid on;
hold off

title(['Slice: ',num2str(slice)]);

end

