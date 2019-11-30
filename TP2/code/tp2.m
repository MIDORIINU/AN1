% Implementa el TP2, declarando la variables necesarias y llamando a las
% respectivas funciones. Los gr�ficos son salvados en formato PNG en el
% correspodiente directorio del informe, tambi�n los resultados num�ricos
% son salvados en el correspondiente directorio del informe, donde el
% c�digo de Latex los levanta autom�ticamente para generar el archivo
% compilado final del informe.
%%

% Limpio todas las variables globales.
clear all;

% Cierro todos los gr�ficos.
close all;

% Limpio la l�nea de comando.
clc;

% Determino si estoy trabajando en MATLAB u Octave.
Is_Octave = (5 == exist('OCTAVE_VERSION', 'builtin'));

% Determino el OS en el que estoy trabajando.
if (ismac)
    OS = 'Mac';
    % Mac plaform.
    % En general al igual que en Linux y otros Unix, se usa UTF-8, pero
    % no es necesariamente as�.
elseif (isunix)
    OS = 'Linux';
    % Linux plaform.
    % En general se usa UTF-8, con lo que bastar�a con codificar los
    % scripts en UTF-8 para que la codificaci�n sea correcta.
elseif (ispc)
    OS = 'Windows';
    % Windows platform.
    % Esto es necesario mayormente para Octave en Windows, en MATLAB
    % es el default. Los scripts deber�an estar codificados en CP1252.
    [~, ~] = system('chcp 1252');
else
    OS = 'Sistema desconocido';
end %if

% Limpio la l�nea de comando, para poder capturar la salida limpia.
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

% Defino el archivo para la captura de la salida del script.
output_file = './salida.txt';

% Detengo la captura de la salida del script.
diary off;

% Borro el archivo si exist�a previamente.
if (exist(output_file, 'file'))
    delete(output_file);
end

% Borro el archivo si exist�a previamente.
if (exist('diary', 'file'))
    delete('diary');
end

% Inicio la captura de la salida.
diary on;

% Inicio la ejecuci�n.
fprintf('Inicializando las variables globales para el TP2...');

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

% �ngulo inicial.
Theta_0 = pi/6;

% Velocidad angular inicial.
Omega_0 = 0;

% En el caso de Octave, un valor muy chico causa problemas
if (Is_Octave)
    h = 0.001;
end


% Declaro los colores a utilizar en los gr�ficos.
x1Color = [1 0 0];
x2Color = [0 1 0];

pColor = [0.1 0.4 0.95];

% Declaro el porcentaje de la panatalla que ocupan los gr�ficos.
graphic_size_percent = 75;

% Declaro el directorio para las im�genes.
images_directory = fullfile('..', 'informe', 'img');

% Declaro el directorio para los archivos ".csv".
results_directory = fullfile('..', 'informe', 'results');

% Declaro los nombres de los archivos a guardar.
grafico_time_series_prefix = 'grafico_time_series_';
grafico_orbita_1 = 'grafico_orbita_1.png';
grafico_orbita_2 = 'grafico_orbita_2.png';
grafico_orbita_3 = 'grafico_orbita_3.png';

fprintf('Listo\n\n');

if (~Is_Octave) % Si estoy trabajando en MATLAB.
    env = 'MATLAB';
else            % Si estoy trabajando en Octave.
    env = 'Octave';
end %if

fprintf('Trabajando en: %s %s sobre %s.\n\n\n\n', env, version, OS);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

fprintf('Creando el directorio para las im�genes...');

% Creo el directorio para las im�genes y verifico que exista.
[~, ~, ~] = mkdir(images_directory);
success = (7 == exist(images_directory, 'dir'));

% Chequeo que el directorio para las im�genes exista.
if (~success)
    fprintf(strjoin({'\nNo se pudo crear', ...
        'el directorio para las im�genes.\n\n'}));
    
    exit;
else
    fprintf('Listo\n\n');
end

fprintf('Creando el directorio para los resultados num�ricos...');

% Creo el directorio para los archivos num�ricos y verifico que exista.
[~, ~, ~] = mkdir(results_directory);
success = (7 == exist(results_directory, 'dir'));

