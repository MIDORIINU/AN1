% Implementa la cantidad pasos de bisecci�n pedidos.
%
% Par�metros:
% f:           Puntero a la funci�n a la cual hallarle el intervalo
%              para la ra�z.
% a0:          L�mite inferior inicial.
% b0:          L�mite superiro inicial.
% delta:       Diferencia deseada entre dos aprximaciones sucesivas.
% max_iter:    Cantidad m�xima de iteraciones a realizar, opcional.
%
% Salidas:
% a:           Inicio del intervalo.
% b:           Fin del intervlo.
% success:     Si el m�todo fue exitoso, es 1 en caso de �xito y 0 en caso
%              de fallar.
%
% En caso de fallo, las salidas num�ricas son NaN (Not a Number).
%
function [a, b, success] = method_bisection(f, a0, b0, delta, max_iter)

if (nargin < 5)        % Aseguro de tener corte si no se di�.
    max_iter = 1000;   % Valor por omisi�n.
end %if

delta = abs(delta);    % Aseguro que el error sea positivo.


if ((a0 > b0) || (f(a0)*f(b0) > 0))
    
    success = 0;
    
    b = NaN;           % Asigno un valor no v�lido para el fin del
    % intervalo.
    
    a = NaN;           % Asigno un valor no v�lido para el inicio del
    % intervalo.
    
    return;
end

a = a0;
b = b0;


for ii = 1:max_iter
    
    delta_iter = b - a;
    
    if (delta_iter < delta)      % Comparo el error con el deseado.
        break;
    end
    
    center = (b + a)/2;
    
    if (f(center)*f(a) > 0)
        a = center;
    else
        b = center;
    end
    
end


success = 1;           % Indico �xito.

end %function

