% Implementa el método de Trapecios.
%
% Parámetros:
% -----------
% f:        Puntero a la función que cuya integral se desea aproximar.
% a:        Inicio del intervalo de integración.
% b:        Fin del intervalo de integración.
% n:        Número de paneles.
% Salidas:
% --------
% In:       Valor de la integral aproximada.
function In = trapezcomp(f, a, b, n)

% Incialización.
h = (b-a)/n;
x = a;

%Regla compuesta.
In =f(a);

for k=2:n
    x  = x + h;
    In = In + 2. * f(x);
end
In = (In + f(b)) * h * 0.5;

end