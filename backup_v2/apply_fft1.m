
%! @file 
% Apply Fast Fourier transform to the Radon image 
% 
 

%! Apply FFT to each columns of the matrix, then shifts the DC to the DFT centre. The value of axis_omega_s in each row is defined by the formula axis_omega_s = x * (2*pi / dx) where dx=1. 
% @param Radon Radon image. Number of rows must be the power of 2 for FFT to work. 
% @param DEBUG Debug mode. Save the Fourier_Radon image in real part and imaginary part. 
% @retval Fourier_Radon Radon image in Fourier Space 
% @retval axis_omega_s value of omega_s in each row 
function [Fourier_Radon axis_omega_s] = apply_fft1(Radon,DEBUG) 
 
% Apply FFT to each column of the radon image 
Fourier_Radon = fft(ifftshift(Radon,1)); 
 
% Label the axis_omega_s,theta axes; 
[size_omega_s size_theta] = size(Fourier_Radon); 
dx=1; 
% d_omega = 2*pi / Period; where dx = Period / N 
d_omega = 2*pi/((size_omega_s-1)*dx); 
axis_omega_s = linspace(-size_omega_s/2,size_omega_s/2,size_omega_s)* d_omega; 
 
% Shift the DC to the DFT centre 
%axis_omega_s = fftshift(axis_omega_s); 
Fourier_Radon = fftshift(Fourier_Radon,1); 
 
if(DEBUG) 
idx = 1:size_theta; %we do not need to know the angles in this function 
 
save_image(idx,axis_omega_s, real(Fourier_Radon),... 
        'Fourier transform of Radon Space, Real Part',... 
        'slice index','omega_s');       % Save the radon image (real part) 
save_image(idx,axis_omega_s, imag(Fourier_Radon),... 
        'Fourier transform of Radon Space, Imaginary Part',... 
        'slice index','omega_s');       % Save the radon image (imaginary part) 
 
stem(axis_omega_s, abs(Fourier_Radon(:,1))); 
axis tight; 
title('Slice at angle theta=0 in Fourier Space') 
xlabel('omega_s'),ylabel('Absolute Value');             % save the slice at 0deg 
print -dpng Slice_at_angle_theta_0_in_Fourier_Space.png 
end 