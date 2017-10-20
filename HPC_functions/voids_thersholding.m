function [ I_voids ] = voids_thersholding( I, thresh, Save )
%fiber_thersholding - generate a fiber mask from the original 3D image,
%based on pre-determined threshold.
%   I - input image
%   thresh - thershold
%   Save - saving flag

I_voids = I<=thresh;

if Save;save(['I_voids_',num2str(thresh),'.mat'],'I_voids', '-v7.3');end

end

