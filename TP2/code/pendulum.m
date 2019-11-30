% Resuelve el sistema del p�ndulo en el intervalo [0, tend] y con los 
% par�metros dados, o unos tomados por default.
%
% Par�metros:
% -----------
% tend:     Final del intervalo en el cual aproximar las funciones 
%           soluci�n del sistema (Se asume el inicio en 0).
% h:        Paso deseado para el c�lculo de las aproximaciones, el valor
%           finalmente usado puede que sea menor para acomodarse al
%           intervalo de aproximaci�n.
% b:        Coeficiente de rozamiento viscoso.
%           [Este par�metro es opcional, el default es 0 Kg/s].
% l:        Longitud del hilo.
%           [Este par�metro es opcional, el default es 1 m].
% m:        Masa del p�ndulo.
%           [Este par�metro es opcional, el default es 1 Kg].
% Theta_0:  �ngulo inicial.
%           [Este par�metro es opcional, el default es Pi/6 rad].
% Omega_0:  Velocidad angular inicial.
%           [Este par�metro es opcional, el default es 0 rad/s].
%
% Salidas:
% --------
% t:        Vector con los valores de la variable independiente donde se
%           aproxim� las m funciones soluci�n del sistema en el intervalo.
% x:        Matriz de dimensi�n Nx2, donde N es la cantidad de puntos
%           de aproximaci�n de las funciones dentro del intervalo los 
%           valores de las filas corresponden a las aproximaciones de las 
%           funciones soluci�n en los valores de la variable independiente 
%           correspondientes al mismo �ndice en el array t.
%
function [t, x, s] = pendulum(tend, h, b, l, m, Theta_0, Omega_0)

if (nargin < 2)
    fprintf(strjoin({'Error: ',...
        'Insuficientes ', ...
        'par�metros.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if    
    
if (tend < 0)
    fprintf(strjoin({'Error: ',...
        'Tiempo final ', ...
        'inv�lido.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if    
    
if (h >= tend/10) || (h <= 0)
    fprintf(strjoin({'Error: ',...
        'Paso ',...
        'inv�lido.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if
    
if (nargin < 3)                  % Aseguro de tener el valor si no se di�.
    b = 0;                       % Valor por omisi�n.
end %if

if (nargin < 4)                  % Aseguro de tener el valor si no se di�.
    l = 1;                       % Valor por omisi�n.
end %if

if (nargin < 5)                  % Aseguro de tener el valor si no se di�.
    m = 1;                       % Valor por omisi�n.
end %if

if (nargin < 6)                  % Aseguro de tener el valor si no se di�.
    Theta_0 = Pi/6;              % Valor por omisi�n.
end %if

if (nargin < 7)                  % Aseguro de tener el valor si no se di�.
    Omega_0 = 0;                 % Valor por omisi�n.
end %if


if isnan(h) || isnan(b) || isnan(l) || isnan(m) || isnan(Theta_0) || ...
        isnan(Omega_0) || (b < 0) || (l <= 0) || (m <= 0) || ...
        (Theta_0 == 0) || (Omega_0 < 0)
    fprintf(strjoin({'Error: ',...
        'Par�metros del p�ndulo ',...
        'inv�lidos.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if


g = 9.81;                        % Aceleraci�n de la gravedad.


f = @(t,x) [x(2); ...            % Sistema de dos ecuaciones del p�ndulo.
    -(b/m)*x(2)- ...
    (g/l)*sin(x(1))];              

[t, x] = rk4(f, [0 tend + h],... % Llamo a Runge-Kutta de curato orden.
    [Theta_0, Omega_0], h); 

s = 1;

end % function
