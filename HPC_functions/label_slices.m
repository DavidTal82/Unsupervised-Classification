function [ L3D, split ] = ...
    label_slices( V3D , slice_ind , Dim , min_2D_area)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L3D = zeros(size(V3D));

switch Dim
    case 'x'
        [xDim,~,~] = size(V3D);
        split = zeros(xDim,1);
    case 'y'
        [~,yDim,~] = size(V3D);
        split = zeros(yDim,1);
        
    case 'z'
        [~,~,zDim,] = size(V3D);
        split = zeros(zDim,1);
end


for i=min(slice_ind):max(slice_ind)
    
    switch Dim
        case 'x'
            [L_temp,num] = bwlabel(squeeze(V3D(i,:,:)));
        case 'y'
            [L_temp,num] = bwlabel(squeeze(V3D(:,i,:)));
        case 'z'
            [L_temp,num] = bwlabel(squeeze(V3D(:,:,i)));
    end
    
    if ~num;continue;end
    for l=1:num
        if l>1 && length(find(L_temp==l))<min_2D_area
            L_temp(L_temp==l)=0;
        end
    end
    [L_temp,num] = bwlabel(L_temp);
    
    split(i) = num;
    
    switch Dim
        case 'x'
            L3D(i,:,:) = L_temp;
        case 'y'
            L3D(:,i,:) = L_temp;
        case 'z'
            L3D(:,:,i) = L_temp;
    end
    
end

% This is the old version that was in the main code
%     for ix=min(x):max(x)
%         [L_temp,num] = bwlabel(squeeze(V3D_temp(ix,:,:)));
%         if ~num;continue;end
%         for l=1:num
%             if l>1 && length(find(L_temp==l))<min_2D_area
%                 L_temp(L_temp==l)=0;
%             end
%         end
%         [L_temp,num] = bwlabel(L_temp);
%         % if num>1;disp(['slice x: ',num2str(ix),'|num: ',num2str(num)]);end
%         split_x(ix) = num;        
%         L3D_x_1(ix,:,:) = L_temp;
%     end
%     
%     for iy=min(y):max(y)
%         [L_temp,num] = bwlabel(squeeze(V3D_temp(:,iy,:)));
%         if ~num;continue;end
%         for l=1:num
%             if l>1 && length(find(L_temp==l))<min_2D_area
%                 L_temp(L_temp==l)=0;
%             end
%         end
%         [L_temp,num] = bwlabel(L_temp);
%         % if num>1;disp(['slice y: ',num2str(ix),'|num: ',num2str(num)]);end
%         split_y(iy) = num; 
%         L3D_y_1(:,iy,:) = L_temp;
%     end
%     
%     for iz=min(z):max(z)
%         [L_temp,num] = bwlabel(squeeze(V3D_temp(:,:,iz)));
%         if ~num;continue;end
%         for l=1:num
%             if l>1 && length(find(L_temp==l))<min_2D_area
%                 L_temp(L_temp==l)=0;
%             end
%         end
%         [L_temp,num] = bwlabel(L_temp);
%         % if num>1;disp(['slice z: ',num2str(ix),'|num: ',num2str(num)]);end
%         split_z(iz) = num; 
%         L3D_z_1(:,:,iz) = L_temp;
%     end


end

