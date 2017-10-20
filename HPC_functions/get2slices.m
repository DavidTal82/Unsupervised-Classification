function [ i_S_1, i_S_2, i_V_1, i_V_2 ] = ...
    get2slices( ip,Dim, slices_3D, slices_2D)
%get2slices takes a 3D volumes and retunes 2 concecutive slices

switch Dim
    case 'z'
        i_S_1 = squeeze(slices_2D(:,:,ip));     % the i-th 2D comnectivity
        i_S_2 = squeeze(slices_2D(:,:,ip+1));	% the i-th +1 2D connectivity
        i_V_1 = squeeze(slices_3D(:,:,ip));      % the i-th 3D label
        i_V_2 = squeeze(slices_3D(:,:,ip+1));    % the i-th +1 3D label
    case 'y'
        i_S_1 = squeeze(slices_2D(:,ip,:));
        i_S_2 = squeeze(slices_2D(:,ip+1,:));
        i_V_1 = squeeze(slices_3D(:,ip,:));
        i_V_2 = squeeze(slices_3D(:,ip+1,:));
    case 'x'
        i_S_1 = squeeze(slices_2D(ip,:,:));
        i_S_2 = squeeze(slices_2D(ip+1,:,:));
        i_V_1 = squeeze(slices_3D(ip,:,:));
        i_V_2 = squeeze(slices_3D(ip+1,:,:));
end


end

