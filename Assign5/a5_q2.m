
% Call the function
[optima, optimum] = newton_method(@f, @grad, @hess);

function [optima, optimum] = newton_method(objective_function, grad, hess)
    
    x = 5;
    count = 0;
    
    while abs(grad(x)) > 1E-3
        x = x - grad(x)/hess(x);
        disp(x)
        count = count + 1;
        
        if count > 15
            break
        end
    end
    
    optima = x;
    optimum = objective_function(x);
    
    disp(count)

end

function [val] = f(x)
    val = exp(abs(x));
end

% Gradient
function [val] = grad(x)
    val = sign(x) * exp(sign(x) * abs(x));

end

% Curvature/hessian
function [val] = hess(x)
    val = exp(sign(x) * abs(x));
end