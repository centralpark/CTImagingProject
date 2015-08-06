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
function [Fourier_2D axis_omega_xy] = polar_to_rect(theta,omega_s,Fourier_Radon,N_image,interp_m,DEBUG) 
% Check correctness of input data 
[size_omega_s size_theta] = size(Fourier_Radon); 
length_theta = length(theta); 
length_omega_s = length(omega_s); 
    
if(length_theta ~= size_theta) 
 error('size of theta does not match with the size of Fourier_Radon!') 
elseif(length_omega_s ~= size_omega_s) 
 error('size of omega_s does not match with the size of Fourier_Radon!') 
end 
     
% Preparations 
% entend the range of Fourier Radon space so that value at theta=0 and theta =180 can be interpolated 
% Disabled so that the effect of scan range could be investigated 
%Extended_Fourier_Radon = horzcat( Fourier_Radon, Fourier_Radon(:,size_theta) ); 
%theta = [theta 180]; 
     
% Label each elements in the matrix Fourier_Radon with the corresponding theta and omega_s: 
theta=[theta 180];
Fourier_Radon=horzcat(Fourier_Radon,flipud(Fourier_Radon(:,1)));
[THETA OMEGA_S] = meshgrid(theta,omega_s); 
 
%Define the desired scale of the rectangular coordinates 
x = linspace(-100,100,N_image); 
y = x; 
dx=1; 
d_omega = 2*pi/(N_image-1); 
omega_x = x * d_omega; 
omega_y=omega_x; 
    
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
Fourier_2D = interp2(THETA,OMEGA_S,Fourier_Radon,... 
        THETA_I,OMEGA_SI,interp_m,0); 
axis_omega_xy = omega_x; 
    
%% DEBUG: Print surface of Fourier_Radon before and after interpolation 
if(DEBUG) 
[WX WY] = pol2cart(THETA,OMEGA_S); 
figure 
surf(WX,WY,abs(Fourier_Radon),... 
        'edgecolor','none') 
colormap(jet),colorbar 
title('Surface of Fourier transformed Radon space, before interpolation') 
xlabel('omega_x'),ylabel('omega_y') 
print -dpng 'Surface_of_Fourier_transformed_Radon_space_before_interpolation.png' 
    
figure 
surf(omega_x,omega_y,abs(Fourier_2D),... 
                'edgecolor','none') 
colormap(jet),colorbar 
title('Surface of Fourier transformed Radon space, after interpolation') 
xlabel('omega_x'),ylabel('omega_y') 
print -dpng 'Surface_of_Fourier_transformed_Radon_space_after_interpolation.png' 
end 