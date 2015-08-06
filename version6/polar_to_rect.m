% 
%! @file 
% Map polar coordinates to rectangular coordinates 
% 
      
%
%!  
% @param theta angles of Radon transform. Values of theta in each columns of Fourier_Radon 
% @param omega_s values of omega_s in each rows of Fourier_Radon 
% @param Fourier_Radon Matrix of Fourier transformed Radon image 
% @param N_image minimium size of the image 
% @param interp_m method of interpolation, can be 'nearest','linear' or 'cubic' 
% @param DEBUG Debug mode. If DEBUG=1, surface of Fourier_Radon in polar coordinates and in rectangular coordinates will be saved. 
% @retval Fourier_2D Matrix of the mapped Fourier space. By central slice theorem, this is equivalent to the 2D Fourier transform of the original image. 
% @retval axis_omega_xy values of omega_x (or omega_y) in the columns (or rows) of Fourier_2D. 
function [Fourier_2D axis_omega_xy] = polar_to_rect(theta,omega_s,Fourier_Radon,N_image,interp_m) 
% Check correctness of input data 
[size_omega_s size_theta] = size(Fourier_Radon); 
length_theta = length(theta); 
length_omega_s = length(omega_s); 
    
if(length_theta ~= size_theta) 
 error('size of theta does not match with the size of Fourier_Radon!') 
elseif(length_omega_s ~= size_omega_s) 
 error('size of omega_s does not match with the size of Fourier_Radon!') 
end 
     
% Label each elements in the matrix Fourier_Radon with the corresponding theta and omega_s: 
theta=[theta 180];
Fourier_Radon=horzcat(Fourier_Radon,flipud(Fourier_Radon(:,1)));

 
%Define the desired scale of the rectangular coordinates 
x = linspace(-(N_image-1)/2,(N_image-1)/2,N_image); 
dx=1; 
d_omega = 2*pi/(N_image-1); 
omega_x = x * d_omega; 
omega_y= fliplr(omega_x); 
    
% Label each (omega_x, omega_y) to (omega_s, theta) 
[OMEGA_X OMEGA_Y] = meshgrid(omega_x, omega_y); 
[THETA_I OMEGA_SI] = cart2pol(OMEGA_X,OMEGA_Y); 
     
% map from {theta,omega_s : [-pi,pi],[0,inf]} to {theta,omega_s : [0, 180],[-inf,inf]} 
sign_theta=sign(THETA_I);
ind=find(sign_theta==0);
sign_theta(ind)=1;
OMEGA_SI = OMEGA_SI .* sign_theta; 
THETA_I = mod( THETA_I * (180/pi), 180); 
 
% Apply interpolation 
% disable extrapolation: everything outside the defined space is set to zero. 
% Fourier_2D = interpol(theta,omega_s,Fourier_Radon,THETA_I,OMEGA_SI,interp_m);
Fourier_2D = interp2(theta,omega_s,Fourier_Radon,THETA_I,OMEGA_SI,interp_m);
Fourier_2D(find(isnan(Fourier_2D)))=0;
if mod(size(Fourier_2D,1),2)
    mid=(size(Fourier_2D,1)+1)/2;
    Fourier_2D(mid,1:mid-1) = fliplr(conj(Fourier_2D(mid,(mid+1):end)));
end
axis_omega_xy = omega_x; 