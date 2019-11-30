% Grafica la serie de tiempo para x.
%
% Par�metros:
% -----------
% t:        Vector con los valores de la variable independiente donde se
%           aproxim� las m funciones soluci�n del sistema en el intervalo.
% x:        Array de los valores de x correspodientes a la variable
%           independiente,t, a graficar.
% titulo:   T�tulo para el gr�fico.
% xilabel:  Label para la variable x.
% color:    Color del gr�fico.
% sz_perc:  Tama�o del gr�fico en porcentaje de la pantalla.
%
% Salidas:
% --------
% graphic_handle: Puntero al gr�fico.
%
function [graphic_handle] = plot_time_series(t, x, titulo, xilabel,...
    color, sz_perc)

if (nargin < 6)                  % Aseguro de tener un tama�o.
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

% Retengo los ejes.
hold(axes1,'on');

% Creo el gr�fico.
plot(t, x, 'Marker', '.', 'LineStyle', 'none', 'Color', color);

% Seteo el label para y.
ylabel(xilabel);

% Seteo el label para x.
xlabel('t');

% Seteo el t�tulo.
title(titulo);

% Muestro la "caja" que contiene al gr�fico.
box(axes1,'on');

% Seteo las dem�s propiedades.
set(axes1,'XGrid', 'on', 'XMinorTick', 'on', 'XTick',...
    [0 2 4 6 8 10 12 14 16 18 20 22 24 26 ...
    28 30 32 34 36 38 40 42 44 46 48 50],...
    'YGrid', 'on', 'YTick',...
    [-20 -18 -16 -14 -12 -10 -8 -6 -4 -2 ...
    0 2 4 6 8 10 12 14 16 18 20]);

% Asigno el valor del handle del gr�fico que devuelvo.
graphic_handle = figure1;
