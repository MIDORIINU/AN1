% Implementa el TP2, declarando la variables necesarias y llamando a las
% respectivas funciones. Los gráficos son salvados en formato PNG en el
% correspodiente directorio del informe, también los resultados numéricos
% son salvados en el correspondiente directorio del informe, donde el
% código de Latex los levanta automáticamente para generar el archivo
% compilado final del informe.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Limpio todas las variables globales.
clear all;

% Cierro todos los gráficos.
close all;

% Determino si estoy trabajando en MATLAB u Octave.
Is_Octave = (5 == exist('OCTAVE_VERSION', 'builtin'));

% Determino el OS en el que estoy trabajando.
if (ismac)
    OS = 'Mac';
    % Mac plaform.
    % En general al igual que en Linux y otros Unix, se usa UTF-8, pero
    % no es necesariamente así.
elseif (isunix)
    OS = 'Linux';
    % Linux plaform.
    % En general se usa UTF-8, con lo que bastaría con codificar los
    % scripts en UTF-8 para que la codificación sea correcta.
elseif (ispc)
    OS = 'Windows';
    % Windows platform.
    % Esto es necesario mayormente para Octave en Windows, en MATLAB
    % CP1252 es el default. Los scripts deberían estar codificados
    % en CP1252.
    
    if (Is_Octave)
        major =  int8(str2double(substr(OCTAVE_VERSION, 1, ...
            index(OCTAVE_VERSION, ".") - 1)));
        
        if (major >= 5)
            [~, ~] = system ('chcp 65001');
        else
            [~, ~] = system('chcp 1252');
        end
        
    else
        [~, ~] = system('chcp 1252');
    end
    
else
    OS = 'Sistema desconocido';
end %if

% Limpio la línea de comando, para poder capturar la salida limpia.
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

% Defino el archivo para la captura de la salida del script.
output_file = './salida.txt';

% Detengo la captura de la salida del script.
diary off;

% Borro el archivo si existía previamente.
if (exist(output_file, 'file'))
    delete(output_file);
end

% Borro el archivo si existía previamente.
% if (exist('diary', 'file'))
%     delete('diary');
% end

% Inicio la captura de la salida.
diary on;

% Inicio la ejecución.
fprintf('Inicializando las variables globales para el TP2...');

% Declaro los colores a utilizar en los gráficos.
x1Color = [1 0 0];
x2Color = [0 1 0];

pColor = [0.1 0.4 0.95];

% Declaro el porcentaje de la panatalla que ocupan los gráficos.
graphic_size_percent = 75;

% Declaro el directorio para las imágenes.
images_directory = fullfile('..', 'informe', 'img');

% Declaro el directorio para los archivos ".csv".
results_directory = fullfile('..', 'informe', 'results');

% Declaro los nombres de los archivos a guardar.
grafico_respuesta_prefix = 'grafico_respuesta';
grafico_1 = '_1.png';
grafico_2 = '_2.png';
grafico_3 = '_3.png';

fprintf('Listo\n\n');

if (~Is_Octave) % Si estoy trabajando en MATLAB.
    env = 'MATLAB';
else            % Si estoy trabajando en Octave.
    env = 'Octave';
end %if

fprintf('Trabajando en: %s %s sobre %s.\n\n\n\n', env, version, OS);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

fprintf('Creando el directorio para las imágenes...');

% Creo el directorio para las imágenes y verifico que exista.
[~, ~, ~] = mkdir(images_directory);
success = (7 == exist(images_directory, 'dir'));

% Chequeo que el directorio para las imágenes exista.
if (~success)
    fprintf(strjoin({'\nNo se pudo crear ', ...
        'el directorio para las imágenes.\n\n'}, ''));
    
    exit;
else
    fprintf('Listo\n\n');
end

fprintf('Creando el directorio para los resultados numéricos...');

% Creo el directorio para los archivos numéricos y verifico que exista.
[~, ~, ~] = mkdir(results_directory);
success = (7 == exist(results_directory, 'dir'));

% Chequeo que el directorio para los archivos numéricos exista.
if (~success)
    fprintf(strjoin({'\nNo se pudo crear' , ...
        'el directorio para los resultados.\n\n'}, ''));
    
    exit;
