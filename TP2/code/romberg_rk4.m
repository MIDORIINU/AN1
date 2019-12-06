% Implementa el m�todo de Romberg.
%
% Par�metros:
% -----------
% f:        Puntero a la funci�n que cuya integral se desea aproximar.
% a:        Inicio del intervalo de integraci�n.
% b:        Fin del intervalo de integraci�n.
% p:        N�mero de filas.
% Salidas:
% --------
% I:        Valor de la integral aproximada.
function I = romberg_rk4(f, a, b, y0, numsol, p)

h_final = (b - a)/2^(p - 1);


[~, y] = rk4(f, [a (b + h_final)],...% Llamo a Runge-Kutta de cuarto orden.
    y0, h_final);                    % Uso el paso mas peque�o del m�todo.
                                     % Aprovecho la relaci�n de dos que
                                     % existe entre el tama�o de paso en
                                     % dos llamadaas sucesivas al m�todo
                                     % de integraci�n de trapcios compuesto.

z = abs(y(:,numsol)');

I = zeros(p, p);

for k=1:p
    % llamo al m�todo de los trapecios para n = 2^k.
    I(k,1) = trapezcomp_rk4(z, a, b, k, p);
    
    % F�rmula recursiva de Romberg.
    for j=1:k-1
        I(k,j+1) = (4^j * I(k,j) - I(k-1,j)) / (4^j - 1);
    end
    
end

end