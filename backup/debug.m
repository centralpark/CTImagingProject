clear
N_image=300;
shape='Modified Shepp-Logan';
N_theta=180;
DEBUG=0;
oversampling_ratio=1;
interp_m='linear';

Phantom = make_phantom(shape,floor(N_image/sqrt(2)));   % Make a phantom. 
 
axis_xy = linspace(-N_image/2,N_image/2,N_image); 
save_image(axis_xy,axis_xy,Phantom,... 
        'Phantom','x','y');             % Save the phantom image 
 
% Angles for Radon Projection. 
% It should be from 0deg to 180deg. The last angular sample normally is  smaller than 180deg. 
d_theta = 180 / N_theta; 
THETA = linspace(0,180-d_theta,N_theta); 
 
% Workaround a bug in Matlab function RADON, which assumes the y-axis points downwards instead of pointing upward 
Phantom_flipy = flipud(Phantom); 
Radon = radon(Phantom_flipy,THETA);             % Apply Radon transform. 


%% Zeropadding: expand the matrix to power of 2 before doing FFT 
[Radon2 axis_s] = zeropad(Radon); 
 
save_image(THETA,axis_s,Radon2,... 
        'Radon Projection','theta','s'); 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% 1D FOURIER TRANSFORM 
[Fourier_Radon omega_s] = apply_fft1(Radon2,DEBUG); 
 

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% INTERPOLATION: Map slices from polar coordinates to rectangular coordinates 
[Fourier_2D omega_xy] = polar_to_rect(THETA,omega_s,Fourier_Radon,N_image*oversampling_ratio,interp_m,DEBUG); 
 

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% INVERSE 2D FOURIER TRANSFORM 
[Reconstructed_image axis_xy_2] = inverse_Fourier_2D(Fourier_2D,omega_xy,DEBUG); 
 
% Crop image 
xy_min = axis_xy(1); 
xy_max = axis_xy(length(axis_xy)); 
[Crop_image new_axis_xy] = image_crop(Reconstructed_image,axis_xy_2,xy_min,xy_max,DEBUG); 
 
save_image(new_axis_xy,new_axis_xy,real(Crop_image),... 
        'Reconstructed Image','x','y'); 