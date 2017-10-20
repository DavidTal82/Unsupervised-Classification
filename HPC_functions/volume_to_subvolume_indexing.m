function [ sub_index ] = volume_to_subvolume_indexing( im_size, block_size )
%volume_to_subvolume_indexing takes the size of large image and devides the
%image to smaller blocs. the function does not performe the actual slicing
%but provieds the indecis for slicing the data.
%   im_zise - the original large image size
%   block size - the size of the blocks

if nargin < 2; block_size = [500,500,500];end

num_x = floor(im_size(1)/block_size(1));
num_y = floor(im_size(2)/block_size(2));
num_z = floor(im_size(3)/block_size(3));

if mod(im_size(1),block_size(1)) > block_size(1)/2;num_x = num_x+1;end
if mod(im_size(2),block_size(2)) > block_size(2)/2;num_y = num_y+1;end
if mod(im_size(3),block_size(3)) > block_size(3)/2;num_z = num_z+1;end

sub_index = cell(num_x,num_y,num_z);

for i =1:num_x
    for j=1:num_y
        for k=1:num_z
            
            index_temp = [block_size(1)*(i-1)+1,block_size(1)*i;
                block_size(2)*(j-1)+1,block_size(2)*j;
                block_size(3)*(k-1)+1,block_size(3)*k];
            
            if i==num_x;index_temp(1,2) = im_size(1);end
            if j==num_y;index_temp(2,2) = im_size(2);end
            if k==num_z;index_temp(3,2) = im_size(3);end
            
            sub_index{i,j,k} = index_temp;
            
            
        end
    end
end






end

