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

% Declaro el directorio para las imágenes.
images_directory = fullfile('..', 'informe', 'img');

% Declaro el directorio para los archivos ".csv".
results_directory = fullfile('..', 'informe', 'results');

% Declaro los nombres de los archivos a guardar.
grafico_respuesta_prefix = 'grafico_respuesta';
grafico_1 = '_1';
grafico_2 = '_2.png';
solutions_prefix = 'valores_respuesta';
respuesta_1 = '_1';
respuesta_2 = '_2';

% Tiempo final.
tend = 20;

% Cantidad de filas para Romberg.
romberg_levels = 10;

% En el caso de Ocatve reduzco los nivels porque es menos eficiente y
% tarda demasiado.
if (Is_Octave)
    romberg_levels = 6;
end % if

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

% Seteo el formato de números por pantalla.
format long;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Cálculo para el primer juego de parámetros.

fprintf(strjoin({'Calculando la estimación de '...
    'la solución del sistema con m = 1Kg, l = 1m, ' ...
    'b = 0Ns/m, h = 0.2s, Theta0 = pi/6, Omega0 = 0...'}, ''));

% Resuelvo la ecuación del péndulo para los parámetros dados.
% tend, h, b, l, m, Theta_0, Omega_0
[t, x, ~] = pendulum(tend, 0.2, 0, 1, 1, pi/6, 0);

% Generación completa.
fprintf('Listo\n\n');

% Guardo los resultados en un archivo.
fprintf('Salvando los resultados en un archivo "CSV"......');

% Armo la tabla de resultados finales con:
% 1 - Tiempo.
% 2 - Theta.
% 3 - d(Theta)/dt.
results = [t', x(:,1), x(:,2)];

% Guardo la tabla de las iteraciones.
dlmwrite(fullfile(results_directory, ...
    strjoin({solutions_prefix, respuesta_1, '.csv'}, '')), ...
    results, 'precision', '%.15f');

% Guardado completo.
fprintf('Listo\n\n');

% Genero el gráfico de la  solución.
fprintf('Generando un gráfico de la solución...');

graphic_handle1 = ...
    plot_solution(t, x(:,1)', x(:,2)', 'Ángulo y velocidad', 100);

% Generación completa.
fprintf('Listo\n\n');

%%%
solution_complete_name = ...
    fullfile(images_directory, ...
    strjoin({grafico_respuesta_prefix, grafico_1, ...
    '.png'}, ''));

fprintf('Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_handle1, solution_complete_name);

% Salvado completo.
fprintf('Listo\n\n');
%%%

fprintf('Calculando la integral del módulo de la posición......');

% Genero la función del módulo interpolada usando spline.
fint = @(y) interp1(t, abs(x(:,1)'),  y, 'spline');

% Calculo la integral usando Romberg.
I_romb = romberg(fint, 0, tend, romberg_levels);

% Listo.
fprintf('Listo\n\n');

fprintf(strjoin({'El valor de la integral aproximada con Romberg del ' ...
    'módulo de la posición es: %.16f.\n\n'}, ''), ...
    I_romb(size(I_romb,1), size(I_romb,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Cálculo para el segundo juego de parámetros.

fprintf(strjoin({'Calculando la estimación de '...
    'la solución del sistema con m = 1Kg, l = 1m, ' ...
    'b = 0.5Ns/m, h = 0.2s, Theta0 = pi/6, Omega0 = 5*pi/6...'}, ''));

% Resuelvo la ecuación del péndulo para los parámetros dados.
% tend, h, b, l, m, Theta_0, Omega_0
[t, x, s] = pendulum(tend, 0.2, 0.5, 1, 1, pi/6, 5*pi/6);

% Generación completa.
fprintf('Listo\n\n');

% Guardo los resultados en un archivo.
fprintf('Salvando los resultados en un archivo "CSV"......');

% Armo la tabla de resultados finales con:
% 1 - Tiempo.
% 2 - Theta.
% 3 - d(Theta)/dt.
results = [t', x(:,1), x(:,2)];

% Guardo la tabla de las iteraciones.
dlmwrite(fullfile(results_directory, ...
    strjoin({solutions_prefix, respuesta_2, '.csv'}, '')), ...
    results, 'precision', '%.15f');

% Guardado completo.
fprintf('Listo\n\n');

% Genero el gráfico de la  solución.
fprintf('Generando un gráfico de la solución...');

graphic_handle2 = ...
    plot_solution(t, x(:,1)', x(:,2)', 'Ángulo y velocidad', 100);

% Generación completa.
fprintf('Listo\n\n');

%%%
solution_complete_name = ...
    fullfile(images_directory, ...
    strjoin({grafico_respuesta_prefix, grafico_2, ...
    '.png'}, ''));

fprintf('Salvando el gráfico en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_handle2, solution_complete_name);

% Salvado completo.
fprintf('Listo\n\n');
%%%

fprintf('Calculando la integral del módulo de la posición......');

% Genero la función del módulo interpolada usando spline.
fint = @(y) interp1(t, abs(x(:,1)'),  y, 'spline');

% Calculo la integral usando Romberg.
I_romb = romberg(fint, 0, tend, romberg_levels);

% Listo.
fprintf('Listo\n\n');

fprintf(strjoin({'El valor de la integral aproximada con Romberg del ' ...
    'módulo de la posición es: %.16f.\n\n'}, ''), ...
    I_romb(size(I_romb,1), size(I_romb,2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Cálculo para parámetros dados por el usuario.

while (1)
    
    % Ingreso los valores iniciales.
    
    % Masa.
    m = 1;
    
    % Longitud del hilo.
    l = 1;
    
    % Rozamiento.
    b = 0.5;
    
    % Paso.
    h = 0.001;
    
    % Ángulo inicial.
    Theta_0 = pi/6;
    
    % Velocidad angular inicial.
    Omega_0 = 5*pi/6;
    
    % En el caso de Octave, un valor muy chico causa problemas
    if (Is_Octave)
        h = 0.01;
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
    
    fprintf(strjoin({'Calculando la estimación de '...
        'la solución del sistema...'}, ''));
    
    % Resuelvo la ecuación del péndulo para los parámetros dados.
    [t, x, s] = pendulum(tend, h, b, l, m, Theta_0, Omega_0);
    
    if (~s)
        continue;
    end % fi
    
    % Listo.
    fprintf('Listo\n\n');
    
    if exist('graphic_handle', 'var') == 1
        % Cierro el gráfico previo.
        close(graphic_handle);
    end
    
    % Genero el gráfico de la  solución.
    fprintf('Generando un gráfico de la solución...');
    
    % Genero el gráfico de las soluciones.
    graphic_handle = plot_solution(t, x(:,1)', x(:,2)', ...
        'Ángulo y velocidad', 100);
    
    % Listo.
    fprintf('Listo\n\n');

    
    
    fprintf('Calculando la integral del módulo de la posición......');
    
    % Genero la función del módulo interpolada usando spline.
    fint = @(y) interp1(t, abs(x(:,1)'),  y, 'spline');
    
    % Calculo la integral usando Romberg.
    I_romb = romberg(fint, 0, tend, romberg_levels);
    
    % Listo.
    fprintf('Listo\n\n');
    
    fprintf(strjoin({'El valor de la integral aproximada con Romberg del ' ...
        'módulo de la posición es: %.16f.\n\n'}, ''), ...
        I_romb(size(I_romb,1), size(I_romb,2)));
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Guardo la salida del programa.

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
