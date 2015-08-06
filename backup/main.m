%! @mainpage CentralSlice 
% CT Image Reconstruction using Central Slice Theorem. 
%  
% Refer to the project homepage http://code.google.com/p/centralslice/ 
 
%! @file 
% Main process of the simulation. 
 
%! @example start_simulation.m 
% 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%! Main process of the simulation. 
% This script generates a radon projection image from a selected phantom. 
% Then 1D Fourier transform is applied to each projection angle. The result is then interpolated onto the cartesian plane according to Central slice theorem. Lastly inverse 2D Fourier transform is applied to reproduce the image. 
% @param shape shape of the phantom. Can be 'Shepp-Logan', 'Modified Shepp-Logan', 'dot', 'square', or 'stripe' 
% @param N_image mininium size of the phantom image (in pixels) 
% @param N_theta Number of slices in Radon scan from 0deg to 180deg (excluding 180deg) 
% @param SNRdB Signal to Noise Ratio in log scale. 
% @param interp_m method of interpolation. Can be 'nearest','linear' or 'cubic' 
% @param oversampling_ratio oversampling ratio. Increase the Nyquist frequency to reduce aliasing. =1, none; >1 oversampling. 
% @param damage_ratio fraction of sensors damaged. =0, none; =1, all damaged. 
% @param DEBUG mode. If set to 1, many more figures are printed out for debugging process. 
function main(shape,N_image,N_theta,SNRdB,interp_m,oversampling_ratio,damage_ratio,DEBUG) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% MAKE A PHANTOM AND APPLY RADON TRANSFROMATION 
 
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
 
no_of_sensors = size(Radon,1); 
 
Radon = add_noise(Radon,SNRdB);         % Add noise to the image 
 
%% Sensor damage: nullify some sensors 
damage_radon = damage_sensors(Radon, damage_ratio); 
 
%% Zeropadding: expand the matrix to power of 2 before doing FFT 
[Radon2 axis_s] = zeropad(damage_radon); 
 
save_image(THETA,axis_s,Radon2,... 
        'Radon Projection','theta','s');        % Save the radon image 
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% 1D FOURIER TRANSFORM 
[Fourier_Radon omega_s] = apply_fft1(Radon2,DEBUG); 
 
save_image(THETA, omega_s, abs(Fourier_Radon),... 
        'Fourier transform of Radon Space, Absolute Value',... 
        'theta','omega_s'); 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% INTERPOLATION: Map slices from polar coordinates to rectangular coordinates 
[Fourier_2D omega_xy] = polar_to_rect(THETA,omega_s,Fourier_Radon,N_image*oversampling_ratio,interp_m,DEBUG); 
 
save_image(omega_xy,omega_xy,log(abs(Fourier_2D)),'Interpolated Fourier Space (log scale)','omega_x','omega_y') 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% INVERSE 2D FOURIER TRANSFORM 
[Reconstructed_image axis_xy_2] = inverse_Fourier_2D(Fourier_2D,omega_xy,DEBUG); 
 
% Crop image 
xy_min = axis_xy(1); 
xy_max = axis_xy(length(axis_xy)); 
[Crop_image new_axis_xy] = image_crop(Reconstructed_image,axis_xy_2,xy_min,xy_max,DEBUG); 
 
save_image(new_axis_xy,new_axis_xy,real(Crop_image),... 
        'Reconstructed Image','x','y'); 