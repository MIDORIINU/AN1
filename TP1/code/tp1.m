% Implementa el TP1, declarando la variables necesarias y llamando a los
% respectivos scripts. Los gráficos son salvados en formato PNG en el
% correspodiente directorio del informe, también los resultados numéricos
% son salvados en el correspondiente directorio del informe, donde el
% código de Latex los levanta automáticamente para generar el archivo
% compilado final del informe.
%%

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
fprintf('Inicializando las variables globales para el TP1...');

x = cell(1, 3); % Punteros a función de posición para n/2, n y o pers.
v = cell(1, 3); % Punteros a función de velocidad para n/2, n y o pers.
a = cell(1, 3); % Punteros a función de aceleración para n/2, n y o pers.
f = cell(1, 3); % Punteros a función para aplicar N-R para n/2, n y o pers.


% Declaro las funciones para media carga del ascensor.
x{1} = @(t) -0.5443*t.^3 + 2.*t.^2;
v{1} = @(t) -1.6329*t.^2 + 4*t;
a{1} = @(t) -3.2658*t + 4;

% Declaro las funciones para máxima carga del ascensor.
x{2} = @(t) 0.2963*t.^3 + 1.3333.*t.^2;
v{2} = @(t) -0.8889*t.^2 + 2.6667*t;
a{2} = @(t) -1.7778*t + 2.6667;

% Declaro las funciones para mínima carga del ascensor.
x{3} = @(t) -1.5396*t.^3 + 4*t.^2;
v{3} = @(t) -4.6188*t.^2 + 8*t;
a{3} = @(t) -9.2376*t + 8;



% Declaro un título para los gráficos de las funciones.
titlex = 'Posición (media carga): x(t) = -0.5443*t.^3 + 2*t.^2';
legendx = 'x(t)';

titlev = 'Velocidad (media carga): v(t) = -1.6329*t.^2 + 4*t';
legendv = 'v(t)';

titlea = 'Aceleración (media carga): a(t) = -3.2658*t + 4';
legenda = 'a(t)';



% Declaro la cantidad de puntos para los gráficos.
cant_points = 1E6;

% En el caso de Octave, una cantidad muy grande causa problemas
if (Is_Octave)
    cant_points = 1E3;
end

% Declaro el directorio para las imágenes.
images_directory = fullfile('..', 'informe', 'img');

% Declaro el directorio para los archivos ".csv".
results_directory = fullfile('..', 'informe', 'results');

% Declaro los nombres de los archivos a guardar.
seeds = 'seeds';
newton_prefix = 'newton_tol_';
newton_results_name = 'newton_final_results';
newton_convergence_name = 'newton_convergence_results';
grafico_x = 'grafico_funcion_x.png';
grafico_v = 'grafico_funcion_v.png';
grafico_a = 'grafico_funcion_a.png';

% Declaro los intervalos para las funciones.
ai = [0, 0, 0];
bi = [2.4495, 3, 1.7321];

% Declaro la tolerancia para las raíces/soluciones.
tol = 1E-10;

% Declaro la máxima cantidad de iteraciones admisibles para los algoritmos.
max_iter = 500;

fprintf('Listo\n\n');

if (~Is_Octave) % Si estoy trabajando en MATLAB.
    env = 'MATLAB';
else            % Si estoy trabajando en Octave.
    env = 'Octave';
end %if

fprintf('Trabajando en: %s %s sobre %s.\n\n', env, version, OS);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% En el caso de MATLAB debo verificar que el paquete simbólico esté
% disponible, para el cálculo simbólico de la derivada, en Octave debo
% además cargar el paquete.
if (~Is_Octave) % Si estoy trabajando en MATLAB.
    
    if (~license('test', 'symbolic_toolbox'))
        fprintf(strjoin({'\nNo se encontró', ...
            'el toolbox simbólico, necesario para la derivada', ...
            'simbólica en el método de Newton-Raphson,', ...
            'no se puede continuar.\n\n'}));
        
        return;
    end %if
    
