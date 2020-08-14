function y = Cnnconv(x, W)
%group convolution with all filters for getting same as data
%

[wr, wc, numfilters] = size(W);
[xr, xc, ~] = size(x);

%tidle operator no output returned

yr = xr - wr + 1; 
% size of output after number of convolution filters
yc = xc - wc + 1;

y = zeros(yr, yc, numfilters);
%output after convolution


  %zero padding changes everything
  
%   c=conv2(x,h,'full')
% cinput=conv2(x,h,'same')
%performs by keeping origin at center without rotating
%The filter2 function filters data by taking the 2-D convolution 
%of the input X and the coefficient matrix H rotated 180 degrees.
%Specifically, filter2(H,X,shape) is equivalent to conv2(X,rot90(H,2),shape).
%B = rot90(A,k) rotates array A counterclockwise by k*90 degrees, where k is an integer.
%180 degrees clock and anticlock both same
% f=filter2(h,x)

  
 for k = 1:numfilters
  filter = W(:, :, k); 
  filter = rot90(squeeze(filter), 2);
  y(:, :, k) = conv2(x, filter, 'valid');
  %without zero padding
  %without zero padding or with zero padding which to employ
  %effects mostly border pixels

end

