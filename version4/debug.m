[Reconstructed_image axis_xy_2] = inverse_Fourier_2D(Fourier_2D,w_x); 
 
% Crop image 
save_result(axis,axis,flipud(abs(Reconstructed_image)),'Original Image','x','y');