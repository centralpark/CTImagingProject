
%! @file 
% Apply Fast Fourier transform to the Radon image 
% 
 

%! Apply FFT to each columns of the matrix, then shifts the DC to the DFT centre. The value of axis_omega_s in each row is defined by the formula axis_omega_s = x * (2*pi / dx) where dx=1. 
% @param Radon Radon image. Number of rows must be the power of 2 for FFT to work. 
% @param DEBUG Debug mode. Save the Fourier_Radon image in real part and imaginary part. 
% @retval Fourier_Radon Radon image in Fourier Space 
% @retval axis_omega_s value of omega_s in each row 
function [Fourier_Radon axis_omega_s] = apply_fft1(Radon) 
 
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