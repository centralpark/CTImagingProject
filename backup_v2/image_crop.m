%% 
%! @file 
% Crop the image to specified range. 
% 
 
%% 
%! @param image Image to be cropped 
% @param axis_xy original range of axes in the image 
% @param xy_min top left hand corner of the crop box 
% @param xy_max bottom right hand corner of the crop box 
% @param DEBUG Debug mode. If DEBUG=1, save the preview image. 
% @retval new_image cropped image 
% @retval new_axis_xy new axes range 
function [new_image new_axis_xy] = image_crop(image,axis_xy,xy_min,xy_max,DEBUG) 
 
% Make axis_xy a row vector 
if( size(axis_xy,2) ==1) 
axis_xy = axis_xy'; 
end 
 
% define crop box 
[row_idx col_idx val] = find( axis_xy>=xy_min & axis_xy<=xy_max ); 
idx_begin = col_idx(1); 
idx_end = col_idx(length(row_idx)); 
 
new_image = image(idx_begin:idx_end,idx_begin:idx_end); 
new_axis_xy = axis_xy(idx_begin:idx_end); 
 
if(DEBUG) 
figure 
imagesc(axis_xy,axis_xy,real(image)),colormap(gray),colorbar 
xlim([xy_min xy_max]),ylim([xy_min xy_max]) 
title('Cropbox preview'),xlabel('x'),ylabel('y') 
print -dpng 'cropbox_preview.png' 
end 