function volume_visualization_segments(volume_3D,m_size,yes_no_figure)

% volume_3D - the 3D array
% m_size - marker size, default = 1
% yes_no_figure - create a figure (if not created outside of the function)

if nargin == 1
    marker_size = 1;
end

if nargin >= 2
    marker_size = m_size;
end

if nargin == 3
    fig_flag = yes_no_figure;
else
    fig_flag = 1;
end


if fig_flag
    figure
end

hold on
for l=1:max(volume_3D(:))
    lin_ind = find(volume_3D==l);
    if isempty(lin_ind);continue;end
    [x_el,y_el,z_el] = ind2sub(size(volume_3D),lin_ind);
    plot3(x_el,y_el,z_el,'.','MarkerSize',marker_size);
    %     disp([num2str(l),'| length:',num2str(length(lin_ind))])
end
hold off
grid on,axis equal;
xlabel('X');ylabel('Y');zlabel('Z');
view(3)

end

