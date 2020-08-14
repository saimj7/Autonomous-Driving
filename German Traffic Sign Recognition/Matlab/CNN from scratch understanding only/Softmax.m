function y = softmax(x)
%regression probability assignign
    y  = (exp(x)) / (sum(exp(x)));
end