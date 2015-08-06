function save_result(axis_x,axis_y,result,Title,Xlabel,Ylabel)
figure
imagesc(axis_x,axis_y,result)
axis xy
colormap(gray);colorbar
title(Title,'fontsize',14)
xlabel(Xlabel,'fontsize',12)
ylabel(Ylabel,'fontsize',12)
print('-djpeg',strcat(Title,'.jpg'))
