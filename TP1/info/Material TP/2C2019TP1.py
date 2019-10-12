#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
TP1 ANALISIS NUMERICO
Problemas de busqueda de raices
Creando un ascensor

2 Cuatrimestre 2019

Por:
Eze

"""

#Imports
import matplotlib
matplotlib.use('Agg')

import numpy as np #Manejo de arrays
import matplotlib.pylab as plt #Rutinas gráficas

##Constantes
fuerza = 10

masa_cabina = 1 #peso cabina

masa_persona = 1 #peso prom personas

numero_personas = 9 #a determinar

masa = masa_cabina + masa_persona*numero_personas

altura = 10 #altura de un piso

acel = fuerza/masa

print('-------------------------------------')
print('La fuerza que voy a usar es ', fuerza, '[N]')
print('-------------------------------------')
print('La masa que voy a usar es ', masa, '[Kg]')
print('-------------------------------------')
print('La altura que voy a usar es ', altura, '[m]')
print('-------------------------------------')
print('La aceleracion maxima es ', acel, '[m/s^2]')
print('-------------------------------------')

###Funciones posicion (f) y velocidad (f derivada ) y aceleracion (f derivada segunda)
def posicion(x):
    """
    funcion para buscar raices del tp

    OJO: Definida con constantes de afuera
    """
    return x #calcular

def velocidad(x):
    """
    derivada de posicion

    OJO: Definida con constantes de afuera
    """
    return None #calcular

def aceleracion(x):
    """
    derivada segunda de posicion

    OJO: Definida con constantes de afuera
    """
    return None #calcular

###Funciones busqueda de raices
def fuerzaBruta(f, a, b, a_tol, n_max):
    """
    Devolver (x0, delta), raiz y cota de error por metodo de fuerza bruta (horrible)
    """
    vector_x = np.linspace(a, b, n_max+1)

    minimo = abs(f(a))
    minimo_x = a

    for x in vector_x :
        valor_modulo = abs(f(x))
        if valor_modulo < minimo :
            minimo = valor_modulo
            minimo_x = x

    return minimo_x, (b-a)/2, n_max

###def biseccion(f, a, b, a_tol, n_max):
###  return x, delta, i+1

def secante(f, x0, x1, a_tol, n_max):
    """
    Devolver (x, delta), raiz y cota de error por metodo de la secante
    """
    delta = 0

    print('{0:^4} {1:^17} {2:^17} {3:^17}'.format('i', 'x', 'x_-1', 'delta'))
    print('{0:4} {1: .14f} {2: .14f} {3: .14f}'.format(0, x1, x0, delta))

    for i in range(n_max):
        x = x1 - f(x1)*(x1-x0)/(f(x1)-f(x0))
        delta = np.abs(x - x1)

        x0 = x1
        x1 = x

        print('{0:4} {1: .14f} {2: .14f} {3: .14f}'.format(i+1, x1, x0, delta))

        #Chequear convergencia
        if delta <= a_tol: #Hubo convergencia
            print('Hubo convergencia, n_iter = ' + str(i+1))
            return x, delta, i+1

    #Si todavia no salio es que no hubo convergencia:
    raise ValueError('No hubo convergencia')
    return x. delta, i+1

##def newton_rapshon(f, x0, a_tol, n_max):
##    return x. delta, i+1

#Intervalo para buscar raiz
l_izq = -100.0
l_der = 100.0

#Parametros para el algoritmo
a_tol = 1e-15
n_max = 200

#Grafica de las funciones
#Ver https://matplotlib.org
print('--------------------')
print('Graficando posicion')
print('-------------------')
print('')
xx = np.linspace(l_izq, l_der, 256+1)
yy = posicion(xx)
nombre = 'Posicion'
plt.figure(figsize=(10,7))
plt.plot(xx, yy, lw=2)
#plt.legend(loc=best)
plt.xlabel('x')
plt.ylabel(nombre +'(x)')
plt.title('Funcion '+ nombre)
plt.grid(True)
plt.savefig(nombre + '.png')
plt.show()

###Grafica de las funciones
###Ver https://matplotlib.org
##print('--------------------')
##print('Graficando velocidad')
##print('-------------------')
##print('')
##xx = np.linspace(l_izq, l_der, 256+1)
##yy = velocidad(xx)
##nombre = 'Velocidad'
##plt.figure(figsize=(10,7))
##plt.plot(xx, yy, lw=2)
###plt.legend(loc=best)
##plt.xlabel('x')
##plt.ylabel(nombre +'(x)')
##plt.title('Funcion '+ nombre)
##plt.grid(True)
##plt.savefig(nombre + '.png')
##plt.show()
##
###Grafica de las funciones
###Ver https://matplotlib.org
##print('--------------------')
##print('Graficando aceleracion')
##print('-------------------')
##print('')
##xx = np.linspace(l_izq, l_der, 256+1)
##yy = aceleracion(xx)
##nombre = 'Aceleracion'
##plt.figure(figsize=(10,7))
##plt.plot(xx, yy, lw=2)
###plt.legend(loc=best)
##plt.xlabel('x')
##plt.ylabel(nombre +'(x)')
##plt.title('Funcion '+ nombre)
##plt.grid(True)
##plt.savefig(nombre + '.png')
##plt.show()

print('----------------')
print('Fuerza Bruta')
print('----------------')
print('')
r, delta, n_iter = fuerzaBruta(posicion, l_izq, l_der, a_tol, n_max)
print('Funcion f, a_tol = '+str(a_tol))
print('raiz  = ' +str(r))
print('delta = ' +str(delta))
print('n_ite = ' +str(n_iter))
print('')

print('----------------')
print('Metodo secante')
print('----------------')
print('')
print('Funcion f, a_tol = '+str(a_tol))
r, delta, n_iter = secante(posicion, l_izq, l_der, a_tol, n_max)
print('raiz  = ' +str(r))
print('delta = ' +str(delta))
print('n_ite = ' +str(n_iter))
print('')

##print('----------------')
##print('Metodo biseccion')
##print('----------------')
##print('')
##print('Funcion f, a_tol = '+str(a_tol))
##r, delta, n_iter = bisec(f, l_izq, l_der, a_tol, n_max)
##print('raiz  = ' +str(r))
##print('delta = ' +str(delta))
##print('n_ite = ' +str(n_iter))
##print('')

##print('----------------')
##print('Metodo NewtonRapshon')
##print('----------------')
##print('')
##print('Funcion f, a_tol = '+str(a_tol))
##r, delta, n_iter = secante(f, l_izq, l_der, a_tol, n_max)
##print('raiz  = ' +str(r))
##print('delta = ' +str(delta))
##print('n_ite = ' +str(n_iter))
##print('')
##
