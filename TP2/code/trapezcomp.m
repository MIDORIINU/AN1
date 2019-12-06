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
function In = trapezcomp(f, a, b, n)

% Incializaci�n.
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