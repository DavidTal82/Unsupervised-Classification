function plot_slice_8HW_detailed( P_1,P_2, Data , x_label, y_label )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


label_L_1 = unique(P_1(:,3));
label_L_2 = unique(P_2(:,3));
label_G_1 = unique(P_1(:,4));
label_G_2 = unique(P_2(:,4));

figure
subplot(2,2,1);hold on
for l=1:length(label_L_1)
    r = P_1(P_1(:,3)==label_L_1(l),1);
    c = P_1(P_1(:,3)==label_L_1(l),2);
    plot(r,c,'.')
end
hold off;grid on
title('local-begining')
if exist('x_label','var');xlabel(x_label);end
if exist('y_label','var');ylabel(y_label);end
axis equal;axis([0 Data.ImageSize(2) 0 Data.ImageSize(3)]);

subplot(2,2,2);hold on
for l=1:length(label_G_1)
    r = P_1(P_1(:,4)==label_G_1(l),1);
    c = P_1(P_1(:,4)==label_G_1(l),2);
    if label_G_1(l)==0
        plot(r,c,'o')
    else
        plot(r,c,'.')
    end
end
hold off;grid on
title('global-begining')
if exist('x_label','var');xlabel(x_label);end
if exist('y_label','var');ylabel(y_label);end
axis equal;axis([0 Data.ImageSize(2) 0 Data.ImageSize(3)]);

subplot(2,2,3);hold on
for l=1:length(label_L_2)
    r = P_1(P_2(:,3)==label_L_2(l),1);
    c = P_1(P_2(:,3)==label_L_2(l),2);
    plot(r,c,'.')
end
hold off;grid on
title('local-end')
if exist('x_label','var');xlabel(x_label);end
if exist('y_label','var');ylabel(y_label);end
axis equal;axis([0 Data.ImageSize(2) 0 Data.ImageSize(3)]);

subplot(2,2,4);hold on
for l=1:length(label_G_2)
    r = P_1(P_2(:,4)==label_G_2(l),1);
    c = P_1(P_2(:,4)==label_G_2(l),2);
    if label_G_2(l)==0
        plot(r,c,'o')
    else
        plot(r,c,'.')
    end
end
hold off;grid on
title('global-end')
if exist('x_label','var');xlabel(x_label);end
if exist('y_label','var');ylabel(y_label);end
axis equal;axis([0 Data.ImageSize(2) 0 Data.ImageSize(3)]);

end

