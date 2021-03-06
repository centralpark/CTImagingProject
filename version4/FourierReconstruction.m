function FourierReconstruction(N_theta,N_image)

d_theta = 180 / N_theta; 
theta = linspace(0,180-d_theta,N_theta); 
 
% Prepare source data 
Phantom = phantom(N_image);
axis=linspace(-(N_image-1)/2,(N_image-1)/2,N_image);
save_result(axis,axis,flipud(Phantom),'Original Image','x','y');
Radon = radon(Phantom,theta);             % Apply Radon transform. 
size_s = size(Radon,1);
axis_s = linspace(-(size_s-1)/2,(size_s-1)/2,size_s);
save_result(theta,axis_s,flipud(Radon),'Radon Transform','\theta','s');        % Save the radon image 
Radon_pad = zeropad(Radon);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 1D FOURIER TRANSFORM 
[Fourier_Radon omega_s] = apply_fft1(Radon_pad); 
 
save_result(theta, omega_s, abs(Fourier_Radon),... 
        'Fourier transform of Radon Space, Absolute Value',... 
        'theta','omega_s'); 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INTERPOLATION: Map slices from polar coordinates to rectangular coordinates 
[Fourier_2D omega_xy] = polar_to_rect(theta,omega_s,Fourier_Radon,201,'linear'); 

save_result(omega_xy,omega_xy,log(abs(Fourier_2D)),'Interpolated Fourier Space (log scale)','omega_x','omega_y') 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INVERSE 2D FOURIER TRANSFORM 
[Reconstructed_image axis_xy_2] = inverse_Fourier_2D(Fourier_2D,omega_xy); 
 
% Crop image 
save_result(axis,axis,flipud(abs(Reconstructed_image)),'Original Image','x','y');