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
function I = romberg(f, a, b, p)

I = zeros(p, p);
for k=1:p
    % llamo al método de los trapecios para n = 2^k.
    I(k,1) = trapezcomp(f, a, b, 2^(k-1));
    
    % Fórmula recursiva de Romberg.
    for j=1:k-1
        I(k,j+1) = (4^j * I(k,j) - I(k-1,j)) / (4^j - 1);
    end
    
end

end