else            % Si estoy trabajando en Octave.
    
    loaded = 0;
    
    packs = pkg('list');
    
    for jj = 1:numel(packs)
        
        if (strcmp('symbolic', packs{jj}.name))
            pkg('load', packs{jj}.name);
            loaded = 1;
            break;
        end %if
    end %for
    
    if (~loaded)
        fprintf(strjoin({'\nNo se encontró', ...
            'el paquete simbólico, necesario para la derivada', ...
            'simbólica en el método de Newton-Raphson,', ...
            'no se puede continuar.\n', ...
            'Se puede instalar desde Octave forge con:\n', ...
            '"pkg install -forge symbolic".\n\n'}));
        
        return;
    end %if
    
end %if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Creando el directorio para las imágenes...');

% Creo el directorio para las imágenes y verifico que exista.
[~, ~] = mkdir(images_directory);
success = (7 == exist(images_directory, 'dir'));

% Chequeo que el directorio para las imágenes exista.
if (~success)
    fprintf(strjoin({'\nNo se pudo crear', ...
        'el directorio para las imágenes.\n\n'}));
    
    exit;
else
    fprintf('Listo\n\n');
end

fprintf('Creando el directorio para los resultados numéricos...');

% Creo el directorio para los archivos numéricos y verifico que exista.
[~, ~] = mkdir(results_directory);
success = (7 == exist(results_directory, 'dir'));

% Chequeo que el directorio para los archivos numéricos exista.
if (~success)
    fprintf(strjoin({'\nNo se pudo crear', ...
        'el directorio para los resultados.\n\n'}));
    
    exit;
else
    fprintf('Listo\n\n');
end

fprintf(strjoin({'\nLas funciones para la posición, velocidad', ...
    ' y aceleración a media carga (n/2 = 6),', ...
    ' son respectivamente:\n\n'},''));
disp(x{1});
fprintf('\n');
disp(v{1});
fprintf('\n');
disp(a{1});

fprintf(strjoin({'Las unidades para estas funciones son', ...
    ' m, m/s y m/s^2, respectivamente.\n\n\n'},''));


fprintf(strjoin({'Generando un gráfico de cada función en el',...
    ' intervalo [%.5f, %.5f] para ver su forma general...\n\n'}, ''), ...
    ai(1), bi(1));

% Genero un primer gráfico de cada función para
% ver su forma general.
graphic_x_handle = grafico(x{1}, ai(1), bi(1), cant_points, titlex, ...
    legendx, false, [1 0 0], 75);

fprintf(...
    'Salvando el gráfico de la posición en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_x_handle, fullfile(images_directory, ...
    grafico_x));

% Generación completa.
fprintf('Listo\n\n');

graphic_v_handle = grafico(v{1}, ai(1), bi(1), cant_points, titlev, ...
    legendv, false, [0 0 1], 75);

fprintf(...
    'Salvando el gráfico de la velocidad en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_v_handle, fullfile(images_directory, ...
    grafico_v));

% Generación completa.
fprintf('Listo\n\n');

graphic_a_handle = grafico(a{1}, ai(1), bi(1), cant_points, titlev, ...
    legenda, false, [0 1 0], 75);

fprintf(...
    'Salvando el gráfico de la aceleración en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_a_handle, fullfile(images_directory, ...
    grafico_a));

% Generación completa.
fprintf('Listo\n\n');


% Generación completa.
fprintf('Listo\n\n\n');


%%

% Genero los nombres completos de los archivos de resultados .

newton_results_complete_name = ...
    fullfile(results_directory, ...
    strjoin({newton_results_name, '.csv'}, ''));

newton_convergence_complete_name = ...
    fullfile(results_directory, ...
    strjoin({newton_convergence_name, '.csv'}, ''));

%%


% Calculo la cantidad de cifras significativas para la tolerancia.
cant_signif = ceil(-log10(tol));

fprintf('\n\n\nEjecutando los métodos numéricos...\n\n\n');




