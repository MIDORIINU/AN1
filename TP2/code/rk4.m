% Implementa el método de Runge-Kutta de orden 4.
%
% Parámetros:
% -----------
% f:        Puntero a la función que toma un valor escalar y devuelve un
%           array de m valores correspondientes a las m funciones solución
%           del sistema a aproximar.
% tspan:    Array de dos valores con el valor inicial y final del
%           intervalo en el cual aproximar las funciones.
% y0:       Array de m valores iniciales para las funciones.
% step:     Paso deseado para el cálculo de las aproximaciones, el valor
%           finalmente usado puede que sea menor para acomodarse al
%           intervalo de aproximación.
%
% Salidas:
% --------
% t:        Vector con los valores de la variable independiente donde se
%           aproximó las m funciones solución del sistema en el intervalo.
% y:        Matriz de dimensión Nxm, donde N es la cantidad de puntos
%           de aproximación de las funciones dentro del intervalo y m la
%           cantidad de funciones del sistema, los valores de las filas
%           corresponden a las aproximaciones de las funciones solución
%           en los valores de la variable independiente correspondientes
%           al mismo índice en el array t.
%
function [t, y] = rk4(f, tspan, y0, step)

N = ceil((tspan(2) - tspan(1))/step); % Determino la cantidad de pasos.

h = (tspan(2) - tspan(1))/N;          % Adapto el paso al intervalo.

u = zeros(1, N);                      % Inicializo la variable
                                      % que contendrá los pasos
                                      % de la variable independiente.

u(1) = tspan(1);                      % Guardo el primer valor de
                                      % la variable independiente, que
                                      % corresponde al inicio del
                                      % intervalo.

m = length(y0);                       % Obtengo la cantidad de
                                      % funciones a estimar.

z = zeros(N, m);                      % Inicializo la matriz que
                                      % contendrá las estimaciones de
                                      % las m funciones solución.

z(1, : ) = y0;                        % Guardo los valores iniciales
                                      % en la matriz.

k = zeros(m, 4);                      % Inicializo la matriz que
                                      % contendrá los k de cada
                                      % iteración.

for i = 1:N-1    
    
    k(:, 1) = f(u(i), z(i, :));       % Calulo de la primera columna
                                      % de la matriz k, corresponde
                                      % a los k1 de las m funciones.
    
    k(:, 2) = f(u(i) + (1/2)*h, ...   % Calulo de la segunda columna
        z(i, :) + (1/2)*h*k(:, 1)');  % de la matriz k, corresponde
                                      % a los k2 de las m funciones.
    
    
    k(:, 3) = f((u(i) + (1/2)*h), ... % Calulo de la tercera columna
        (z(i, :) + (1/2)*h*k(:, 2)'));% de la matriz k, corresponde
                                      % a los k3 de las m funciones.
    
    k(:, 4) = f((u(i) + h),...        % Calulo de la cuarta columna
        (z(i, :) + k(:, 3)'*h));      % de la matriz k, corresponde
                                      % a los k4 de las m funciones.
    
    z(i+1, :) = z(i, :) +  ...        % Calculo el próximo valor
        (1/6)*(k(:, 1)' + ...         % de la variable independiente.
        2*k(:, 2)' + 2*k(:, 3)' + ...
        k(:, 4)')*h;    
    
    u(i + 1) = u(1) + i*h;            % Calculo el próximo valor de la
                                      % variable independiente.    
end% for

t = u;                                % Devuelvo los valores de la
                                      % variable independiente.

y = z;                                % Devuelvo la matriz de
                                      % estimaciones de las m
                                      % funciones solución del sistema.

end%function
