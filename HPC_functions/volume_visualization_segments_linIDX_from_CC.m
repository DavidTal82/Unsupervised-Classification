function volume_visualization_segments_linIDX_from_CC(CC,angles)

% lin_IDX = [index,value]

% volume_3D = zeros(Data.ImageSize);
% volume_3D(lin_IDX(:,1)) = lin_IDX(:,2);
% stats = regionprops(volume_3D,'Centroid');
% clear volume_3D

min_vol =  1000;
vol = zeros(size(CC.PixelIdxList,2),1);

for n = 1:size(CC.PixelIdxList,2)
    
    n_vol = length(CC.PixelIdxList{n});
    
    if n_vol <= min_vol
        CC.NumObjects = CC.NumObjects - 1;
        vol(n) = -n_vol;
    else
        vol(n) = n_vol;
    end
end

total_vol = sum(vol(vol>0));

CC.PixelIdxList(vol<0) = [];

lin_IDX = zeros(total_vol,2);

Label = 0;
for n = 1:size(CC.PixelIdxList,2)
    Label = Label + 1;
    label_length = length(CC.PixelIdxList{n});
    
    ind_start = find(~lin_IDX(:,2),1);
    ind_end = label_length + ind_start - 1;
    lin_IDX(ind_start:ind_end,1) = CC.PixelIdxList{n};
    lin_IDX(ind_start:ind_end,2) = Label;
    
end

if min(lin_IDX(:,2)) == 0
    lin_ind = lin_IDX(lin_IDX(:,2)==0,1);
    [x_el,y_el,z_el] = ind2sub(CC.ImageSize,lin_ind);
    figure;
    plot3(x_el,y_el,z_el,'or','MarkerSize',1);
    grid on,axis equal;
    xlabel('X');ylabel('Y');zlabel('Z');
    view(3)
end


figure
hold on
for l=1:max(lin_IDX(:,2))
    
    lin_ind = lin_IDX(lin_IDX(:,2)==l,1);
    if length(lin_ind)<=3;continue;end
    
    [x_el,y_el,z_el] = ind2sub(CC.ImageSize,lin_ind);
    
    if any(angles)
        ptCloud = pointCloud([x_el,y_el,z_el]);
        t_x = angles(1);
        t_y = angles(2);
        t_z = angles(3);
        
        Tx = [1 	0           0           0
            0 	cos(t_x)	sin(t_x)	0
            0    -sin(t_x)	cos(t_x)	0
            0     0           0           1];
        
        Ty = [cos(t_y)   0	sin(t_y)   0
            0          1	0          0
            -sin(t_y)   0	cos(t_y)   0
            0          0	0          1];
        
        Tz = [cos(t_z)	sin(t_z)	0	0
            -sin(t_z)	cos(t_z)	0	0
            0        0           1   0
            0        0           0   1];
        
        T = Tz*Ty*Tx;
        tform = affine3d(T);
        ptCloudOut = pctransform(ptCloud,tform);
        x_el = ptCloudOut.Location(:,1);
        y_el = ptCloudOut.Location(:,2);
        z_el = ptCloudOut.Location(:,3);
        
    end
    %     [N,~,~] = ODR_3D_line_fit([x_el,y_el,z_el]);
    %     x =  stats(l).Centroid(2);  % x and y are switched - image coordinates
    %     y =  stats(l).Centroid(1);  % are not the same as regular coordinates
    %     z =  stats(l).Centroid(3);
    
    plot3(x_el,y_el,z_el,'.','MarkerSize',1);
    %quiver3(x,y,z,N(1),N(2),N(3),'k','LineWidth',1,'AutoScaleFactor',15,'MaxHeadSize',0.5);
    %text(x-10,y-10,z,num2str(l),'Color','black','FontSize',14,'FontWeight','bold');
end
hold off
grid on,axis equal;
%xlabel('X');ylabel('Y');zlabel('Z');
view(3)

end

