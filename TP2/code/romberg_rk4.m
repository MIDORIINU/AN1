% Implementa el m�todo de Romberg.
%
% Par�metros:
% -----------
% f:        Puntero a la funci�n que toma un valor escalar y devuelve un
%           array de m valores correspondientes a las m funciones
%           del sistema a aproximar e integrar una de las soluciones.
% a:        Inicio del intervalo de integraci�n.
% b:        Fin del intervalo de integraci�n..
% y0:       Array de m valores iniciales para las funciones.
% numsol:   �ndice de la funci�n soluci�n a integrar.
% p:        N�mero de filas de Romberg.
% Salidas:
% --------
% I:        Valor de la integral aproximada.
function I = romberg_rk4(f, a, b, y0, numsol, p)


h_final = (b-a)/(2^(p-1));


[~, y] = rk4(f, [a (b + h)],... % Llamo a Runge-Kutta de cuarto orden.
    y0, h); 



I = zeros(p, p);

for k = 1:p
    % llamo al m�todo de los trapecios para n = 2^k.
    I(k,1) = trapezcomp_rk4(f, a, b, y0, numsol, 2^(k-1));
    
    % F�rmula recursiva de Romberg.
    for j = 1:k-1
        I(k,j+1) = (4^j * I(k,j) - I(k-1,j)) / (4^j - 1);
    end
    
end

end