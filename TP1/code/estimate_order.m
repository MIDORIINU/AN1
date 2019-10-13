% Aproxima el orden de convergencia y la constante asintótica para un
% método numérico de busqueda de soluciones\raíces usando las últimas
% 4 aproximaciones encontradas.
% Se devuelven también los valores intermedios de los cálculos.
%
% Parámetros:
% f:               Puntero a la función a la que se aplicó el método.
% val1-val4:       Cuatro últimas aproximaciones del método.
%
% Salidas:
% order:           Orden de convergencia estimado.
% asintconst:      Constante asintótica estimada.
% asintconstder:   Constante asintótica estimada con la derivada de f.
% asintconstder2:  Constante asintótica estimada con la derivada 2da de f.
% interm1-interm6: Valores intermedios del cálculo.
%
%
function [order, asintconst, asintconstder, asintconstder2, ...
    interm1, interm2, interm3, ...
    interm4, interm5, interm6] = estimate_order(f, val1, val2, val3, val4)

% Calcula:
%
% order =
% log(abs(val4 - val3/val3 - val2))/log(abs(val3 - val2/val2 - val1))
%
% asintconst =
% abs(val4 - val3)/abs(val3 - val2)^order
%

interm1 = val4 - val3;

interm2 = val3 - val2;

interm3 = val2 - val1;

interm4 = log(abs(interm1/interm2));

interm5 = log(abs(interm2/interm3));

order = interm4/interm5;

interm6 = abs(interm2)^(round(order*10)/10);

asintconst = abs(interm1)/interm6;

% Calcula:
%
% asintconstder = abs(f'(val4))

syms x;                          % Defino x como variable simbólica.
func = f(x);                     % Defino func como la función puntero a f.
der_func = diff(func);           % Derivada simbólica respecto de x
der2_func = diff(der_func);      % Derivada 2da simbólica respecto de x



f_deriv = ...
    matlabFunction(der_func);   % Convierto la función derivada simbólica
% en una función normal de MATLAB/Octave.

f_deriv2 = ...
    matlabFunction(...
    der2_func, 'vars', x);     % Convierto la función derivada 2da
% simbólica en una función normal de
% MATLAB/Octave.

if isempty(symvar(der2_func))
    valaux = f_deriv2();
else
    valaux = f_deriv2(val4);
end


asintconstder = abs(f_deriv(val4));

asintconstder2 = valaux/(2*f_deriv(val4));

end %function

