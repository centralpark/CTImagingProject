%% 
%! @file 
% Make a phantom. 
% 
 
%% 
%! Construct a matrix of a selected phantom. 
% @param shape Type of the phantom. Can be 'Shepp-Logan', 'Modified Shepp-Logan', 'dot', 'square', 'stripe' or 'offcentre dot' 
% @param N Size of the matrix 
% @retval P Matrix of the phantom image 
% 
function P = make_phantom(shape,N) 
 
    % T width of the square pulse or the stripe. T must be an even number. 
    T=round(N/4)*2; 
    R=T/2; 
 
switch shape 
  case {'Shepp-Logan','Modified Shepp-Logan'} 
    % Modified Shepp-Logan' gives better visual perception than 'Shepp-Logan' 
    P = phantom(shape,N); 
    P = flipud(P); 
  case {'dot'} 
    R=4; 
    x=linspace(-N/2,N/2,N); y=x; [X, Y]=meshgrid(x,y); P=(X.^2 +Y.^2 <= R^2); 
  case {'square'} 
    P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)]; 
    P=P'*P; 
  case {'stripe'} 
    P=[zeros(N,(N-T)/2) ones(N,T) zeros(N,(N-T)/2)]; 
  case {'circle'} 
    x=linspace(-N/2,N/2,N); y=x; [X, Y]=meshgrid(x,y); P=(X.^2 +Y.^2 <= R^2); 
  case {'offcentre dot'} 
% make a off-centre dot 
    P=zeros(N); 
    idx = round(N/4); 
    P(idx:idx+1,idx:idx+1)=1; 
end 