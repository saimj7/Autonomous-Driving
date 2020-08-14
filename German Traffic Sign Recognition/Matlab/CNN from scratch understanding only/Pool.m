function y = pool(x)
     
% 2x2 mean pooling

stride=2
[xr, xc, nf] = size(x);

y = zeros(xr/2, xc/2, nf);
for k = 1:nf
    %using conv kernel for averaging
  kernelfilter = ones(2) / (2*2);    % for mean    
  % without zero padding no edges
  pooled  = conv2(x(:, :, k), kernelfilter, 'valid');
  %down sample only keeping stride-slices here its 2
  y(:, :, k) = pooled(1:stride:end, 1:stride:end);
end

end
 