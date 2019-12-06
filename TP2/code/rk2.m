% Implementa el m�todo de Runge-Kutta de orden 2 (punto medio).
%
% Par�metros:
% -----------
% f:        Puntero a la funci�n que toma un valor escalar y devuelve un
%           array de m valores correspondientes a las m funciones soluci�n
%           del sistema a aproximar.
% tspan:    Array de dos valores con el valor inicial y final del
%           intervalo en el cual aproximar las funciones.
% y0:       Array de m valores iniciales para las funciones.
% step:     Paso deseado para el c�lculo de las aproximaciones, el valor
%           finalmente usado puede que sea menor para acomodarse al
%           intervalo de aproximaci�n.
%
% Salidas:
% --------
% t:        Vector con los valores de la variable independiente donde se
%           aproxim� las m funciones soluci�n del sistema en el intervalo.
% y:        Matriz de dimensi�n Nxm, donde N es la cantidad de puntos
%           de aproximaci�n de las funciones dentro del intervalo y m la
%           cantidad de funciones del sistema, los valores de las filas
%           corresponden a las aproximaciones de las funciones soluci�n
%           en los valores de la variable independiente correspondientes
%           al mismo �ndice en el array t.
%
function [t, y] = rk2(f, tspan, y0, step)

N = ceil((tspan(2) - tspan(1))/step); % Determino la cantidad de pasos.

h = (tspan(2) - tspan(1))/N;          % Adapto el paso al intervalo.

u = zeros(1, N);                      % Inicializo la variable
                                      % que contendr� los pasos
                                      % de la variable independiente.

u(1) = tspan(1);                      % Guardo el primer valor de
                                      % la variable independiente, que
                                      % corresponde al inicio del
                                      % intervalo.

m = length(y0);                       % Obtengo la cantidad de
                                      % funciones a estimar.

z = zeros(N, m);                      % Inicializo la matriz que
                                      % contendr� las estimaciones de
                                      % las m funciones soluci�n.

z(1, : ) = y0;                        % Guardo los valores iniciales
                                      % en la matriz.

k = zeros(m, 2);                      % Inicializo la matriz que
                                      % contendr� los k de cada
                                      % iteraci�n.

for i = 1:N-1
    
    k(:, 1) = f(u(i), z(i, :));       % Calulo de la primera columna
                                      % de la matriz k, corresponde
                                      % a los k1 de las m funciones.
    
    k(:, 2) = f(u(i) + (h/2), ...     % Calulo de la segunda columna
        z(i, :) + (1/2)*h*k(:, 1)');  % de la matriz k, corresponde
                                      % a los k2 de las m funciones.
    
    z(i + 1, :) = ...                 % Calculo la pr�xima fila de la
        z(i, :) + h*k(:, 2)';         % matriz de aproximaciones,
                                      % corresponde a la estimaci�n en
                                      % i+1 de las m funciones.
    
    u(i + 1) = u(1) + i*h;            % Calculo el pr�ximo valor de la
                                      % variable independiente.
    
end % for

t = u;                                % Devuelvo los valores de la
                                      % variable independiente.

y = z;                                % Devuelvo la matriz de
                                      % estimaciones de las m
                                      % funciones soluci�n del sistema.

end %function