%%

t_acel_30_percent = zeros(1, 3);

for ii = 1:3
    
    fprintf(strjoin({'Hallamos el valor de tiempo en', ...
        ' el cual se alcanza el 30%% de la aceleración positiva. \n', ...
        'Por tratarse de una función lineal', ...
        ' el valor se halla trivialmente:\n\n'},''));
    
    % Calculo el tiempo para un 30% de la aceleración máxima (positiva).
    
    max_acel = a{ii}(0);
    
    ac_30p = @(t) a{ii}(t) - 0.3*max_acel;
    
    t_acel_30_percent(ii) = fzero(ac_30p, 0);
    
    
    fprintf(strjoin({'El 30%% de la aceleración',...
        ' se alcanza en t_acel_30_percent=%.', ...
        num2str(cant_signif) ,'f.\n\n'}, ''), ...
        t_acel_30_percent(ii));
    
    
    fprintf(strjoin({'Hallamos el valor de posición en', ...
        ' el tiempo hallado anteriormente. \n', ...
        'Con este valor construimos la función (f{', num2str(ii) ,'})', ...
        ' a la cuál le hallaremos la raíz por Newton-Raphson:\n\n'},''));
    
    f{ii} = @(t) x{ii}(t) - x{ii}( t_acel_30_percent(ii));
    
    
    disp(f{ii});
    
    
%     graphic_x_handle = grafico(f{1}, ai(1), bi(1), cant_points, ...
%         'Función a la cual aplicamos Newton-Raphson', ...
%         legendx, false, [1 0.3 1], 75);
    
    
    % Busco la raíz por el método de Newton-Raphson.
    fprintf(strjoin({'Ejecutando el método de Newton-Raphson'...
        'para f{', num2str(ii),'} y para la tolerancia %.1e...'}), tol);
    
    % Ejecuto el método.
    [r0, delta, erel, ...
        table, success] = ...
        method_newton(f{ii}, 1, tol, max_iter);
    
    % Chequeo que el método alcanzó la precisón pedida en menos
    % de las máximas iteraciones.
    if (~success)
        fprintf(strjoin({'\nFalló el método de Newton-Raphson', ...
            'para la función f{%d}.\n\n'}), ii);
        
        return;
    else
        fprintf('Listo\n\n');
    end %if
    
    % Extraigo la cantidad de iteraciones requeridas como
    % el largo de la tabla.
    iter_req = size(table, 1);
    
    % Armo el string para formatear la salida.
    format_str = sprintf(...
        strjoin({'Raíz hallada después de %%d iteraciones:'...
        '%%.%df +- %%.1e\n\n'}), ...
        cant_signif);
    
    % Muestro el resultado.
    fprintf(format_str, iter_req, r0, tol);
    
    
    % Guardo los resultados en un archivo.
    fprintf('Salvando los resultados en un archivo "CSV"......');
    
    % Guardo la tabla de las iteraciones.
    dlmwrite(fullfile(results_directory, ...
        strjoin({newton_prefix, int2str(ii), '.csv'}, '')),  ...
        table, 'precision','%.15f');
    
    % Armo la tabla de resultados finales con:
    % 1 - Índice.
    % 2 - Raíz hallada.
    % 3 - Tolerancia pedida.
    % 4 - Cantidad de cifras significativas correspondiente.
    % 5 - Delta obtenido.
    % 6 - Error relativo.
    % 7 - Cantidad de iteraciones requeridas.
    results = [ii, r0, tol, cant_signif, delta, erel, iter_req];
    
    % Guardo el archivo de resultados finales.
    dlmwrite(newton_results_complete_name, ...
        results, 'precision','%.15f', '-append');
    
    % Guardado completo.
    fprintf('Listo\n\n');
    
    % Calculo el orden de convergencia y la constante asintótica
    % estimadas, en base a los últimos valores de la última tabla.
    
    fprintf('Estimando el orden de convergencia......');
    
    % Invoco al cálculo.
    [order, asintconst, ~, asintconstder, interm1, interm2, ...
        interm3, interm4, interm5, interm6] = ...
        estimate_order(f{ii}, table(iter_req -3, 2), ...
        table(iter_req - 2, 2), ...
        table(iter_req - 1, 2), table(iter_req, 2));
    
    % Estimación completa.
    fprintf('Listo\n\n');
    
    % Muestro el valor estimado.
    fprintf(strjoin({'El orden de convergencia estimado', ...
        'para el método de Newton-Raphson es %.8f.\n\n'}), order);
    
    % Armo el array con los valores a guardar.
    conv_results = ...
        [order, asintconst, asintconstder, interm1, interm2, ...
        interm3, interm4, interm5, interm6];
    
    % Guardo los resultados de la estimación en un archivo.
    fprintf(strjoin({'Salvando los resultados de la estimación', ...
        'del orden de convergencia en un archivo "CSV"......'}));
    
    % Guardo los valores de las estimaciones.
    dlmwrite(newton_convergence_complete_name, ...
        conv_results, 'precision','%.15f');
    
    % Guardado completo.
    fprintf('Listo\n\n');    
    
