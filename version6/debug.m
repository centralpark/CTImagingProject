N_theta=180; N_image=201; method='linear';SNRdB=inf;mode=1;

d_theta = 180 / N_theta; 
theta = linspace(0,180-d_theta,N_theta); 

Phantom=phantom(201);
% Phantom = zeros(N_image);
% Phantom(100,60)=1;
% Phantom(100,63)=1;
axis = linspace(-(N_image-1)/2,(N_image-1)/2,N_image);
Radon = radon(Phantom,theta);             % Apply Radon transform. 
if ~isinf(SNRdB)
    Radon = add_noise(Radon,SNRdB);
end
axis_s = linspace(-(size(Radon,1)-1)/2,(size(Radon,1)-1)/2,size(Radon,1));
if mode
    save_result(axis,fliplr(axis),Phantom,'Original Image','x','y');
    save_result(theta,axis_s,Radon,'Radon Transform','\theta','s');
end
Radon_pad = zeropad(Radon); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 1D FOURIER TRANSFORM 
[Fourier_Radon w_s] = apply_fft1(Radon_pad); 
if mode
    save_result(theta, w_s, log(abs(Fourier_Radon)),... 
        'Fourier Transform of Radon Space (Absolute Value in Log Scale)'...
        ,'\theta','\omega_s'); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INTERPOLATION: Map slices from polar coordinates to rectangular coordinates 
[Fourier_2D w_xy] = polar_to_rect(theta,w_s,Fourier_Radon,N_image,method); 
if mode
    save_result(w_xy,fliplr(w_xy),log(abs(Fourier_2D)),...
    'Interpolated Fourier Space From Raidal Grid to Cartesian Grid (Log Scale)'...
    ,'\omega_x','\omega_y') 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% INVERSE 2D FOURIER TRANSFORM 
[Reconstructed_image axis_xy_2] = inverse_Fourier_2D(Fourier_2D,w_xy); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crop image 
Reconstructed_image = abs(Reconstructed_image);
if mode
    save_result(axis,fliplr(axis),abs(Reconstructed_image),'Reconstructed Image'...
    ,'x','y');
end
