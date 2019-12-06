% Implementa el método de Romberg adaptado para usar Runge-Kutta.
%
% Parámetros:
% -----------
% f:        Puntero a la función que calcula Runge-Kutta de orden 4, 
%           tomando como parámetros los límites de la solución y el paso, 
%           el sistema que se resuelve está implicito en el puntero, es 
%           transparente para este método.
% a:        Inicio del intervalo de integración.
% b:        Fin del intervalo de integración.
% p:        Número de niveles.
% Salidas:
% --------
% I:        Valor de la integral aproximada.
function I = romberg_rk4(f, a, b, p)

% Calculo el paso que se usa en el último nivel de Romberg.
h_final = (b - a)/2^(p - 1);

% Llamo a Runge-Kutta de cuarto orden. Uso el paso mas pequeño del método.
% Aprovecho la relación de dos que existe entre el tamaño de paso en
% dos llamadaas sucesivas al método de integración de trapecios compuesto,
% de esta manera, solo necesito una llamada a Runge-Kutta y en cada 
% nivel, para trapecios simplemente salteo 2^(p - k) puntos, donde k es el
% número de nivel y p la cantidad de niveles de Romberg totales.

z = f(a, b, h_final);

I = zeros(p, p);

for k=1:p
    % llamo al método de los trapecios para 2^k pasos de integración.
    I(k,1) = trapezcomp_rk4(z, a, b, k, p);
    
    % Fórmula recursiva de Romberg.
    for j=1:k-1
        I(k,j+1) = (4^j * I(k,j) - I(k-1,j)) / (4^j - 1);
    end
    
end

end