else
    fprintf('Listo\n\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

format long;

while (1)
    
    % Tiempo final.
    tend = 20;
    
    % Masa.
    m = 1;
    
    % Longitud del hilo.
    l = 1;
    
    % Rozamiento.
    b = 1;
    
    % Paso.
    h = 0.0001;
    
    % Ángulo inicial.
    Theta_0 = pi/6;
    
    % Velocidad angular inicial.
    Omega_0 = 0;
    
    % En el caso de Octave, un valor muy chico causa problemas
    if (Is_Octave)
        h = 0.001;
    end
   
    answer = questdlg(strjoin({'¿Desea resolver el sistema', ...
        ' para otros parámetros?'}, ''), ...
        'Pregunta', 'Si', 'No', 'No');
    
    if ( ~strcmp('Si', answer))
        break;
    end %if       
    
    % Pido los datos para resolver el problema.
    answer = inputdlg({'Masa del péndulo [Kg]','Largo del hilo (m)', ...
        'Rozamiento [Kg/s]', 'Paso [s]', 'Ángulo inicial [rad]', ...
        'Velocidad angular inicial [rad/s]'},...
        'Parámetros del sistema', ...
        [1 50; 1 50; 1 50; 1 50; 1 50; 1 50], ...
        {num2str(m, 16) num2str(l, 16) num2str(b, 16) num2str(h, 16) ...
        num2str(Theta_0, 16) num2str(Omega_0, 16)});
    
    % Valido los datos.
    if (isempty(answer))  
        
        dlg = errordlg('Parámteros inválidos', 'Error', 'modal');
        
        uiwait(dlg);
        
        continue;
        
    end % if    
    
    m = str2double(answer{1});
    
    l = str2double(answer{2});
    
    b = str2double(answer{3});
    
    h = str2double(answer{4});
    
    Theta_0 = str2double(answer{5});
    
    Omega_0 = str2double(answer{6});
    
    % Valido los datos ingresados.
    if isnan(h) || isnan(b) || isnan(l) || isnan(m) || isnan(Theta_0) || ...
            isnan(Omega_0) || (b < 0) || (l <= 0) || (m <= 0) || ...
        ((Theta_0 == 0) && (Omega_0 == 0))
        
        dlg = errordlg('Parámteros inválidos', 'Error', 'modal');
        
        uiwait(dlg);
        
        continue;
        
    end %if
    
    % Resuelvo la ecuación del péndulo para los parámetros dados.
    [t, x, s] = pendulum(tend, h, b, l, m, Theta_0, Omega_0);
    
    if (~s)
        continue;
    end % fi
    
    close all; 
    
    % Genero el gráfico de las soluciones.
    plot_solution(t, x(:,1)', x(:,2)', 'Ángulo y velocidad angular', 100);
        
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% El script se ejecutó correctamente..
fprintf('\n\nEjecución del TP2 terminada.\n\n');

% Detengo la captura de la salida del script.
diary off;

% Copio el archivo de salida.
fprintf('Copiando el archivo de salida......');

[status, ~] = copyfile('diary', output_file);

% Chequeo que la copia se realizó correctamente.
if (~status)
    fprintf(strjoin({'\nFalló la copia', ...
        'del archivo de salida.\n\n'}));
    
    return;
else %if
    fprintf('Listo\n\n');
end %if

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return;

sz = size(x0_vals);

for i = 1:sz(1)
    
    fprintf(strjoin({'Calculando la estimación de'...
        'la solución del sistema con x1(0) = %.4f......'}), ...
        x0_vals(i, 1));
    
    [ts, xs] = lorenz(tend, step, x0_vals(i, :));
    
    % Cálculo completo.
    fprintf('Listo\n\n');
    
    if (i == 1)
        t = ts;
        x = xs;
    end % if
    
    title = sprintf(...
        'Serie de tiempo para x1 - con x1(0) = %.4f', ...
        x0_vals(i, 1));
    
    % Genero el gráfico de la órbita de la solución
    fprintf(strjoin({'Generando un gráfico de la serie de tiempo',...
        'para x1...'}));
    
    graphic_handle = plot_time_series(ts, xs(:,1), title, 'x1(t)', ...
        x1Color, graphic_size_percent);
    
    % Generación completa.
    fprintf('Listo\n\n');
    
    %%%
    time_series_complete_name = ...
        fullfile(images_directory, ...
        strjoin({grafico_time_series_prefix, 'x1_', ...
        sprintf('%d', i), ...
        '.png'}, ''));
    
    fprintf('Salvando el gráfico en un archivo "PNG"......');
    
    % Salvo el gráfico en un archivo.
    saveas(graphic_handle, time_series_complete_name);
    
    % Salvado completo.
    fprintf('Listo\n\n');
    %%%
    
    title = sprintf(...
        'Serie de tiempo para x2 - con x1(0) = %.4f', ...
        x0_vals(i, 1));
    
    % Genero el gráfico de la órbita de la solución
    fprintf(strjoin({'Generando un gráfico de la serie de tiempo',...
        'para x2...'}));
    
    graphic_handle = plot_time_series(ts, xs(:,2), title, 'x2(t)',...
        x2Color, graphic_size_percent);
    
    % Generación completa.
    fprintf('Listo\n\n');
    
    %%%
    time_series_complete_name = ...
        fullfile(images_directory, ...
        strjoin({grafico_time_series_prefix, 'x2_', ...
        sprintf('%d', i), ...
        '.png'}, ''));
    
    fprintf('Salvando el gráfico en un archivo "PNG"......');
    
    % Salvo el gráfico en un archivo.
    saveas(graphic_handle, time_series_complete_name);
    
    % Salvado completo.
    fprintf('Listo\n\n');
    %%%
    
    title = sprintf(...
        'Serie de tiempo para x3 - con x1(0) = %.4f', ...
        x0_vals(i, 1));
    
    % Genero el gráfico de la órbita de la solución
    fprintf(strjoin({'Generando un gráfico de la serie de tiempo',...
        'para x3...'}));
    
    graphic_handle = plot_time_series(ts, xs(:,3), title, 'x3(t)', ...
        x3Color, graphic_size_percent);
    
    % Generación completa.
    fprintf('Listo\n\n');
    
    %%%
    time_series_complete_name = ...
        fullfile(images_directory, ...
        strjoin({grafico_time_series_prefix, 'x3_', ...
        sprintf('%d', i), ...
        '.png'}, ''));
    
    fprintf('Salvando el gráfico en un archivo "PNG"......');
    
    % Salvo el gráfico en un archivo.
    saveas(graphic_handle, time_series_complete_name);
    
    % Salvado completo.
    fprintf('Listo\n\n');
    %%%
    
end % for

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% Genero el gráfico de la órbita de la solución
fprintf(strjoin({'Generando un gráfico de la órbita',...
    ' de la solución el intervalo...'}));

graphic_handle = plot_orbit(x, 'Órbita de la solución - Vista 1', ...
    axis_orientations(1, :), x1Color, x2Color, x3Color, pColor, ...
    graphic_size_percent);

% Generación completa.
fprintf('Listo\n\n');

fprintf('Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_handle, fullfile(images_directory, ...
    grafico_orbita_1));

