function y = relu(x)
%output is x same if x greater than or equal to zero or else zero
%same as linear function pi(x)=x except no negatives
%effects negative value features why though prefered and alternatives ?
%effects on other activation functions

%relu for better propogating error to last layers when multi layers are
%used tanh and sigmoid doesnt propogate it one of deep learning
%optimization so it is prefered
  y = max(0, x);
end