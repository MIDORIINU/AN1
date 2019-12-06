% Initialise step-size variables
h = 0.2;
t = (0:h:20)';
N = length(t);

% Initialise vectors
x = zeros(N,1);    y = zeros(N,1); 
% Starting conditions
x(1) = pi/6;     y(1) = 0;   

% Initialise derivative functions
dx = @(t, x, y) y;                  % dx = x' = dx/dt
dy = @(t, x, y) -y - 9.81*sin(x);   % dy = y' = dy/dt


% Initialise K vectors
kx = zeros(1,4); % to store K values for x
ky = zeros(1,4); % to store K values for y

b = [1 2 2 1];   % RK4 coefficients

% Iterate, computing each K value in turn, then the i+1 step values
for i = 1:(N-1)        
    kx(1) = dx(t(i), x(i), y(i));
    ky(1) = dy(t(i), x(i), y(i));


    kx(2) = dx(t(i) + (h/2), x(i) + (h/2)*kx(1), y(i) + (h/2)*ky(1));
    ky(2) = dy(t(i) + (h/2), x(i) + (h/2)*kx(1), y(i) + (h/2)*ky(1));


    kx(3) = dx(t(i) + (h/2), x(i) + (h/2)*kx(2), y(i) + (h/2)*ky(2));
    ky(3) = dy(t(i) + (h/2), x(i) + (h/2)*kx(2), y(i) + (h/2)*ky(2));


    kx(4) = dx(t(i) + h, x(i) + h*kx(3), y(i) + h*ky(3));
    ky(4) = dy(t(i) + h, x(i) + h*kx(3), y(i) + h*ky(3));


    x(i+1) = x(i) + (h/6)*sum(b.*kx);       
    y(i+1) = y(i) + (h/6)*sum(b.*ky);       
     
end    

% Group together in one solution matrix
txy = [t,x,y]

plot(t, x);