end


%%

return;



fprintf('Buscando intervalo para la raíz de la función f...');

% Hallo un intervalo con límites enteros conteniendo a la raíz.
[a, b, success] = findinterval(f, 100, 0);

% Chequeo que se haya encontrado un intervalo.
if (~success)
    fprintf(strjoin({'\nNo se encontró un intervalo ', ...
        'para la raíz.\n\n'}), maxcount);
    
    exit;
else
    fprintf('Intervalo hallado: (%d, %d).\n\n', a, b);
end

fprintf(strjoin({'Generando un gráfico de la función f en el intervalo',...
    'hallado, [%d, %d]...'}), a, b);

% Genero un gráfico de la función en el intervalo que contiene a la raíz.
graphic_handle = grafico(f, a, b, cant_points, title, legend, 75);

% Generación completa.
fprintf('Listo\n\n');

fprintf('Salvando el gráfico de la función f en un archivo "PNG"......');

% Salvo el gráfico en un archivo.
saveas(graphic_handle, fullfile(images_directory, ...
    grafico_f_2));

% Salvado completo.
fprintf('Listo\n\n');

% Calculo la semilla (valor intermedio) para el cálculo de las raíces.
seed = a + (b - a)/2;

fprintf(strjoin({'La semilla a usar para la búsqueda', ...
    'de la raíz\\punto fijo es: %.3f\n\n'}), seed);

fprintf(strjoin({'Las semillas a usar para la búsqueda', ...
    'de la raíz por el método Regula Falsi son: %.3f, %.3f\n\n'}), a, b);

% Genero el nombre completo para el archivo de semillas.
seeds_complete_name = ...
    fullfile(results_directory, ...
    strjoin({seeds, '.csv'}, ''));

% Genero el array de semillas.
seeds_table = [a, b; seed, 0];


% Guardo los resultados en un archivo.
fprintf('Salvando las semillas en un archivo "CSV"......');

% Guardo las semillas.
dlmwrite(seeds_complete_name, ...
    seeds_table, 'precision','%.15f');

