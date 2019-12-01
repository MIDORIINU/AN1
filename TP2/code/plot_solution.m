% Grafica el �ngulo y la velocidad angular.
%
% Par�metros:
% -----------
% t:        Vector con los valores de la variable independiente donde se
%           aproxim� las  funciones soluci�n del sistema en el intervalo.
% Theta:    Array de los valores de �ngulo correspodientes a la variable
%           independiente,t, a graficar.
% Omega:    Array de los valores de la velocidad angular 
%           correspodientes a la variable independiente,t, a graficar.
% titulo:   T�tulo para el gr�fico.
% sz_perc:  Tama�o del gr�fico en porcentaje de la pantalla.
%
% Salidas:
% --------
% graphic_handle: Puntero al gr�fico.
%
function [graphic_handle] = plot_solution(t, Theta, Omega, titulo, sz_perc)

if (nargin < 5)                  % Aseguro de tener un tama�o.
    sz_perc = 50;                % Valor por omisi�n.
end %if

if (sz_perc < 10.0)              % Ajusto el tama�o de salida.
    sz_perc = 10.0;
elseif (sz_perc > 100.0)
    sz_perc = 100.0;
end % if

% Calculo el tama�o y la posici�n de la imagen.
pict_size = sz_perc/100;
pict_pos = (1 - pict_size)/2;

% Genero la figura, a un % del tama�o de la panatalla y centrada.
% No parece funcionar en Octave, pero no genera errores tampoco.
figure1 = figure('units', 'normalized', 'outerposition', ...
    [pict_pos pict_pos pict_size pict_size]);

% Seteo el color de fondo para el gr�fico.
set(figure1, 'Color', [1 1 1]);

% Creo los ejes.
axes1 = axes('Parent', figure1);

% Activo eje izquierdo.
yyaxis(axes1, 'left');

% Creo el gr�fico de Theta.
plot(axes1, t, Theta, 'Color', [1 0 0]);

% Seteo el label para y.
ylabel(axes1, '\Theta [rad]');

% Seteo el label para x.
xlabel(axes1, 'Tiempo [s]');

% Seteo el t�tulo.
title(axes1, titulo);

% Labels inclinados.
xtickangle(axes1, 75);

% L�mites para las abcisas.
xlim(axes1, [t(1) t(length(t))]);

% Determino los l�mites.
maxy = max([abs(min(Theta)) abs(max(Theta))]);

% Ticks para el eje y izquierdo.
yticks1 = (-1.1*maxy : 1.1*maxy/5 : 1.1*maxy);

% L�mites para el eje y izquierdo.
ylim(axes1, [yticks1(1) yticks1(length(yticks1))]);

% Muestro la "caja" que contiene al gr�fico.
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

% Determino los l�mites.
maxy = max([abs(min(Omega)) abs(max(Omega))]);

% Ticks para el eje y izquierdo.
yticks2 = (-1.1*maxy : 1.1*maxy/5 : 1.1*maxy);

% L�mites para el eje y izquierdo.
ylim(axes1, [yticks2(1) yticks2(length(yticks2))]);

% Creo el gr�fico de Omega.
plot(axes1, t, Omega, 'Color', [0 0 1]);

% Set the remaining axes properties
set(axes1, 'FontSize',14, ...
    'YGrid','on','YMinorTick','on','YTick',...
    yticks2, 'TickLabelInterpreter','tex');

% Seteo color de los ejes.
axes1.YAxis(1).Color = [1 0 0];
axes1.YAxis(2).Color = [0 0 1];


% Asigno el valor del handle del gr�fico que devuelvo.
graphic_handle = figure1;
