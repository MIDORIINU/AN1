% Resuelve el sistema del péndulo en el intervalo [0, tend] y con los 
% parámetros dados, o unos tomados por default.
%
% Parámetros:
% -----------
% tend:     Final del intervalo en el cual aproximar las funciones 
%           solución del sistema (Se asume el inicio en 0).
% h:        Paso deseado para el cálculo de las aproximaciones, el valor
%           finalmente usado puede que sea menor para acomodarse al
%           intervalo de aproximación.
% b:        Coeficiente de rozamiento viscoso.
%           [Este parámetro es opcional, el default es 0 Kg/s].
% l:        Longitud del hilo.
%           [Este parámetro es opcional, el default es 1 m].
% m:        Masa del péndulo.
%           [Este parámetro es opcional, el default es 1 Kg].
% Theta_0:  Ángulo inicial.
%           [Este parámetro es opcional, el default es Pi/6 rad].
% Omega_0:  Velocidad angular inicial.
%           [Este parámetro es opcional, el default es 0 rad/s].
%
% Salidas:
% --------
% t:        Vector con los valores de la variable independiente donde se
%           aproximó las m funciones solución del sistema en el intervalo.
% x:        Matriz de dimensión Nx2, donde N es la cantidad de puntos
%           de aproximación de las funciones dentro del intervalo los 
%           valores de las filas corresponden a las aproximaciones de las 
%           funciones solución en los valores de la variable independiente 
%           correspondientes al mismo índice en el array t.
%
function [t, x, s] = pendulum(tend, h, b, l, m, Theta_0, Omega_0)

if (nargin < 2)
    fprintf(strjoin({'Error: ',...
        'Insuficientes ', ...
        'parámetros.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if    
    
if (tend < 0)
    fprintf(strjoin({'Error: ',...
        'Tiempo final ', ...
        'inválido.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if    
    
if (h >= tend/10) || (h <= 0)
    fprintf(strjoin({'Error: ',...
        'Paso ',...
        'inválido.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if
    
if (nargin < 3)                  % Aseguro de tener el valor si no se dió.
    b = 0;                       % Valor por omisión.
end %if

if (nargin < 4)                  % Aseguro de tener el valor si no se dió.
    l = 1;                       % Valor por omisión.
end %if

if (nargin < 5)                  % Aseguro de tener el valor si no se dió.
    m = 1;                       % Valor por omisión.
end %if

if (nargin < 6)                  % Aseguro de tener el valor si no se dió.
    Theta_0 = Pi/6;              % Valor por omisión.
end %if

if (nargin < 7)                  % Aseguro de tener el valor si no se dió.
    Omega_0 = 0;                 % Valor por omisión.
end %if


if isnan(h) || isnan(b) || isnan(l) || isnan(m) || isnan(Theta_0) || ...
        isnan(Omega_0) || (b < 0) || (l <= 0) || (m <= 0) || ...
        (Theta_0 == 0) || (Omega_0 < 0)
    fprintf(strjoin({'Error: ',...
        'Parámetros del péndulo ',...
        'inválidos.\n'}, ''));
    t = [];
    x = [];
    s = 0;
    return;
end %if


g = 9.81;                        % Aceleración de la gravedad.


f = @(t,x) [x(2); ...            % Sistema de dos ecuaciones del péndulo.
    -(b/m)*x(2)- ...
    (g/l)*sin(x(1))];              

[t, x] = rk4(f, [0 tend + h],... % Llamo a Runge-Kutta de curato orden.
    [Theta_0, Omega_0], h); 

s = 1;

end % function
