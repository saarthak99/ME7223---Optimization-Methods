[lambda, optimum, count] = quadratic_interpolation(@objective_function, 5, 0.5)

function [lambda, optimum, count] = quadratic_interpolation(objective_function, x_a, t_0)
    %Following is the tolerance for checking convergence. If the code does not converges, you can increase the tolerance, but a high value may also result in wrong answer
    tol = 1E-8;
    % You have to write the code here to implement quadratic interpolation
    % x_a is the initial guess
    % t_0 is the intial step
    % The objective function value corresponding to a point can be evaluated as
    f_a = objective_function(x_a);
    x_b = x_a + t_0;
    f_b = objective_function(x_b);
    x_c = x_a + 2*t_0;
    f_c = objective_function(x_c);
    error = 10;
    
    while f_b > f_c
        t_0 = 2*t_0;
        x_b = x_a + t_0;
        x_c = x_a + 2*t_0;
        f_b = objective_function(x_b);
        f_c = objective_function(x_c);
        
    end
    
        lambda = compute_optimum_lambda(objective_function, x_a, x_b, x_c);
        % Error for checking convergence can be computed as
        delta_lambda = 0.005 ;
        error = compute_metric(objective_function, lambda, delta_lambda);    
    % The lambda (x corresponding to minima of interpolated function) corresponding to points x_a, x_b, x_c can be evaluated as
    count=0
    while error > tol
        count = count+1
        if t_0 > 0
            if lambda < x_b 
                x_c = x_b;
                x_b = lambda;
                f_b = objective_function(x_b);
                f_c = objective_function(x_c);
            else
                x_a = x_b;
                x_b = lambda;
                f_b = objective_function(x_b);
                f_a = objective_function(x_a);
            end
        end
            
        if t_0 < 0 
            if lambda < x_b
                x_a = x_b;
                x_b = lambda;
                f_b = objective_function(x_b);
                f_a = objective_function(x_a);
            else
                x_c = x_b;
                x_b = lambda;
                f_b = objective_function(x_b);
                f_c = objective_function(x_c); 
            end  
        end
            
        lambda = compute_optimum_lambda(objective_function, x_a, x_b, x_c);
        % Error for checking convergence can be computed as
        delta_lambda = 0.001 ;
        error = compute_metric(objective_function, lambda, delta_lambda); % You have to specify a small value of delta lambda
    end
    lambda = lambda;
    optimum = objective_function (lambda);
end

function objective_value = objective_function(x)
    objective_value = exp(abs(x));
end


function lambda = compute_optimum_lambda(objective_function, x_a, x_b, x_c)
   % Function to compute the x (or lambda) corresponding to the minimum value of quadratic interpolation. It takes input as three points x_a, x_b, x_c which is used in interpolation
   % The corresponding outputs of objective function can be computed as
   f_a = objective_function(x_a); % and so on for x_b and x_c
   f_b = objective_function(x_b);
   f_c = objective_function(x_c);
   lambda = (f_a*(x_b^2-x_c^2) + f_b*(x_c^2 - x_a^2) + f_c*(x_a^2 - x_b^2))/(2*(f_a*(x_b-x_c) +f_b*(x_c-x_a) + f_c*(x_a - x_b))+(1E-12));  
end

function metric = compute_metric(objective_function, lambda, delta_lambda)
    %Function to compute a metric for stopping criteria. You can play with delta_lambda if you have convergence issues. Small value of delta_lambda is recommended.
    metric = (objective_function(lambda+delta_lambda) - objective_function(lambda-delta_lambda))/(2*delta_lambda);
    metric = abs(metric);
    % You can even change this metric as you please.
end