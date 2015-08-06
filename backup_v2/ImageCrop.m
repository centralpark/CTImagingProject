function image_r=ImageCrop(image_o,NumPix)
np=size(image_o,1);
del=(np-NumPix)/2;
p_min=1+del+1;
p_max=np-del+1;
image_r=image_o(p_min:p_max,p_min:p_max);