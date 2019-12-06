% Implementa el m�todo de Trapecios.
%
% Par�metros:
% -----------
% f:        Puntero a la funci�n que cuya integral se desea aproximar.
% a:        Inicio del intervalo de integraci�n.
% b:        Fin del intervalo de integraci�n.
% n:        N�mero de paneles.
% Salidas:
% --------
% In:       Valor de la integral aproximada.
function In = trapezcomp_rk4(x, a, b, k, p)

% Incializaci�n.
h = (b-a)/(2^(k-1));
%s = a;


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