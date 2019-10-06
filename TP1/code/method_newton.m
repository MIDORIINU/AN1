% Implementa el método de Newton-Raphson.
%
% Parámetros:
% -----------
% f:        Puntero a la función a la cual hallarle la raíz.
% x0:       Aproximación inicial, la semilla.
% delta:    Diferencia deseada entre dos aprximaciones sucesivas.
% max_iter: Cantidad máxima de iteraciones a realizar, opcional.
% showwork: Decide si se muestra las iteraciones al calcularlas, es 0 o 1,
%           opcional.
%
% Salidas:
% --------
% r0:       Valor de la raíz hallada con la precisión pedida, si se logra.
% delta_r0: Delta obtenido para la raíz hallada.
% e_rel_r0: Error relativo para la raíz hallada.
% table:    Tabla de salida con las iteraciones, contiene el número de 
%           iteración, el valor de la raíz, el delta y el error relativo.
% success:  Si el método fue exitoso, es 1 en caso de éxito y 0 en caso de 
%           fallar.
%
% En caso de fallo, las salidas numéricas son NaN (Not a Number).
%
function [r0, delta_r0, e_rel_r0, table, success] = ...
         method_newton(f, x0, delta, max_iter, showwork)

if (nargin < 4)                 % Aseguro de tener corte si no se dió.
    max_iter = 1000;            % Valor por omisión.
end %if

if (nargin < 5)                 % Por omisión no muestro el progreso.
     showwork = 0; 
end %if  

delta = abs(delta);              % Aseguro que el error sea positivo.

syms x;                          % Defino x como variable simbólica.
func = f(x);                     % Defino func como la función puntero a f.
der_func = diff(func);           % Derivada simbólica respecto de x

f_deriv = ...
     matlabFunction(der_func);   % Convierto la función derivada simbólica 
                                 % en una función normal de MATLAB/Octave.

p0 = x0;                         % Guardo la semilla.

table_iter = zeros(max_iter, 4); % Inicializo la tabla de salida.
                                 % Contiene:
                                 % - Número de iteración.
                                 % - Valor estimado de la raíz.
                                 % - Error.
                                 % - Error relativo (%).

if (showwork)                    % Muestro el inicio del proceso.                   
    fprintf(strjoin({'\nUsando el método',...
        'de Newton-Raphson para hallar la raíz...\n\n'}));                                
end %if

for idx = 1 : max_iter
    
    p = p0 - f(p0)/f_deriv(p0);  % Calculo la próxima aproximación.

    delta_iter = abs(p - p0);    % Calculo el error.
    
    e_relat_iter = ...
        delta_iter*100.0/p;      % Calculo el rror relativo.    
    
    table_iter(idx,:) = [idx; p; ...
        delta_iter; ...
        e_relat_iter];           % Guardo la iteración en la tabla. 
    
    if (showwork)                % Muestro un mensaje si corresponde.
        fprintf(strjoin({'Iteración %d, nuevo valor de x: %.15f,', ...
            'delta: %.15f, error relativo: %.15f\n\n'}), ...
            idx, p, delta_iter, e_relat_iter);
    end %if   
    
    if (delta_iter < delta)      % Comparo el error con el deseado. 
        
        r0 = p;                  % Guardo el valor de la raíz.
        
        delta_r0 = delta_iter;   % Guardo el delta de l raíz.
        
        e_rel_r0 = e_relat_iter; % Guardo el error relativo de la raíz.
        
        table = ...
            table_iter(1:idx,:); % Asigno la tabla recortada.

        success = 1;             % Indico que el método fue exitoso.        
        
        if (showwork)            % Muestro un mensaje si corresponde.
            fprintf(strjoin({'\nLa raíz se halló exitosamente por', ...
                'el método de Newton-Raphson,', ...
                'después de %d iteraciones.\n\n'}), idx);
        end %if
        
        return;                  % Salgo de la función.
    end %if

    p0 = p;                      % Guardo el valor para la próxima iter.
end %for

r0 = NaN;                        % Guardo un valor no válido
                                 % para la raíz.

delta_r0 = NaN;                  % Guardo un valor no válido para el delta.

e_rel_r0 = NaN;                  % Guardo un valor no válido 
                                 % para el error relativo.

table = [];                      % Guardo una tabla vacía.

success = 0;                     % Indico que el método falló.

if (showwork)                    % Muestro un mensaje si corresponde.
    error(strjoin({'\nFalló el método de Newton-Raphson', ...
        'después de %d iteraciones.\n\n'}), max_iter);
end %if

end %for
