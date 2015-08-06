function SSE = evaluation(N_image,Reconstructed_image)

result = abs(Reconstructed_image);
original = phantom(N_image);
dif = result - original;
figure;imagesc(dif);colormap(jet);colorbar
SSE=sum(sum(dif.^2));