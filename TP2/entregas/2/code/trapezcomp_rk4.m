% Implementa el método de Trapecios adaptado para usar Runge-Kutta.
%
% Parámetros:
% -----------
% x:        Array con los puntos de la función a la cual calcular la
%           aproximación de la integral, contiene 2^(p - 1) + 1 puntos,
%           pero salteo de a 2^(p - k), usando efectivamente 2^(k - 1) + a
%           puntos en el cálculo.
% a:        Inicio del intervalo de integración.
% b:        Fin del intervalo de integración.
% n:        Número de paneles.
% Salidas:
% --------
% In:       Valor de la integral aproximada.
function In = trapezcomp_rk4(x, a, b, k, p)

% Incialización.
h = (b-a)/(2^(k-1));

loop_step = 2^(p - k);
loop_start = 1 + loop_step;
loop_finish = 2^(p-1);

%Regla compuesta.
In = x(1);

for j=loop_start:loop_step:loop_finish
    In = In + 2 * x(j);
end

In = (In + x(length(x))) * h * 0.5;

end