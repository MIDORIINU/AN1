% Implementa el m�todo de Newton-Raphson.
%
% Par�metros:
% -----------
% f:        Puntero a la funci�n a la cual hallarle la ra�z.
% x0:       Aproximaci�n inicial, la semilla.
% delta:    Diferencia deseada entre dos aprximaciones sucesivas.
% max_iter: Cantidad m�xima de iteraciones a realizar, opcional.
% showwork: Decide si se muestra las iteraciones al calcularlas, es 0 o 1,
%           opcional.
%
% Salidas:
% --------
% r0:       Valor de la ra�z hallada con la precisi�n pedida, si se logra.
% delta_r0: Delta obtenido para la ra�z hallada.
% e_rel_r0: Error relativo para la ra�z hallada.
% table:    Tabla de salida con las iteraciones, contiene el n�mero de 
%           iteraci�n, el valor de la ra�z, el delta y el error relativo.
% success:  Si el m�todo fue exitoso, es 1 en caso de �xito y 0 en caso de 
%           fallar.
%
% En caso de fallo, las salidas num�ricas son NaN (Not a Number).
%
function [r0, delta_r0, e_rel_r0, table, success] = ...
         method_newton(f, x0, delta, max_iter, showwork)

if (nargin < 4)                 % Aseguro de tener corte si no se di�.
    max_iter = 1000;            % Valor por omisi�n.
end %if

if (nargin < 5)                 % Por omisi�n no muestro el progreso.
     showwork = 0; 
end %if  

delta = abs(delta);              % Aseguro que el error sea positivo.

syms x;                          % Defino x como variable simb�lica.
func = f(x);                     % Defino func como la funci�n puntero a f.
der_func = diff(func);           % Derivada simb�lica respecto de x

f_deriv = ...
     matlabFunction(der_func);   % Convierto la funci�n derivada simb�lica 
                                 % en una funci�n normal de MATLAB/Octave.

p0 = x0;                         % Guardo la semilla.

table_iter = zeros(max_iter, 4); % Inicializo la tabla de salida.
                                 % Contiene:
                                 % - N�mero de iteraci�n.
                                 % - Valor estimado de la ra�z.
                                 % - Error.
                                 % - Error relativo (%).

if (showwork)                    % Muestro el inicio del proceso.                   
    fprintf(strjoin({'\nUsando el m�todo',...
        'de Newton-Raphson para hallar la ra�z...\n\n'}));                                
end %if

for idx = 1 : max_iter
    
    p = p0 - f(p0)/f_deriv(p0);  % Calculo la pr�xima aproximaci�n.

    delta_iter = abs(p - p0);    % Calculo el error.
    
    e_relat_iter = ...
        delta_iter*100.0/p;      % Calculo el rror relativo.    
    
    table_iter(idx,:) = [idx; p; ...
        delta_iter; ...
        e_relat_iter];           % Guardo la iteraci�n en la tabla. 
    
    if (showwork)                % Muestro un mensaje si corresponde.
        fprintf(strjoin({'Iteraci�n %d, nuevo valor de x: %.15f,', ...
            'delta: %.15f, error relativo: %.15f\n\n'}), ...
            idx, p, delta_iter, e_relat_iter);
    end %if   
    
    if (delta_iter < delta)      % Comparo el error con el deseado. 
        
        r0 = p;                  % Guardo el valor de la ra�z.
        
        delta_r0 = delta_iter;   % Guardo el delta de l ra�z.
        
        e_rel_r0 = e_relat_iter; % Guardo el error relativo de la ra�z.
        
        table = ...
            table_iter(1:idx,:); % Asigno la tabla recortada.

        success = 1;             % Indico que el m�todo fue exitoso.        
        
        if (showwork)            % Muestro un mensaje si corresponde.
            fprintf(strjoin({'\nLa ra�z se hall� exitosamente por', ...
                'el m�todo de Newton-Raphson,', ...
                'despu�s de %d iteraciones.\n\n'}), idx);
        end %if
        
        return;                  % Salgo de la funci�n.
    end %if

    p0 = p;                      % Guardo el valor para la pr�xima iter.
end %for

r0 = NaN;                        % Guardo un valor no v�lido
                                 % para la ra�z.

delta_r0 = NaN;                  % Guardo un valor no v�lido para el delta.

e_rel_r0 = NaN;                  % Guardo un valor no v�lido 
                                 % para el error relativo.

table = [];                      % Guardo una tabla vac�a.

success = 0;                     % Indico que el m�todo fall�.

if (showwork)                    % Muestro un mensaje si corresponde.
    error(strjoin({'\nFall� el m�todo de Newton-Raphson', ...
        'despu�s de %d iteraciones.\n\n'}), max_iter);
end %if

end %for
