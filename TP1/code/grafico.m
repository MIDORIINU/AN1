% Grafica la funci�n pasada por par�metro con el t�tulo dado.
%
% Par�metros:
% f:              Puntero a la funci�n a graficar.
% a:              Inicio del intervalo.
% b:              Fin del intervalo.
% cantpuntos:     Cantidad de puntos usados.
% tit:            T�tulo del gr�fico.
% leyenda:        Leyenda en el gr�fico.
% raiz:           Muestra una ra�z aproximada gr�ficamente, o no.
% color:          Color usado para trazar el gr�fico.
% size_percent:   Porcentaje del tama�o de la pantalla a ocupar.
%
% Salidas:
% graphic_handle: Puntero al gr�fico.
%
function [graphic_handle] = grafico(f, a, b, cantpuntos, titulo, ...
    leyenda, raiz, color, size_percent)

% Determino si estoy trabajando en MATLAB u Octave.
Is_Octave = (5 == exist('OCTAVE_VERSION', 'builtin'));

if (nargin < 8)                  % Aseguro de tener un tama�o.
    size_percent = 50;           % Valor por omisi�n.
end %if

if (size_percent < 10.0)         % Ajusto el tama�o de salida.
    size_percent = 10.0;
elseif (size_percent > 100.0)
    size_percent = 100.0;
end % if

% Genero los puntos de la variable x.
x = linspace(a, b, cantpuntos);

% Calculo los puntos de la funci�n.
y = f(x);

% Calculo el tama�o y la posici�n de la imagen.
pict_size = size_percent/100;
pict_pos = (1 - pict_size)/2;

% Genero la figura, a un % del tama�o de la panatalla y centrada.
% No parece funcionar en Octave, pero no genera errores tampoco.
figure1 = figure('units', 'normalized', 'outerposition', ...
    [pict_pos pict_pos pict_size pict_size]);

% Oculto la figura.
set(figure1, 'Visible', 'off');

% Genero los ejes.
axes1 = axes('Parent', figure1);

% Retengo los ejes actuales.
hold(axes1,'on');

% Grafico.
hplot = plot(x, y, 'DisplayName', leyenda,'Color', color);

% Incoropor el t�tulo.
title(titulo);

% Muestro los ejes.
box(axes1, 'on');

ylims = ylim;

% Seteo el resto de las propiedades de los ejes.
set(axes1,'FontSize',7,'XGrid','on','XMinorGrid','on','XMinorTick','on',...
    'XTick',a:(b-a)/20:b,'YTick',ylims(1):(ylims(2)-ylims(1))/20:ylims(2),...
    'YGrid','on','YMinorGrid','on','YMinorTick','on');

% Genero una leyenda para el gr�fico.
legend1 = legend(axes1, 'show');

set(legend1,...
    'Position',[0.84219042650382 0.76675052301329 ...
    0.0401041662630937 0.0197300099200053]);

if (raiz)  
    
    % Busco la ra�z aproximada, como el menor valor de la
    % funci�n en valor absoluto dentro del vector y.
    root_index = 1;
    min_y = realmax;
    for i = 1:length(y)
        val = abs(y(i));
        if (val < min_y)
            root_index = i;
            min_y = val;
        end %if
    end %for
    
    if (~Is_Octave) % Si estoy trabajando en MATLAB.
        
        %Creo un DataTip para la ra�z aproximada gr�ficamente.
        
        % Genero el t�tulo para el datatip.
        strtip = 'Ra�z aproximada gr�ficamente:\n';
        
        % Actualizo la figura.
        drawnow update;
        
        % Inicio el modo cursor.
        cursorMode = datacursormode(figure1);
        
        % Seteo la funci�n customizada usada para actualizar el datatip.
        set(cursorMode, 'UpdateFcn', @myUpdateFcn, 'Enable', 'on')
        
        % Genero el datatip.
        hDatatip = cursorMode.createDatatip(hplot);
        
        % set the datatip marker appearance
        set(hDatatip, 'Marker', 'x', 'MarkerSize', 10, 'MarkerFaceColor', ...
            'none', 'MarkerEdgeColor', 'r', 'OrientationMode', 'manual')
        
        % Set the data-tip orientation to top-right rather than auto
        set(hDatatip,'Orientation','bottomright');
        
        % Genero la pocisi�n para el datatip.
        pos = [x(root_index) y(root_index)];
        
        % Muevo el datatip a la posici�n deseada.
        % Para Matlab R2014a y anteriores es necesario lo siguiente.
        % set(get(hDatatip, 'DataCursor'), 'DataIndex', index, ...
        %     'TargetPoint', pos)
        set(hDatatip, 'Position', pos);
        
        % Actualizo los cursores.
        updateDataCursors(cursorMode);
        
        % Finalizo el modo cursor.
        set(cursorMode, 'enable', 'off');
        
    else            % Si estoy trabajando en Octave.
        
        % Actualizo la figura.
        drawnow;
        
        % Marco un punto sobre el gr�fico.
        plot(x(root_index), y(root_index), 'rx');
    end %if
    
    %Pix_SS = get(0,'screensize');
    
    % ScreenWidth = Pix_SS(2);
    %
    % ScreenHeight= Pix_SS(2);
    %
    % set(figure1, 'Position', ...
    %     [0, 0, round(ScreenWidth/2), round(ScreenHeight/2)]);
    
    
end

% Muestro la figura.
set(figure1, 'Visible', 'on');

% Asigno el valor del handle del gr�fico que devuelvo.
graphic_handle = figure1;

% Funci�n customizada para los datatips.
% Imprime un datatip customizado solo en MATLAB.
    function outText = myUpdateFcn(~, event)
        point = get(event, 'Position');
        
        outText = {sprintf(strtip), ...
            sprintf('X: %.6f', point(1)), ...
            sprintf('Y: %.6f', point(2))};
    end %function

end %function

