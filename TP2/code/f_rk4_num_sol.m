% Esta función auxiliar solo se usa para generar un handle a función
% que lleva implicito un sistema de ecuaciones diferenciales a resolver
% por Runge-Kutta 4 y sus parámetros, excepto el intervalo y el paso. 
%
% Parámetros:
% -----------
% f:        Puntero a la función que toma un valor escalar y devuelve un
%           array de m valores correspondientes a las m funciones
%           del sistema a aproximar.
% tspan:    Array de dos valores con el valor inicial y final del
%           intervalo en el cual aproximar las funciones.
% y0:       Array de m valores iniciales para las funciones.
% step:     Paso deseado para el cálculo de las aproximaciones, el valor
%           finalmente usado puede que sea menor para acomodarse al
%           intervalo de aproximación.
% numsol:   Índice de la solución del sistema a devolver.
%
% Salidas:
% --------
% sol:       atriz de dimensión Nxm, donde N es la cantidad de puntos
%           de aproximación de las funciones dentro del intervalo y m la
%           cantidad de funciones del sistema, los valores de las filas
%           corresponden a las aproximaciones de las funciones solución
%           en los valores de la variable independiente correspondientes
%           al mismo índice en el array t.
function sol=f_rk4_num_sol(f, tspan, y0, step, numsol)

[~, temp] = rk4(f, tspan, y0, step);

sol = temp(:, numsol)';

end
