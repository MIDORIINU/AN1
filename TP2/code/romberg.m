function I = romberg(f, a, b, p)
% Romberg integration
%
%    INPUTS:
%    f:  the function to integrate
%    a:  lower bound of integration
%    b:  upper bound
%    p:  number of rows in the Romberg table

I = zeros(p, p);
for k=1:p
    % Composite trapezoidal rule for 2^k panels
    I(k,1) = trapezcomp(f, a, b, 2^(k-1));
    
    % Romberg recursive formula
    for j=1:k-1
        I(k,j+1) = (4^j * I(k,j) - I(k-1,j)) / (4^j - 1);
    end
    
end

end