% f = @(t,x) ...                   % EDO test.
%     [-x(2); ...
%     x(1)];

clc;


tend = 20;

h = 0.001;

Theta_0 = pi/6;

Omega_0 = 0;

b = 1;

l = 1;

m = 1;



%[t, x] = ode45(f, [0 tend], x0); % Runge-Kutta.

[t, x, s] = pendulum(tend);

if (~s)
    return;
end % fi

close all; plot(t, x(:,1)'); hold; plot(t, x(:,2)'); hold off;

[t ; x']'

%figure


fi = @(y) interp1(t, abs(x(:,1)'),  y, 'spline');


points=0:0.01:tend;

rpoints=fi(points);

%plot(points, rpoints);

plot_time_series(points, rpoints, 'Módulo de la posición', '', [0,0.7,0.9], 100);


romberg(fi, 0, 20, 15)


integral(fi, 0, 20)





%[t, x] = test(2*pi, 0.0001, [1 1]);

%plot(x(:,1),x(:,2));




%[t, x] = test(20, 0.0001, [pi/6 0]);

%close all; plot(t, x(:,1)'); hold; plot(t, x(:,2)');