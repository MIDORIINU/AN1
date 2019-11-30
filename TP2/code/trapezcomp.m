function In = trapezcomp(f, a, b, n)
%    Composite trapezoidal function integration
%
%    INPUTS:
%    f:  the function to integrate
%    a:  lower bound of integration
%    b:  upper bound
%    n:  number of panels to create between ``a`` and ``b``

% Initialization
h = (b-a)/n;
x = a;

% Composite rule
In =f(a);
for k=2:n
    x  = x + h;
    In = In + 2. * f(x);
end
In = (In + f(b)) * h * 0.5;

end