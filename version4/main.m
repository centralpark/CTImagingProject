N_theta=180;
N_image=201;
interp_m='linear';
d_theta = 180 / N_theta; 
theta = linspace(0,180-d_theta,N_theta); 
 
% Prepare source data 
Phantom = phantom(N_image);
% Phantom=zeros(N_image);
% Phantom(80:121,50:91)=1;
axis=linspace(-(N_image-1)/2,(N_image-1)/2,N_image);
save_result(axis,axis,flipud(Phantom),'Original Image','x','y');
Radon = radon(Phantom,theta);             % Apply Radon transform. 
size_s = size(Radon,1);
axis_s = linspace(-(size_s-1)/2,(size_s-1)/2,size_s);
save_result(theta,axis_s,flipud(Radon),'Radon Transform','\theta','s');        % Save the radon image 
Radon_pad = zeropad(Radon);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 1D FOURIER TRANSFORM 
[Fourier_Radon w_s] = FFT1D(Radon_pad); 
 
save_result(theta, w_s, log(abs(Fourier_Radon)),'Fourier transform of Radon Space (Absolute Value)'...
    ,'\theta','\omega_s'); 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INTERPOLATION: Map slices from polar coordinates to rectangular coordinates 
[Fourier_2D w_x] = polar_to_rect(theta,w_s,Fourier_Radon,N_image,interp_m); 

save_result(w_x,fliplr(w_x),log(abs(Fourier_2D)),...
    'Interpolated 2D Fourier Space (Log Scale)','\omega_x','\omega_y') 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INVERSE 2D FOURIER TRANSFORM 
[Reconstructed_image axis_xy_2] = inverse_Fourier_2D(Fourier_2D,w_x); 
 
% Crop image 
save_result(axis,axis,flipud(abs(Reconstructed_image)),'Original Image','x','y');