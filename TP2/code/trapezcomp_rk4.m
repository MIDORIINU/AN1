% Implementa el m�todo de Trapecios.
%
% Par�metros:
% -----------
% f:        Puntero a la funci�n que toma un valor escalar y devuelve un
%           array de m valores correspondientes a las m funciones
%           del sistema a aproximar e integrar una de las soluciones.
% a:        Inicio del intervalo de integraci�n.
% b:        Fin del intervalo de integraci�n.
% y0:       Array de m valores iniciales para las funciones.
% numsol:   �ndice de la funci�n soluci�n a integrar.
% n:        N�mero de paneles.
% Salidas:
% --------
% In:       Valor de la integral aproximada.
function In = trapezcomp_rk4(f, a, b, y0, numsol, n)

% Incializaci�n.
h = (b-a)/n;

%x = tspan(1);

[~, y] = rk4(f, [a (b + h)],... % Llamo a Runge-Kutta de cuarto orden.
    y0, h); 

z = abs(y(:, numsol))';

%Regla compuesta.
%In = z(1);
In = 0;

for k = 1:n
    In = In + 2*z(k);
end

In = (In + z(length(z))) * h * 0.5;

end