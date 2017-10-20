function [N,P_start,P_end] = ODR_3D_line_fit( XYZData )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%function [Err,N,P] = fit_3D_data(, geometry, visualization, sod)
%
% [Err, N, P] = fit_3D_data(XData, YData, ZData, geometry, visualization, sod)
%
% Orthogonal Linear Regression in 3D-space
% by using Principal Components Analysis
%
% This is on matlab exmaple
% https://www.mathworks.com/help/stats/examples/fitting-an-orthogonal-regression-using-principal-components-analysis.html
%
%
% - geometry: type of approximation - line only
%
% Input parameters:
%  - XYXData: input data block -- x, y and Z: axis
%
% Return parameters:
%  - Err: error of approximation - sum of orthogonal distances
%  - N: normal vector for plane, direction vector for line
%  - P: point on plane or line in 3D space

[coeff,score,roots] = pca(XYZData);
normal = coeff(:,3);
[n,p] = size(XYZData);
meanXYZ = mean(XYZData,1);

%
error = abs((XYZData - repmat(meanXYZ,n,1))*normal);
Err = sum(error);
%
dirVect = coeff(:,1);
N=dirVect;
P=meanXYZ;

t = [min(score(:,1)), max(score(:,1))];
endpts = [meanXYZ + t(1)*dirVect'; meanXYZ + t(2)*dirVect'];

P_start = endpts(1,:);
P_end = endpts(2,:);
%
end

