#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Ejemplo de rutina

Definir funciones
Graficar

Por:
Ignacio

"""

#Imports
import matplotlib
matplotlib.use('Agg')

from scipy.integrate import quad
import numpy as np #Manejo de arrays
import matplotlib.pylab as plt #Rutinas gráficas

def sin_aprox(x):
    #return x - x**3/6 + x**5/120 - x**7/5040
    return x - x**3/6

xx = np.linspace(-1, 1, 256+1)
yy1 = sin_aprox(np.pi*xx)
yy2 = np.sin(np.pi*xx)

#print(xx)

#Grafica de las funciones
#Ver https://matplotlib.org
nombre = 'Figura_sin_aprox'
plt.figure(figsize=(10,7))
plt.plot(xx, yy1, 'b', lw=3, label='sin_aprox(pi*x)')
plt.plot(xx, yy2, 'r--', lw=1, label='np.sin(pi*x)')
plt.legend(loc='best')
plt.xlabel('x')
plt.ylabel('f(x)')
plt.title(nombre)
plt.grid(True)
plt.savefig(nombre + '.png')
plt.show()

#Mido algunas "distancias" entre funciones
distancia1 = np.max(np.abs(yy1 - yy2))
print('Distancia 1 = ' +str(distancia1))

def resta2(x):
    return(sin_aprox(x)-np.sin(x))**2

distancia2 = quad(resta2, -np.pi, np.pi)
print('Distancia 2 = ' +str(distancia2[0]))

#Salida a archivo
tabla = np.vstack([xx, yy1, yy2]).T
np.savetxt('salida.csv', tabla, delimiter=',') #Forma rapida pero medio trucha
