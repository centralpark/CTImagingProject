function save_result(varargin)
if nargin == 6
    axis_x = varargin{1};
    axis_y = varargin{2};
    result = varargin{3};
    Title = varargin{4};
    Xlabel = varargin{5};
    Ylabel = varargin{6};
    figure
    imagesc(axis_x,axis_y,result)
    axis xy
    colormap(gray);colorbar
    title(Title,'fontsize',16)
    xlabel(Xlabel,'fontsize',14)
    ylabel(Ylabel,'fontsize',14)
    if length(axis_x)==length(axis_y)
        axis square
    end
    print('-djpeg',strcat(Title,'.jpg'))
elseif nargin == 2
    result = varargin{1};
    Title = varargin{2};
    figure
    imagesc(result)
    colormap(gray);colorbar
    title(Title,'fontsize',16)
    print('-djpeg',strrep(strcat(Title,'.jpg'),':','_'))
else
    error('Inappropriate number of arguments');
end