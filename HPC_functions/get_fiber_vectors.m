function [ stats ] = get_fiber_vectors( ImageSize , lin_ind )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


    [x,y,z] = ind2sub(ImageSize,lin_ind);
    [N,P_start,P_end] = ODR_3D_line_fit( [x,y,z] );
    
    stats.Vector = N';
    stats.Axis = [P_start;P_end];
    stats.Center = [mean(x),mean(y),mean(z)];


end

