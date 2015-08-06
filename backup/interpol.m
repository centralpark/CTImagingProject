% @param Z  Matrix of 2D Fourier Space in radian grid. Each column is the 
% central slice at angle theta in 2D Fourier space
% @retval ZI  Matrix of 2D Fourier Space in cartesian grid after
% interpolation
function ZI=interpol(theta,Z,Npix)
% 2D interpolation from raidan grid to Cartesian grid
x_max=(Npix-1)/2;
ZI=zeros(Npix);
ds=1;
dx=1;
Nw=size(Z,1);
dw_s=2*pi/(Nw-1)/ds;
dw_x=2*pi/(Npix-1)/dx;
ratio=dw_x/dw_s;
for i=1:Npix
    for j=1:Npix
        x=(j-x_max-1)*ratio; %cartesian coordinates of point Q
        y=(x_max-i+1)*ratio;
        ZI(i,j)=neighbor(theta,Z,x,y,2);
    end
end