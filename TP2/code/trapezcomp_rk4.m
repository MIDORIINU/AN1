% Implementa el m�todo de Trapecios adaptado para usar Runge-Kutta.
%
% Par�metros:
% -----------
% x:        Array con los puntos de la funci�n a la cual calcular la
%           aproximaci�n de la integral, contiene 2^(p - 1) + 1 puntos,
%           pero salteo de a 2^(p - k), usando efectivamente 2^(k - 1) + a
%           puntos en el c�lculo.
% a:        Inicio del intervalo de integraci�n.
% b:        Fin del intervalo de integraci�n.
% n:        N�mero de paneles.
% Salidas:
% --------
% In:       Valor de la integral aproximada.
function In = trapezcomp_rk4(x, a, b, k, p)

% Incializaci�n.
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