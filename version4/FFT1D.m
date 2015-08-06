function [Fourier_Radon axis_w_s] = FFT1D(Radon) 
 
% Apply FFT to each column of the radon image 
temp = fft(Radon,[],1);
temp1 = fftshift(temp,1);
row_extra = conj(temp1(1,:));
Fourier_Radon = vertcat(temp1,row_extra);
ds=1;
w_s_max=2*pi/2/ds;
axis_w_s=linspace(-w_s_max,w_s_max,size(Fourier_Radon,1));