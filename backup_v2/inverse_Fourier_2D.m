%% 
%! @file 
% Apply inverse Fourier 2D transform to the image 
% 
 
%% 
%! @param Fourier_2D matrix of the interpolated 2D Fourier space 
% @param omega_xy value of omega_x (or omega_y) in each column (or row) of matrix \c Fourier_2D. 
% @param DEBUG Debug mode. If DEBUG=1, save the image of the reconstructed image in imaginary part. 
% @retval Final_image Inverse Fourier transform of matrix \c Fourier_2D. 
% @retval axis_xy value of x (or y) in each column (or row) of \c Final_image 
function [Final_image,axis_xy] = inverse_Fourier_2D(Fourier_2D,omega_xy,DEBUG) 
 
% Shift the DC to the left top corner 
shifted_Fourier_2D = ifftshift(Fourier_2D); 
 
% Apply inverse 2D Fourier transform 
shifted_Final_image = ifft2(shifted_Fourier_2D); 
 
% Shift the DC back to the centre 
Final_image = fftshift(shifted_Final_image); 
 
%Label the axes x and y 
size_omega = length(omega_xy); 
d_omega = mean(diff(omega_xy)); 
dx = 2*pi/(d_omega*size_omega); 

axis_xy = omega_xy * (dx / d_omega); 
 
if(DEBUG) 
save_image(axis_xy,axis_xy,imag(Final_image),... 
        'Reconstructed Image, imaginary part','x','y'); 
end 