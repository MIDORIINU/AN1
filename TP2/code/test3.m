% f = @(t,x) ...                   % EDO test.
%     [-x(2); ...
%     x(1)];

clc;


tend = 20;

%h = 0.001;

Theta_0 = pi/6;

Omega_0 = 5*pi/9;

b = 0.5;

l = 1;

m = 1;



%[t, x] = ode45(f, [0 tend], x0); % Runge-Kutta.

%[t, x, s] = pendulum(tend);

% if (~s)
%     return;
% end % fi
% 
% close all; plot(t, x(:,1)'); hold; plot(t, x(:,2)'); hold off;
% 
% [t ; x']'

%figure


%fi = @(y) interp1(t, abs(x(:,1)'),  y, 'spline');


%points=0:0.01:tend;

%rpoints=fi(points);

%plot(points, rpoints);

%plot_time_series(points, rpoints, 'Módulo de la posición', '', [0,0.7,0.9], 100);


%romberg(fi, 0, 20, 15)


g = 9.81;                        % Aceleración de la gravedad.


p = 15;

h = (tend-0)/(2^(p-1));

f = @(t,x) [x(2); ...            % Sistema de dos ecuaciones del péndulo.
    -(b/m)*x(2)- ...
    (g/l)*sin(x(1))];              


% 
% f = @(t,x) [x(2); ...            % Sistema de dos ecuaciones del péndulo.
%     -(b/m)*x(2)- ...
%     (g/l)*(x(1))];  


 [t, x] = rk4(f, [0 tend + h],... % Llamo a Runge-Kutta de cuarto orden.
     [Theta_0, Omega_0], h); 
 
 
 
 
 res = cumtrapz(h, abs(x(:,1)'));
 
 res(length(res))
 
 
 %fi = @(y) interp1(t, abs(x(:,1)'),  y, 'spline');
 
 
 
 %integral(fi, 0, 20)
 
 
 %k = p;
 
%res = trapezcomp_rk4(abs(x(:,1)'), 0, tend, k, p)



%  
%  res(length(res))


f_sol = @(a, b, step) ...
    abs(f_rk4_num_sol(f, [a, b], [Theta_0, Omega_0], step, 1));


%f = @(t,x) -5*x;


res = romberg_rk4(f_sol, 0, tend, p);

%res = romberg_rk4(f, 0, tend, 1, 1, p);

res(p, p)

