
% Call the function
[optima, optimum] = quasi_newton_method(@f);

function [optima, optimum] = quasi_newton_method(objective_function)
    x = -1.0;
    dx = 0.01;
    grad = 1.0;
    count = 0;
    
    while abs(grad) > 1E-3
        grad = (objective_function(x+dx) - objective_function(x-dx))/(2*dx);
        hess = (objective_function(x+dx) - 2*objective_function(x) + objective_function(x-dx))/(dx^2);
        x = x - grad/hess;
        disp(x)
        
        count = count + 1;
        
        if count > 20
            fprintf('breaking')
            break   
        else
            fprintf("count: %d", count)
        end
    end
    
    optima = x;
    optimum = objective_function(x);
end

function [val] = f(x)
    val = exp(abs(x));
end