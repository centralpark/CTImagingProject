clc
clear
close all
N_theta=180;

d_theta = 180 / N_theta; 
THETA = linspace(0,180-d_theta,N_theta); 
 
% Workaround a bug in Matlab function RADON, which assumes the y-axis points downwards instead of pointing upward 
Phantom = phantom(201); 
Radon = radon(Phantom,THETA);             % Apply Radon transform. 

[Radon2 axis_s] = zeropad(Radon); 
 
save_image(THETA,axis_s,Radon2,... 
        'Radon Projection','theta','s');        % Save the radon image 
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 1D FOURIER TRANSFORM 
[Fourier_Radon omega_s] = apply_fft1(Radon2); 
 
save_image(THETA, omega_s, abs(Fourier_Radon),... 
        'Fourier transform of Radon Space, Absolute Value',... 
        'theta','omega_s'); 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INTERPOLATION: Map slices from polar coordinates to rectangular coordinates 
[Fourier_2D omega_xy] = polar_to_rect(THETA,omega_s,Fourier_Radon,201,'linear'); 

save_image(omega_xy,omega_xy,log(abs(Fourier_2D)),'Interpolated Fourier Space (log scale)','omega_x','omega_y') 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INVERSE 2D FOURIER TRANSFORM 
[Reconstructed_image axis_xy_2] = inverse_Fourier_2D(Fourier_2D,omega_xy); 
 
% Crop image 
figure;
imagesc(abs(Reconstructed_image));colormap(gray);colorbar