% Salvado completo.
fprintf('Listo\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Genero los nombres completos de los archivos de resultados finales para
% cada uno de los métodos.

fixed_point_results_complete_name = ...
    fullfile(results_directory, ...
    strjoin({fixed_point_results_name, '.csv'}, ''));

fixed_point_convergence_complete_name = ...
    fullfile(results_directory, ...
    strjoin({fixed_point_convergence_name, '.csv'}, ''));

newton_results_complete_name = ...
    fullfile(results_directory, ...
    strjoin({newton_results_name, '.csv'}, ''));

newton_convergence_complete_name = ...
    fullfile(results_directory, ...
    strjoin({newton_convergence_name, '.csv'}, ''));

regula_falsi_results_complete_name = ...
    fullfile(results_directory, ...
    strjoin({regula_falsi_results_name, '.csv'}, ''));

regula_falsi_convergence_complete_name = ...
    fullfile(results_directory, ...
    strjoin({regula_falsi_convergence_name, '.csv'}, ''));

% Borro los archivos de resultados finales si existen.
if (exist(fixed_point_results_complete_name, 'file'))
    delete(fixed_point_results_complete_name);
end

if (exist(newton_results_complete_name, 'file'))
    delete(newton_results_complete_name);
end

if (exist(regula_falsi_results_complete_name, 'file'))
    delete(regula_falsi_results_complete_name);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Ejecuto los tres métodos para una de las tolerancias pedidas,
% guardando los resultados en un archivo.

fprintf('\n\n\nEjecutando los métodos numéricos...\n\n\n');

for ii = 1:cant_tols
    
    % Calculo la cantidad de cifras significativas para la tolerancia.
    cant_signif = ceil(-log10(tols(:, ii)));
    
    % Busco el punto fijo.
    fprintf(strjoin({'Ejecutando el método del punto fijo'...
        'para g y para la tolerancia %.1e...'}), tols(:, ii));
    
    % Ejecuto el método.
    [r0, delta, erel, ...
        table, success] = ...
        method_fixedpoint(g, seed, tols(:, ii), max_iter);
    
    % Chequeo que el método alcanzó la precisón pedida en menos
    % de las máximas iteraciones.
    if (~success)
        fprintf(strjoin({'\nFalló el método del punto fijo', ...
            'para g y la tolerancia %.1e.\n'}), tols(ii));
        
        return;
    else
        fprintf('Listo\n\n');
    end % if
    
    % Extraigo la cantidad de iteraciones requeridas como
    % el largo de la tabla.
    iter_req = size(table, 1);
    
    % Armo el string para formatear la salida.
    format_str = sprintf(...
        strjoin({'Solución hallada después de %%d iteraciones:'...
        '%%.%df +- %%.1e\n\n'}), ...
        cant_signif);
    
    % Muestro el resultado.
    fprintf(format_str, iter_req, r0, tols(:, ii));
    
    % Guardo los resultados en un archivo.
    fprintf('Salvando los resultados en un archivo "CSV"......');
    
    % Guardo la tabla de las iteraciones.
    dlmwrite(fullfile(results_directory, ...
        strjoin({fixed_point_prefix, int2str(ii), '.csv'}, '')), ...
        table, 'precision','%.15f');
    
    % Armo la tabla de resultados finales con:
    % 1 - Índice para la tolerancia.
    % 2 - Solución hallada.
    % 3 - Tolerancia pedida.
    % 4 - Cantidad de cifras significativas correspondiente.
    % 5 - Delta obtenido.
    % 6 - Error relativo.
    % 7 - Cantidad de iteraciones requeridas.
    results = [ii, r0, tols(:, ii), cant_signif, delta, erel, iter_req];
    
    % Guardo el archivo de resultados finales.
    dlmwrite(fixed_point_results_complete_name, ...
        results, 'precision','%.15f', '-append');
    
    % Guardado completo.
    fprintf('Listo\n\n');
    
    % Calculo el orden de convergencia y la constante asintótica
    % estimadas, en base a los últimos valores de la última tabla.
    if (ii == cant_tols )
        fprintf('Estimando el orden de convergencia......');
        
        % Invoco al cálculo.
        [order, asintconst, asintconstder, ~, interm1, interm2, ...
            interm3, interm4, interm5, interm6] = ...
            estimate_order(g, table(iter_req -3, 2), ...
            table(iter_req - 2, 2), ...
            table(iter_req - 1, 2), table(iter_req, 2));
        
        % Estimación completa.
        fprintf('Listo\n\n');
        
        % Muestro el valor estimado.
        fprintf(strjoin({'El orden de convergencia estimado', ...
            'para el método del punto fijo es %.8f.\n\n'}), order);
        
        % Armo el array con los valores a guardar.
        conv_results = ...
            [order, asintconst, asintconstder, interm1, interm2, ...
            interm3, interm4, interm5, interm6];
        
        % Guardo los resultados de la estimación en un archivo.
        fprintf(strjoin({'Salvando los resultados de la estimación', ...
            'del orden de convergencia en un archivo "CSV"......'}));
        
        % Guardo los valores de las estimaciones.
        dlmwrite(fixed_point_convergence_complete_name, ...
            conv_results, 'precision','%.15f');
        
        % Guardado completo.
        fprintf('Listo\n\n');
    end
    
    % Busco la raíz por el método de Newton-Raphson.
    fprintf(strjoin({'Ejecutando el método de Newton-Raphson'...
        'para f y para la tolerancia %.1e...'}), tols(:, ii));
    
    % Ejecuto el método.
    [r0, delta, erel, ...
        table, success] = ...
        method_newton(f, seed, tols(:, ii), max_iter);
    
    % Chequeo que el método alcanzó la precisón pedida en menos
    % de las máximas iteraciones.
    if (~success)
        fprintf(strjoin({'\nFalló el método de Newton-Raphson', ...
            'para la tolerancia %.1e.\n\n'}), tols(ii));
        
        return;
    else
        fprintf('Listo\n\n');
    end %if
    
    % Extraigo la cantidad de iteraciones requeridas como
    % el largo de la tabla.
    iter_req = size(table, 1);
    
    % Armo el string para formatear la salida.
    format_str = sprintf(...
        strjoin({'Raíz hallada después de %%d iteraciones:'...
        '%%.%df +- %%.1e\n\n'}), ...
        cant_signif);
    
    % Muestro el resultado.
    fprintf(format_str, iter_req, r0, tols(:, ii));
    
    % Guardo los resultados en un archivo.
    fprintf('Salvando los resultados en un archivo "CSV"......');
    
    % Guardo la tabla de las iteraciones.
    dlmwrite(fullfile(results_directory, ...
        strjoin({newton_prefix, int2str(ii), '.csv'}, '')),  ...
        table, 'precision','%.15f');
    
    % Armo la tabla de resultados finales con:
    % 1 - Índice para la tolerancia.
    % 2 - Raíz hallada.
    % 3 - Tolerancia pedida.
    % 4 - Cantidad de cifras significativas correspondiente.
    % 5 - Delta obtenido.
    % 6 - Error relativo.
    % 7 - Cantidad de iteraciones requeridas.
    results = [ii, r0, tols(:, ii), cant_signif, delta, erel, iter_req];
    
    % Guardo el archivo de resultados finales.
    dlmwrite(newton_results_complete_name, ...
        results, 'precision','%.15f', '-append');
    
    % Guardado completo.
    fprintf('Listo\n\n');
    
    % Calculo el orden de convergencia y la constante asintótica
    % estimadas, en base a los últimos valores de la última tabla.
    if (ii == cant_tols )
        fprintf('Estimando el orden de convergencia......');
        
        % Invoco al cálculo.
        [order, asintconst, ~, asintconstder, interm1, interm2, ...
            interm3, interm4, interm5, interm6] = ...
            estimate_order(f, table(iter_req -3, 2), ...
            table(iter_req - 2, 2), ...
            table(iter_req - 1, 2), table(iter_req, 2));
        
        % Estimación completa.
        fprintf('Listo\n\n');
        
        % Muestro el valor estimado.
        fprintf(strjoin({'El orden de convergencia estimado', ...
            'para el método de Newton-Raphson es %.8f.\n\n'}), order);
        
        % Armo el array con los valores a guardar.
        conv_results = ...
            [order, asintconst, asintconstder, interm1, interm2, ...
            interm3, interm4, interm5, interm6];
        
        % Guardo los resultados de la estimación en un archivo.
        fprintf(strjoin({'Salvando los resultados de la estimación', ...
            'del orden de convergencia en un archivo "CSV"......'}));
        
        % Guardo los valores de las estimaciones.
        dlmwrite(newton_convergence_complete_name, ...
            conv_results, 'precision','%.15f');
        
        % Guardado completo.
        fprintf('Listo\n\n');
    end
    
    % Busco la raíz por el método Regula Falsi.
    fprintf(strjoin({'Ejecutando el método Regula Falsi'...
        'para f y para la tolerancia %.1e...'}), tols(:, ii));
    
    % Ejecuto el método.
    [r0, delta, erel, ...
        table, success] = ...
        method_regulafalsi(f, a, b, tols(:, ii), max_iter);
    
    % Chequeo que el método alcanzó la precisón pedida en menos
    % de las máximas iteraciones.
    if (~success)
        fprintf(strjoin({'\nFalló el método Regula Falsi', ...
            'para la tolerancia %.1e.\n\n'}), tols(ii));
        
        return;
    else
        fprintf('Listo\n\n');
    end %if
    
    % Extraigo la cantidad de iteraciones requeridas como
    % el largo de la tabla.
    iter_req = size(table, 1);
    
    % Armo el string para formatear la salida.
    format_str = sprintf(...
        strjoin({'Raíz hallada después de %%d iteraciones:'...
        '%%.%df +- %%.1e\n\n'}), ...
        cant_signif);
    
    % Muestro el resultado.
    fprintf(format_str, iter_req, r0, tols(:, ii));
    
    % Guardo los resultados en un archivo.
    fprintf('Salvando los resultados en un archivo "CSV"......');
    
    % Guardo la tabla de las iteraciones.
    dlmwrite(fullfile(results_directory, ...
        strjoin({regula_falsi_prefix, int2str(ii), '.csv'}, '')),  ...
        table, 'precision','%.15f');
    
    % Armo la tabla de resultados finales con:
    % 1 - Índice para la tolerancia.
    % 2 - Raíz hallada.
    % 3 - Tolerancia pedida.
    % 4 - Cantidad de cifras significativas correspondiente.
    % 5 - Delta obtenido.
    % 6 - Error relativo.
    % 7 - Cantidad de iteraciones requeridas.
    results = [ii, r0, tols(:, ii), cant_signif, delta, erel, iter_req];
    
    % Guardo el archivo de resultados finales.
    dlmwrite(regula_falsi_results_complete_name, ...
        results, 'precision','%.15f', '-append');
    
    % Guardado completo.
    fprintf('Listo\n\n');
    
    % Calculo el orden de convergencia y la constante asintótica
    % estimadas, en base a los últimos valores de la última tabla.
    if (ii == cant_tols )
        fprintf('Estimando el orden de convergencia......');
        
        % Invoco al cálculo.
        [order, asintconst, asintconstder, ~, interm1, interm2, ...
            interm3, interm4, interm5, interm6] = ...
            estimate_order(f, table(iter_req -3, 2), ...
            table(iter_req - 2, 2), ...
            table(iter_req - 1, 2), table(iter_req, 2));
        
        % Estimación completa.
        fprintf('Listo\n\n');
        
        % Muestro el valor estimado.
        fprintf(strjoin({'El orden de convergencia estimado', ...
            'para el método Regula Falsi es %.8f.\n\n'}), order);
        
        % Armo el array con los valores a guardar.
        conv_results = ...
            [order, asintconst, asintconstder, interm1, interm2, ...
            interm3, interm4, interm5, interm6];
        
        % Guardo los resultados de la estimación en un archivo.
        fprintf(strjoin({'Salvando los resultados de la estimación', ...
            'del orden de convergencia en un archivo "CSV"......'}));
        
        % Guardo los valores de las estimaciones.
        dlmwrite(regula_falsi_convergence_complete_name, ...
            conv_results, 'precision','%.15f');
        
        % Guardado completo.
        fprintf('Listo\n\n');
    end
    
    
end %for

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% El script se ejecutó correctamente..
fprintf('\n\nEjecución del TP1 terminada.\n\n');

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




