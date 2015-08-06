% BMEN E4984 Biomedical Imaging Project
%
% CT image reconstruction using Direct Fourier Reconstruction
theta=0:179;    %projection angles
image_dim=201;
A = phantom (image_dim);
figure(1);imagesc(A);colormap(gray);colorbar
[dimx dimy]=size(A);
Npix=203;
Arad= radon (A,theta); % each column in Arad is the radon transform at one angle theta
[Nbeam Nangle]=size(Arad);

Z=zeros(size(Arad));
for i=1:Nangle
    ft1d=fftshift(fft(ifftshift(Arad(:,i))));
    Z(:,i)=ft1d;
end


ZI=interpol(theta,Z,Npix);

ift=abs(ifftshift(ifft2(ifftshift(ZI))));
result=ImageCrop(ift,image_dim);
figure(2)
imagesc(result)
colormap(gray);colorbar
