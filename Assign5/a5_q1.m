
[lambda, optimum] = quadratic_interpolation(@objective_function, 1, 0.5);


function [lambda, optimum] = quadratic_interpolation(objective_function, x_a, t_0)
    % Following is the tolerance for checking convergence. 
    % If the code does not converges, you can increase the tolerance, but a high value may also result in wrong answer
    tol = 1E-4;
    error = 1.0;
    count = 0;
    
    % Function
    f = objective_function;
    
    % Initialization
    a = x_a - t_0;
    b = x_a;
    c = x_a + t_0;
    
    % Find good a and c
    while (f(b) > f(a)) || (f(b) > f(c))
        a = a - t_0;
        c = c + t_0;
    end
    
    l = compute_optimum_lambda(f, a, b, c);
    
    fprintf("Pre initialization\n")
    fprintf('[a] %.2f - [b] %.2f - [c] %.2f - [lambda] %.2f\n', a, b, c, l)

    while error > tol
        
        fprintf('\nIteration %d...\n', count)
        
        % You have to write the code here to implement quadratic interpolation
        % x_a is the initial guess
        % t_0 is the intial step
        [points, ~] = sort([l a b c]);
        values = [f(points(1)) f(points(2)) f(points(3)) f(points(4))];
        [~, idx] = sort(values);
        min_idx = idx(1);
        
        a = points(min_idx-1);
        b = points(min_idx);
        c = points(min_idx+1);
        
        if (a == b) && (b == c)
            fprintf("\nBREAKING!\n")
            break
        end
        
        % The lambda (x corresponding to minima of interpolated function) corresponding to points x_a, x_b, x_c can be evaluated as
        l = compute_optimum_lambda(f, a, b, c);
        fprintf('[a] %.2f - [b] %.2f - [c] %.2f - [lambda] %.2f\n', a, b, c, l)
        
        % Error for checking convergence can be computed as
        error = compute_metric(f, l, 0.01);
        
        count = count + 1;
        
        if count > 50
            break
        end
    end
    
    lambda = l;
    optimum = f(lambda);
    
    disp(lambda)
    disp(optimum)
    disp(count)
end


function objective_value = objective_function(x)
   % objective function which you have to minimize. Though you code will be checked against a function which you do not know, you can use this function to test
   % your code against an objective function of choice. For example:
   objective_value = (x-2)^2; % Is an objective function. You code should be able to return (0, 0) for this choice of objective function. 
   
   % Note that this function will not be used in testing your code. It is here just for you to know how the grader in background works.
end


function lambda = compute_optimum_lambda(objective_function, a, b, c)
   % Function to compute the x (or lambda) corresponding to the minimum value of quadratic interpolation. It takes input as three points x_a, x_b, x_c which is used in interpolation
   % The corresponding outputs of objective function can be computed as
   
   f = objective_function;
   
   a_num = f(a)*b*c*(c-b) + f(b)*c*a*(a-c) + f(c)*a*b*(b-a);
   a_den = (a-b)*(b-c)*(c-a);
   
   b_num = f(a)*(b^2 - c^2) + f(b)*(c^2 - a^2) + f(c)*(a^2 - b^2);
   b_den = (a-b)*(b-c)*(c-a);
   
   c_num = f(a)*(b-c) + f(b)*(c-a) + f(c)*(a-b);
   c_den = (a-b)*(b-c)*(c-a);
   
   a = a_num/(a_den + 1E-06);
   b = b_num/(b_den + 1E-06);
   c = -c_num/(c_den + 1E-06);
   
   lambda = -b/(2*c + 1E-06);
   
end

function metric = compute_metric(objective_function, lambda, delta_lambda)
    %Function to compute a metric for stopping criteria. You can play with delta_lambda if you have convergence issues. Small value of delta_lambda is recommended.
    metric = (objective_function(lambda+delta_lambda) - objective_function(lambda-delta_lambda))/(2*delta_lambda);
    metric = abs(metric);
    % You can even change this metric as you please.
end