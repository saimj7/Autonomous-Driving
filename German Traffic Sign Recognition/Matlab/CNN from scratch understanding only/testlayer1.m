%%  Test
%
load trafficsign.mat
% load Loading-Preprocessing-data.mat
%if test data have you can load it using load classes function and keep the saved mat file here
%to test your data
X = Images(:, :, 5300);%210 and 2220 and 2250
O = Labels(5300);

acc = 0;
N   = length(O);
for k = 1:N
 x  = X(:, :, k);               % Input,           74x74
    y1 = Conv(x, Wc);              % Convolution,  66x66x20
    y2 = ReLU(y1);                 %
    y3 = Pool(y2);                 % Pooling,      33x33x20
    y4 = reshape(y3, [], 1);       %
    v5 = Wph*y4;                    % ReLU,             21780
    y5 = ReLU(v5);                 %
    v  = Who*y5;                    % Softmax,          43x1
    y  = Softmax(v);               

  [~, i] = max(y);
  if i == O(k)
    acc = acc + 1;
  end
end

acc = acc / N;
fprintf('Accuracy is %f\n', acc);


