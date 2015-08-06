% @param Z  Matrix of 2D Fourier Space in radian grid. Each column is the 
% central slice at angle theta in 2D Fourier space
% @retval ZI  Matrix of 2D Fourier Space in cartesian grid after
% interpolation
function ZI=interpol_v2(theta,Z,Npix)
% 2D interpolation from raidan grid to Cartesian grid
x_max=(Npix-1)/2;
ZI=zeros(Npix);


for i=1:Npix
    for j=1:Npix
        x=(j-x_max-1); %cartesian coordinates of point Q
        y=(x_max-i+1);
        ZI(i,j)=neighbor_v2(theta,Z,Npix,x,y,2);
    end
end