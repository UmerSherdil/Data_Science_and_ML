function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Part 1
X = [ones(m,1), X];
z_2 = X*Theta1';
a_2 = sigmoid(z_2);
a_2 = [ones(m,1), a_2];
a_2_times_theta2 = a_2*Theta2';
prediction_matrix = sigmoid(a_2_times_theta2);

y_matrix = zeros(m, num_labels);
for c=1:num_labels
  y_matrix(:,c) = (y==c);

end

log_prediction = log(prediction_matrix);
first_term = y_matrix' * log_prediction;
one_minus_y = 1 - y_matrix;
log_one_minus_prediction_matrix = log(1-prediction_matrix);
second_term = one_minus_y' * log_one_minus_prediction_matrix;
unregularized_term = (-1/m) * (first_term + second_term);
unregularized_term = trace(unregularized_term);


theta1_squared = power(Theta1(:, 2:end), 2);
theta2_squared = power(Theta2(:, 2:end), 2);

theta1_squared_sum = sum(sum(theta1_squared));
theta2_squared_sum = sum(sum(theta2_squared));

regularized_term = (lambda / (2*m)) * (theta1_squared_sum + theta2_squared_sum);

J = unregularized_term + regularized_term;
% -------------------------------------------------------------

% =========================================================================

% Without regularization
delta_3 = prediction_matrix - y_matrix;
delta_3_projection_layer_2 = delta_3 * Theta2;
delta_2 = delta_3_projection_layer_2(:, 2:end) .* sigmoidGradient(z_2);

Theta2_grad = (delta_3' * a_2) / m;
Theta1_grad= (delta_2' * X) / m;

regularization_term_Theta2_grad = (lambda / m) .* Theta2(:, 2:end);
regularization_term_Theta1_grad = (lambda / m) .* Theta1(:, 2:end);

Theta2_grad(:, 2:end) = Theta2_grad(:, 2: end) + regularization_term_Theta2_grad;
Theta1_grad(:, 2:end) = Theta1_grad(:, 2: end) + regularization_term_Theta1_grad;


% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
