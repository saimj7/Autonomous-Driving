function [Wc, Wph, Who] = BackPropogation(Wc, Wph, Who, X, O)
%
%

alpha = 0.0001;
beta  = 0.095;

momentum1 = zeros(size(Wc));
momentum5 = zeros(size(Wph));
momentumo = zeros(size(Who));

N = length(O);

bsize = 3;  
blist = 1:bsize:(N-bsize+1);

% One epoch loop
%
for batch = 1:length(blist)
  dW1 = zeros(size(Wc));
  dW5 = zeros(size(Wph));
  dWo = zeros(size(Who));
  
  % Mini-batch loop
  %
  begin = blist(batch);
  for k = begin:begin+bsize-1
    % Forward pass = inference
    %
    x  = X(:, :, k);               % Input,           74x74
    y1 = Conv(x, Wc);              % Convolution,  66x66x20
    y2 = ReLU(y1);                 %
    y3 = Pool(y2);                 % Pooling,      33x33x20
    y4 = reshape(y3, [], 1);       %
    v5 = Wph*y4;                    % ReLU,             21780
    y5 = ReLU(v5);                 %
    v  = Who*y5;                    % Softmax,          43x1
    y  = Softmax(v);               %

    % One-hot encoding integer to vector
    %
    d = zeros(43, 1); %classes
    d(sub2ind(size(d), O(k), 1)) = 1;

    % Backpropagation
    %
    e      = d - y;                   % Output layer  
    delta  = e;

    e5     = Who' * delta;             % Hidden(ReLU) layer
    delta5 = (y5 > 0) .* e5;

    e4     = Wph' * delta5;            % Pooling layer
    
    e3     = reshape(e4, size(y3));

    %backpropogation to convolution layer
    e2 = zeros(size(y2));           
    W3 = ones(size(y2)) / (2*2);
    for c = 1:20
      e2(:, :, c) = kron(e3(:, :, c), ones([2 2])) .* W3(:, :, c);
    end
    
    delta2 = (y2 > 0) .* e2;          % ReLU layer
  
    delta1_x = zeros(size(Wc));       % Convolutional layer
    for c = 1:20
      delta1_x(:, :, c) = conv2(x(:, :), rot90(delta2(:, :, c), 2), 'valid');
    end
    
    dW1 = dW1 + delta1_x; 
    dW5 = dW5 + delta5*y4';    
    dWo = dWo + delta *y5';
  end 
  
  % Update weights
  %
  dW1 = dW1 / bsize; %minibatch sum plus average
  dW5 = dW5 / bsize;
  dWo = dWo / bsize;
  
  momentum1 = alpha*dW1 + beta*momentum1;
  Wc        = Wc + momentum1;
  
  momentum5 = alpha*dW5 + beta*momentum5;
  Wph        = Wph + momentum5;
   
  momentumo = alpha*dWo + beta*momentumo;
  Who        = Who + momentumo;  
end

end

