
%! @file 
% Expand the matrix to power of 2 before doing FFT. 
% 
 

%! Zeropad each column to preprare for FFT. Expand the length of each column to the power of 2. The value of s in each row is also computed. 
% @param Radon matrix of Radon image 
% @retval Radon2 expaned matrix of Radon image 
% @retval axis_s value of s in each row 
function Radon_pad = zeropad(Radon) 
 
[size_s size_theta] = size(Radon); 


% Estimate the size of zeropad required 
size_zeropad = pow2(nextpow2(size_s)) - size_s; 
size_left=floor(size_zeropad/2);
size_right=size_zeropad-size_left;

Radon_pad = vertcat(zeros(size_left,size_theta),Radon,zeros(size_right,size_theta)); 