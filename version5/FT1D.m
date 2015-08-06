% @param Arad  Radon transform matrix
% @retval Z  2D Fourier space in radian grid. Each column is 1D Fourier 
% transform of correspoing column in Arad, i.e., central slice in 2D
% Fourier space at certain angle
function Z=FT1D(Arad)
size_s=size(Arad,1);
NFFT=2^nextpow2(size_s); % Next power of 2 from length of X
Z=zeros(NFFT,size(Arad,2));
if mod(size_s,2) % if length is an odd number, the 'middle' is between (size_s + 1)/2 and (size_s + 1)/2+1 
        mid_position = (size_s + 1)/2; 
else    % if length is an even number, the 'middle' is between size_s/2 and size_s/2+1 
        mid_position = size_s / 2; 
end 
zeropad=zeros(NFFT-size_s,1);
for i=1:size(Arad,2)
    radon_shift=ifftshift(Arad(:,i));
    % Add zeros to the middle of the shifted signal 
    radon_shift2 = vertcat(radon_shift(1:mid_position),zeropad,radon_shift((mid_position+1):size_s)); 
 
    % Shift the DC back to the centre 
    radon_pad = fftshift(radon_shift2); 

    ft1d=fftshift(fft(ifftshift(radon_pad)));
    Z(:,i)=ft1d;
end
