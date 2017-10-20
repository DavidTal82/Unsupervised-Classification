function [ I_fiber ] = fiber_thersholding( I, thresh, Save )
%fiber_thersholding - generate a fiber mask from the original 3D image,
%based on pre-determined threshold.
%   I - input image
%   thresh - thershold
%   Save - saving flag

I_fiber = I>=thresh;

if Save;save(['I_fiber_',num2str(thresh),'.mat'],'I_fiber', '-v7.3');end

end

