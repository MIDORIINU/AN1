% Implementa el método de Romberg.
%
% Parámetros:
% -----------
% f:        Puntero a la función que cuya integral se desea aproximar.
% a:        Inicio del intervalo de integración.
% b:        Fin del intervalo de integración.
% p:        Número de filas.
% Salidas:
% --------
% I:        Valor de la integral aproximada.
function I = romberg_rk4(f, a, b, y0, numsol, p)

h_final = (b - a)/2^(p - 1);


[~, y] = rk4(f, [a (b + h_final)],...% Llamo a Runge-Kutta de cuarto orden.
    y0, h_final);                    % Uso el paso mas pequeño del método.
                                     % Aprovecho la relación de dos que
                                     % existe entre el tamaño de paso en
                                     % dos llamadaas sucesivas al método
                                     % de integración de trapcios compuesto.

z = abs(y(:,numsol)');

I = zeros(p, p);

for k=1:p
    % llamo al método de los trapecios para n = 2^k.
    I(k,1) = trapezcomp_rk4(z, a, b, k, p);
    
    % Fórmula recursiva de Romberg.
    for j=1:k-1
        I(k,j+1) = (4^j * I(k,j) - I(k-1,j)) / (4^j - 1);
    end
    
end

end