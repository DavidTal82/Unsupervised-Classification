function [ d ] = point2line_min_dist( p , a , n)
%point2line_min_dist computes the shortest distance between point p and
% the vectir a
%   p - point in space
%   a - point on the line
%   n - unit vector in the direction of the line

d = norm((a-p) - dot((a-p),n)*n);


end

