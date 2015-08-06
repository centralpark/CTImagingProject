% close all
% theta=0:179;
% A = phantom (201);
% figure(1);imagesc(A);colormap(gray);colorbar
% Arad= radon (A,theta);
% result=iradon(Arad,theta);
% figure(2);imagesc(result);colormap(jet);colorbar

te1=result;
te2=A;
dif=te1-te2;
figure(3);imagesc(dif);colormap(jet);colorbar
SSE=sum(sum(dif.^2))