% Chequeo que el directorio para los archivos num�ricos exista.
if (~success)
    fprintf(strjoin({'\nNo se pudo crear', ...
        'el directorio para los resultados.\n\n'}));
    
    exit;
else
    fprintf('Listo\n\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

format long;


while (1)
    
    opts.Interpreter = 'tex';
    opts.Default = 'No';
    
    answer = questdlg(strjoin({'�Desea resolver el sistema', ...
        ' para otros par�metros?'}, ''), ...
        'Pregunta', 'Si', 'No', opts);
    
    if ( ~strcmp('Si', answer))
        fprintf('Calculo cancelado.\n');
        break;
    end %if
    
    
    
    answer = inputdlg({'Masa del p�ndulo [Kg]','Largo del hilo (m)', ...
        'Rozamiento [Kg/s]', 'Paso [s]', '�ngulo inicial [rad]', ...
        'Velocidad angular inicial [rad/s]'},...
        'Par�metros del sistema', ...
        [1 50; 1 50; 1 50; 1 50; 1 50; 1 50], ...
        {num2str(m, 16) num2str(l, 16) num2str(b, 16) num2str(h, 16) ...
        num2str(Theta_0, 16) num2str(Omega_0, 16)});
    
    
    if (isempty(answer))
        fprintf('Calculo cancelado por error.\n');
        break;
    end % if
    
    
    
    m = str2double(answer{1});
    
    l = str2double(answer{2});
    
    b = str2double(answer{3});
    
    h = str2double(answer{4});
    
    Theta_0 = str2double(answer{5});
    
    Omega_0 = str2double(answer{6}); 
    
    [t, x, s] = pendulum(tend, h, b, l, m, Theta_0, Omega_0);
    
     if (~s)
         continue;
     end % fi
    
    close all; plot(t, x(:,1)'); hold; plot(t, x(:,2)'); hold off;
    
end





return;

sz = size(x0_vals);

for i = 1:sz(1)
    
    fprintf(strjoin({'Calculando la estimaci�n de'...
        'la soluci�n del sistema con x1(0) = %.4f......'}), ...
        x0_vals(i, 1));
    
    [ts, xs] = lorenz(tend, step, x0_vals(i, :));
    
    % C�lculo completo.
    fprintf('Listo\n\n');
    
    if (i == 1)
        t = ts;
        x = xs;
    end % if
    
    title = sprintf(...
        'Serie de tiempo para x1 - con x1(0) = %.4f', ...
        x0_vals(i, 1));
    
    % Genero el gr�fico de la �rbita de la soluci�n
    fprintf(strjoin({'Generando un gr�fico de la serie de tiempo',...
        'para x1...'}));
    
    graphic_handle = plot_time_series(ts, xs(:,1), title, 'x1(t)', ...
        x1Color, graphic_size_percent);
    
    % Generaci�n completa.
    fprintf('Listo\n\n');
    
    %%%
    time_series_complete_name = ...
        fullfile(images_directory, ...
        strjoin({grafico_time_series_prefix, 'x1_', ...
        sprintf('%d', i), ...
        '.png'}, ''));
    
    fprintf('Salvando el gr�fico en un archivo "PNG"......');
    
    % Salvo el gr�fico en un archivo.
    saveas(graphic_handle, time_series_complete_name);
    
    % Salvado completo.
    fprintf('Listo\n\n');
    %%%
    
    title = sprintf(...
        'Serie de tiempo para x2 - con x1(0) = %.4f', ...
        x0_vals(i, 1));
    
    % Genero el gr�fico de la �rbita de la soluci�n
    fprintf(strjoin({'Generando un gr�fico de la serie de tiempo',...
        'para x2...'}));
    
    graphic_handle = plot_time_series(ts, xs(:,2), title, 'x2(t)',...
        x2Color, graphic_size_percent);
    
    % Generaci�n completa.
    fprintf('Listo\n\n');
    
    %%%
    time_series_complete_name = ...
        fullfile(images_directory, ...
        strjoin({grafico_time_series_prefix, 'x2_', ...
        sprintf('%d', i), ...
        '.png'}, ''));
    
    fprintf('Salvando el gr�fico en un archivo "PNG"......');
    
    % Salvo el gr�fico en un archivo.
    saveas(graphic_handle, time_series_complete_name);
    
    % Salvado completo.
    fprintf('Listo\n\n');
    %%%
    
    title = sprintf(...
        'Serie de tiempo para x3 - con x1(0) = %.4f', ...
        x0_vals(i, 1));
    
    % Genero el gr�fico de la �rbita de la soluci�n
    fprintf(strjoin({'Generando un gr�fico de la serie de tiempo',...
        'para x3...'}));
    
    graphic_handle = plot_time_series(ts, xs(:,3), title, 'x3(t)', ...
        x3Color, graphic_size_percent);
    
    % Generaci�n completa.
    fprintf('Listo\n\n');
    
    %%%
    time_series_complete_name = ...
        fullfile(images_directory, ...
        strjoin({grafico_time_series_prefix, 'x3_', ...
        sprintf('%d', i), ...
        '.png'}, ''));
    
    fprintf('Salvando el gr�fico en un archivo "PNG"......');
    
    % Salvo el gr�fico en un archivo.
    saveas(graphic_handle, time_series_complete_name);
    
    % Salvado completo.
    fprintf('Listo\n\n');
    %%%
    
end % for

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% Genero el gr�fico de la �rbita de la soluci�n
fprintf(strjoin({'Generando un gr�fico de la �rbita',...
    ' de la soluci�n el intervalo...'}));

graphic_handle = plot_orbit(x, '�rbita de la soluci�n - Vista 1', ...
    axis_orientations(1, :), x1Color, x2Color, x3Color, pColor, ...
    graphic_size_percent);

% Generaci�n completa.
fprintf('Listo\n\n');

fprintf('Salvando el gr�fico en un archivo "PNG"......');

% Salvo el gr�fico en un archivo.
saveas(graphic_handle, fullfile(images_directory, ...
    grafico_orbita_1));

% Salvado completo.
fprintf('Listo\n\n');

%%%%%

% Genero el gr�fico de la �rbita de la soluci�n
fprintf(strjoin({'Generando un gr�fico de la �rbita',...
    ' de la soluci�n el intervalo...'}));

graphic_handle = plot_orbit(x, '�rbita de la soluci�n - Vista 2', ...
    axis_orientations(2, :), x1Color, x2Color, x3Color, pColor, ...
    graphic_size_percent);

% Generaci�n completa.
fprintf('Listo\n\n');

fprintf('Salvando el gr�fico en un archivo "PNG"......');

% Salvo el gr�fico en un archivo.
saveas(graphic_handle, fullfile(images_directory, ...
    grafico_orbita_2));

% Salvado completo.
fprintf('Listo\n\n');

%%%%%

% Genero el gr�fico de la �rbita de la soluci�n
fprintf(strjoin({'Generando un gr�fico de la �rbita',...
    ' de la soluci�n el intervalo...'}));

graphic_handle = plot_orbit(x, '�rbita de la soluci�n - Vista 3', ...
    axis_orientations(3, :), x1Color, x2Color, x3Color, pColor, ...
    graphic_size_percent);

% Generaci�n completa.
fprintf('Listo\n\n');

fprintf('Salvando el gr�fico en un archivo "PNG"......');

% Salvo el gr�fico en un archivo.
saveas(graphic_handle, fullfile(images_directory, ...
    grafico_orbita_3));

% Salvado completo.
fprintf('Listo\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% El script se ejecut� correctamente..
fprintf('\n\nEjecuci�n del TP2 terminada.\n\n');

% Detengo la captura de la salida del script.
diary off;

% Copio el archivo de salida.
fprintf('Copiando el archivo de salida......');

[status, ~] = copyfile('diary', output_file);

% Chequeo que la copia se realiz� correctamente.
if (~status)
    fprintf(strjoin({'\nFall� la copia', ...
        'del archivo de salida.\n\n'}));
    
    return;
else %if
    fprintf('Listo\n\n');
end %if

