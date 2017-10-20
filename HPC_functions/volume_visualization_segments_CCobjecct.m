function volume_visualization_segments_CCobjecct(CC,Data)

% lin_IDX = [index,value]
%min_vol =  Data.min_volume_rearrange;
min_vol =  1500;
volume_3D = zeros(CC.ImageSize);

Label = 0;
vol = zeros(CC.NumObjects,1);

for n=1:CC.NumObjects
    vol(n) = length(CC.PixelIdxList{n});
    if vol(n) <= min_vol;vol(n)=-vol(n);continue;end
    Label = Label +1;
    volume_3D(CC.PixelIdxList{n}) = Label;
    %disp(['n=',num2str(n),'|L=',num2str(Label)]);
end

total_vol = sum(vol(vol>0));

lin_IDX = zeros(total_vol,2);
lin_IDX(:,1) = find(volume_3D);
lin_IDX(:,2) = volume_3D(lin_IDX(:,1));

stats = regionprops(volume_3D,'Centroid');
clear volume_3D


figure
hold on 
if min(lin_IDX(:,2)) == 0
    lin_ind = lin_IDX(lin_IDX(:,2)==0,1);
    [x_el,y_el,z_el] = ind2sub(Data.ImageSize,lin_ind);
    plot3(x_el,y_el,z_el,'or','MarkerSize',1);
end

for l=1:max(lin_IDX(:,2))
   
    lin_ind = lin_IDX(lin_IDX(:,2)==l,1);
    if length(lin_ind)<=3;continue;end
    
    [x_el,y_el,z_el] = ind2sub(CC.ImageSize,lin_ind);
    [N,~,~] = ODR_3D_line_fit([x_el,y_el,z_el]);
    x =  stats(l).Centroid(2);  % x and y are switched - image coordinates
    y =  stats(l).Centroid(1);  % are not the same as regular coordinates
    z =  stats(l).Centroid(3);
    
    plot3(x_el,y_el,z_el,'.','MarkerSize',1);
    %quiver3(x,y,z,N(1),N(2),N(3),'k','LineWidth',1,'AutoScaleFactor',15,'MaxHeadSize',0.5);
    %text(x-10,y-10,z,num2str(l),'Color','black','FontSize',14,'FontWeight','bold');

end
hold off
grid on,axis equal;
xlabel('X');ylabel('Y');zlabel('Z');
view(3)

end

