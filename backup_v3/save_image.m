%%
%! @file
% Save the gray-scale representation of the image.

%! Save the gray-scale representation of the image.
% @param x value of x in each column
% @param x value of y in each row
% @param Z matrix of the image
% @param Title title of the graph
% @param Xlabel label of the x-axis
% @param Ylabel label of the y-axis

function save_image(x,y,Z,Title,Xlabel,Ylabel)
figure
imagesc(x,y,Z)
% flip the y-axis to pointing upward
set(gca,'YDir','normal')
colormap(gray),colorbar
title(Title)
if(nargin > 2)
   xlabel(Xlabel),ylabel(Ylabel)
end
print('-dpng',strcat(strrep(Title,' ','_'),'.png'))