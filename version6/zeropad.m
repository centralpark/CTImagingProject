
%! @file 
% Expand the matrix to power of 2 before doing FFT. 
% 
 

%! Zeropad each column to preprare for FFT. Expand the length of each column to the power of 2. The value of s in each row is also computed. 
% @param Radon matrix of Radon image 
% @retval Radon2 expaned matrix of Radon image 
% @retval axis_s value of s in each row 
function Radon_pad = zeropad(Radon) 
 
[size_s size_theta] = size(Radon); 
next_power_of_2 = pow2(nextpow2(size_s)); 
 
% Shift the DC to the left 
shifted_Radon = ifftshift(Radon,1); 
 
% Estimate the size of zeropad required 
size_zeropad = next_power_of_2 - size_s; 
zeropad = zeros(size_zeropad,size_theta); 
 
if(mod(size_s,2)) % if length is an odd number, the 'middle' is between (size_s + 1)/2 and (size_s + 1)/2+1 
        mid_position = (size_s + 1)/2; 
else    % if length is an even number, the 'middle' is between size_s/2 and size_s/2+1 
        mid_position = size_s / 2; 
end 
 
% Add zeros to the middle of the shifted signal 
shifted_Radon2 = vertcat(shifted_Radon(1:mid_position,:),zeropad,shifted_Radon((mid_position+1):size_s,:)); 
 
% Shift the DC back to the centre 
Radon_pad = fftshift(shifted_Radon2,1); 