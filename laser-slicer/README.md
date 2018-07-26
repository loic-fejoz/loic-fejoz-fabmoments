Laser Slicer
============

A module for [IceSL](http://www.loria.fr/~slefebvr/icesl/) so as to slice a shape into cardboard or other material for further laser-cutting.

Usage
-----

1. Copy the `laser-slicer.lua` script into your directory
2. Copy and rename the `Minion_Dave.lua` into your directory
3. Adjust the `cfg.board.height` to be the thickness of your cardboard in mm.
4. Adjust the `cfg.stick.diameter` to ...the diameter of the your stick.
5. If the stick is not well placed or you want more, mimicks `bear.lua` to provide your owns.
6. Once satisfied, change the second parameter of `laserslicer.defaultCfg()` to true so as to place slices flat.
7. Change IceSL service to "Slice to SVG".
8. Adjust slice thickness so as to have only one slice
9. Export SVG
10. Edit SVG so as to keep proper dimmensions
    1. Look at `viewBox` attribute, eg `viewBox="0.45 -215.05 286.00004 141.116"`
    2. Add attribute `width` with the 3rd value and appending `mm`, eg `width="286.00004mm"`
    3. Add atribute `height` with the 4th value, eg `height="141.116mm"`

License
-------

Photos are under the [Creative Commons Attribution 3.0 France](https://creativecommons.org/licenses/by/3.0/fr/) (CC BY 3.0 FR - Loïc Fejoz).

IceSL Model is under the [MIT License](http://opensource.org/licenses/MIT).

[STL model of the bear by christophecaran](https://www.thingiverse.com/thing:192392/files) is licensed under the [Creative Commons - Attribution - Non-Commercial license](https://creativecommons.org/licenses/by-nc/3.0/).

Gallery
-------

![Original Bear by christophecaran is licensed under the Creative Commons - Attribution - Non-Commercial license](shot0000.png?raw=true)
![Coarse-Slices of the bear with sticks](shot0001.png?raw=true)
![Ready to cut slices](shot0002.png?raw=true)
![Final Bear result](20180726_095708.jpg?raw=true)
![SVG for 2.5mm board thickness and 1.9mm sticks](ours-laser-2.5mm.svg?raw=true)
![SVG for 3mm board thickness and 1.9mm sticks](ours-laser-3mm.svg?raw=true)
![Original Minion Dave by Poh is licensed under the GNU - GPL license](shot0003.png?raw=true)
