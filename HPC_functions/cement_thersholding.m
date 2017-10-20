function [ I_cement ] = cement_thersholding( I, thresh_low, thresh_high, Save )
%fiber_thersholding - generate a fiber mask from the original 3D image,
%based on pre-determined threshold.
%   I - input image
%   thresh - thershold
%   Save - saving flag

I_cement = and(I>thresh_low,I<thresh_high);

if Save
    save(['I_cement_',num2str(thresh_low),'to',num2str(thresh_high),'.mat']...
        ,'I_fiber', '-v7.3');
end

end

