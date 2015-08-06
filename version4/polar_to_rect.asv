% 
%! @file 
% Map polar coordinates to rectangular coordinates 
% 
      
%
%!  
% @param theta angles of Radon transform. Values of theta in each columns of Fourier_Radon 
% @param w_s values of w_s in each rows of Fourier_Radon 
% @param Fourier_Radon Matrix of Fourier transformed Radon image 
% @param N_image minimium size of the image 
% @param interp_m method of interpolation, can be 'nearest','linear' or 'cubic' 
% @param DEBUG Debug mode. If DEBUG=1, surface of Fourier_Radon in polar coordinates and in rectangular coordinates will be saved. 
% @retval Fourier_2D Matrix of the mapped Fourier space. By central slice theorem, this is equivalent to the 2D Fourier transform of the original image. 
% @retval axis_omega_xy values of omega_x (or omega_y) in the columns (or rows) of Fourier_2D. 
function [Fourier_2D axis_w] = polar_to_rect(theta,w_s,Fourier_Radon,N_image,interp_m) 
% Check correctness of input data 
[size_w_s size_theta] = size(Fourier_Radon); 
length_theta = length(theta); 
length_w_s = length(w_s); 
    
if(length_theta ~= size_theta) 
 error('size of theta does not match with the size of Fourier_Radon!') 
elseif(length_w_s ~= size_w_s) 
 error('size of w_s does not match with the size of Fourier_Radon!') 
end 
     
% Label each elements in the matrix Fourier_Radon with the corresponding theta and w_s: 
theta=[theta 180];
Fourier_Radon=horzcat(Fourier_Radon,flipud(Fourier_Radon(:,1)));

 
%Define the desired scale of the rectangular coordinates 

w_x = w_s; 
w_y= fliplr(w_x); 
    
% Label each (omega_x, omega_y) to (w_s, theta) 
[OMEGA_x OMEGA_y] = meshgrid(w_x, w_y); 
[THETA_I OMEGA_SI] = cart2pol(OMEGA_x,OMEGA_y); 
     
% map from {theta,w_s : [-pi,pi],[0,inf]} to {theta,w_s : [0, 180],[-inf,inf]} 
sign_theta=sign(THETA_I);
ind=find(sign_theta==0);
sign_theta(ind)=1;
OMEGA_SI = OMEGA_SI .* sign_theta; 
THETA_I = mod( THETA_I * (180/pi), 180); 
 
% Apply interpolation 
% disable extrapolation: everything outside the defined space is set to zero. 
Fourier_2D = interpol(theta,w_s,Fourier_Radon,THETA_I,OMEGA_SI,interp_m); 
axis_w = w_x; 