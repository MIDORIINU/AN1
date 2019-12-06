% Implementa el m�todo de Romberg adaptado para usar Runge-Kutta.
%
% Par�metros:
% -----------
% f:        Puntero a la funci�n que calcula Runge-Kutta de orden 4, 
%           tomando como par�metros los l�mites de la soluci�n y el paso, 
%           el sistema que se resuelve est� implicito en el puntero, es 
%           transparente para este m�todo.
% a:        Inicio del intervalo de integraci�n.
% b:        Fin del intervalo de integraci�n.
% p:        N�mero de niveles.
% Salidas:
% --------
% I:        Valor de la integral aproximada.
function I = romberg_rk4(f, a, b, p)

% Calculo el paso que se usa en el �ltimo nivel de Romberg.
h_final = (b - a)/2^(p - 1);

% Llamo a Runge-Kutta de cuarto orden. Uso el paso mas peque�o del m�todo.
% Aprovecho la relaci�n de dos que existe entre el tama�o de paso en
% dos llamadaas sucesivas al m�todo de integraci�n de trapecios compuesto,
% de esta manera, solo necesito una llamada a Runge-Kutta y en cada 
% nivel, para trapecios simplemente salteo 2^(p - k) puntos, donde k es el
% n�mero de nivel y p la cantidad de niveles de Romberg totales.

z = f(a, b, h_final);

I = zeros(p, p);

for k=1:p
    % llamo al m�todo de los trapecios para 2^k pasos de integraci�n.
    I(k,1) = trapezcomp_rk4(z, a, b, k, p);
    
    % F�rmula recursiva de Romberg.
    for j=1:k-1
        I(k,j+1) = (4^j * I(k,j) - I(k-1,j)) / (4^j - 1);
    end
    
end

end