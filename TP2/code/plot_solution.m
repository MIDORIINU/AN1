% Grafica el ángulo y la velocidad angular.
%
% Parámetros:
% -----------
% t:        Vector con los valores de la variable independiente donde se
%           aproximó las  funciones solución del sistema en el intervalo.
% Theta:    Array de los valores de ángulo correspodientes a la variable
%           independiente,t, a graficar.
% Omega:    Array de los valores de la velocidad angular 
%           correspodientes a la variable independiente,t, a graficar.
% titulo:   Título para el gráfico.
% sz_perc:  Tamaño del gráfico en porcentaje de la pantalla.
%
% Salidas:
% --------
% graphic_handle: Puntero al gráfico.
%
function [graphic_handle] = plot_solution(t, Theta, Omega, titulo, sz_perc)

if (nargin < 5)                  % Aseguro de tener un tamaño.
    sz_perc = 50;                % Valor por omisión.
end %if

if (sz_perc < 10.0)              % Ajusto el tamaño de salida.
    sz_perc = 10.0;
elseif (sz_perc > 100.0)
    sz_perc = 100.0;
end % if

% Calculo el tamaño y la posición de la imagen.
pict_size = sz_perc/100;
pict_pos = (1 - pict_size)/2;

% Genero la figura, a un % del tamaño de la panatalla y centrada.
% No parece funcionar en Octave, pero no genera errores tampoco.
figure1 = figure('units', 'normalized', 'outerposition', ...
    [pict_pos pict_pos pict_size pict_size]);

% Seteo el color de fondo para el gráfico.
set(figure1, 'Color', [1 1 1]);

% Creo los ejes.
axes1 = axes('Parent', figure1);

% Activo eje izquierdo.
yyaxis(axes1, 'left');

% Creo el gráfico de Theta.
plot(axes1, t, Theta, 'Color', [1 0 0]);

% Seteo el label para y.
ylabel(axes1, '\Theta [rad]');

% Seteo el label para x.
xlabel(axes1, 'Tiempo [s]');

% Seteo el título.
title(axes1, titulo);

% Labels inclinados.
xtickangle(axes1, 75);

% Límites para las abcisas.
xlim(axes1, [t(1) t(length(t))]);

% Determino los límites.
maxy = max([abs(min(Theta)) abs(max(Theta))]);

% Ticks para el eje y izquierdo.
yticks1 = (-1.1*maxy : 1.1*maxy/5 : 1.1*maxy);

% Límites para el eje y izquierdo.
ylim(axes1, [yticks1(1) yticks1(length(yticks1))]);

% Muestro la "caja" que contiene al gráfico.
box(axes1,'on');

% Set the remaining axes properties
set(axes1, 'FontSize',14, 'XGrid','on','XMinorTick','on','XTick',...
    (t(1): 0.5: t(length(t))),...
    'YGrid','on','YMinorTick','on','YTick',...
    yticks1, 'TickLabelInterpreter','tex');

% Retengo los ejes.
hold(axes1, 'on');

% Activo eje izquierdo.
yyaxis(axes1, 'right');

% Seteo el label para y.
ylabel(axes1, '\Omega [rad/s]');

% Determino los límites.
maxy = max([abs(min(Omega)) abs(max(Omega))]);

% Ticks para el eje y izquierdo.
yticks2 = (-1.1*maxy : 1.1*maxy/5 : 1.1*maxy);

% Límites para el eje y izquierdo.
ylim(axes1, [yticks2(1) yticks2(length(yticks2))]);

% Creo el gráfico de Omega.
plot(axes1, t, Omega, 'Color', [0 0 1]);

% Set the remaining axes properties
set(axes1, 'FontSize',14, ...
    'YGrid','on','YMinorTick','on','YTick',...
    yticks2, 'TickLabelInterpreter','tex');

% Seteo color de los ejes.
axes1.YAxis(1).Color = [1 0 0];
axes1.YAxis(2).Color = [0 0 1];


% Asigno el valor del handle del gráfico que devuelvo.
graphic_handle = figure1;