% Salvado completo.
fprintf('Listo\n\n');

%%%%%

% Genero el gráfico de la órbita de la solución
fprintf(strjoin({'Generando un gráfico de la órbita',...
    ' de la solución el intervalo...'}));

graphic_handle = plot_orbit(x, 'Órbita de la solución - Vista 2', ...
    axis_orientations(2, :), x1Color, x2Color, x3Color, pColor, ...
    graphic_size_percent);

% Generación completa.
fprintf('Listo\n\n');

fprintf('Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_handle, fullfile(images_directory, ...
    grafico_orbita_2));

% Salvado completo.
fprintf('Listo\n\n');

%%%%%

% Genero el gráfico de la órbita de la solución
fprintf(strjoin({'Generando un gráfico de la órbita',...
    ' de la solución el intervalo...'}));

graphic_handle = plot_orbit(x, 'Órbita de la solución - Vista 3', ...
    axis_orientations(3, :), x1Color, x2Color, x3Color, pColor, ...
    graphic_size_percent);

% Generación completa.
fprintf('Listo\n\n');

fprintf('Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_handle, fullfile(images_directory, ...
    grafico_orbita_3));

% Salvado completo.
fprintf('Listo\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% El script se ejecutó correctamente..
fprintf('\n\nEjecución del TP2 terminada.\n\n');

% Detengo la captura de la salida del script.
diary off;

% Copio el archivo de salida.
fprintf('Copiando el archivo de salida......');

[status, ~] = copyfile('diary', output_file);

% Chequeo que la copia se realizó correctamente.
if (~status)
    fprintf(strjoin({'\nFalló la copia', ...
        'del archivo de salida.\n\n'}));
    
    return;
else %if
    fprintf('Listo\n\n');
end %if

