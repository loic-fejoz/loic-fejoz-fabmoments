Gabriel's Horn
==============

An attempt to use implicit surface feature of IceSL.

[Gabriel's Horn](http://fr.wikipedia.org/wiki/Trompette_de_Gabriel) has equation r = c / z with r = (x^2 + y^2) and c a constant (5 in the screenshot).

The main difficulty is to transform the surface equation to a signed distance function as required by [IceSL](http://www.loria.fr/~slefebvr/icesl/).
So I tried to find the analytic distance function with the help of [Maxima](http://maxima.sourceforge.net/). It is usefull to find the derivative of the distance between a point and a point on the surface, but zeroing the derivative is quite unhelpfull. The final equation is quite long to read and translate to a OpenGL GLSL shader. Thus I finally try to use dichotomy to find the shortest distance between a point and the surface. It prooves sufficient but still have artifacts on display. It is correct for slicing.

Source
------

Download the [IceSL source](gabriel-horn.lua?raw=true), or [fork on github](https://github.com/loic-fejoz/loic-fejoz-fabmoments/tree/master/gabriel-horn).

See other of [my FabMoments](https://github.com/loic-fejoz/loic-fejoz-fabmoments/tree/master/).

License
-------

Photos and Screenshots are under the [Creative Commons Attribution 3.0 France](https://creativecommons.org/licenses/by/3.0/fr/) (CC BY 3.0 FR - Loïc Fejoz).

IceSL Model is under the [MIT License](http://opensource.org/licenses/MIT).

Gallery
-------

![A screenshot of the Gabriel's Horn](shot0004.png?raw=true)
![A screenshot of the Gabriel's Horn with defects](shot0000.png?raw=true)
![A screenshot of the Gabriel's Horn sliced](shot0005.png?raw=true)
