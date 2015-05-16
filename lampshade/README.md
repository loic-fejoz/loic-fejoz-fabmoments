Lampshade Builder Script
========================

The idea is to have an [IceSL](http://www.loria.fr/~slefebvr/icesl/) script to automate the creation of lampshade.

Lampshade is a now common object to build in a FabLab with a Laser Cutter. But it is tedious to draw the original file. This script is meant to ease that by just drawing a profile (in SVG) and updating a configuration file. Then one can view the assembled lamp or export the part to be cutted. See Gallery below.

Examples of lampshade built by other people:
* http://fabmoment.fablabenschede.nl/laser-cut-lamp-shade/
* http://www.crowdyhouse.com/nl/shop/cp-mini-spot/
* https://img1.etsystatic.com/026/0/8729335/il_fullxfull.590429443_bj87.jpg
* http://i00.i.aliimg.com/wsphoto/v0/32315092894/Nordic-Creative-Wooden-LED-Chandelier-Modern-Loft-Vintage-Wood-font-b-Hanging-b-font-Lamp-font.jpg

Usage
-----

1. Copy the lampshade.lua script into your directory
2. Copy and rename the profil-00.lua into your directory
3. Draw your profile in an SVG editor. The position over the X axis defines what will match the hole.
4. Update configuration
  1. config.view to be 'assembled'
  2. config.upper.height to be height level of the upper face
  3. config.profile_number to be the number of profiles around the lampshade
  4. ...
5. Once satisfied, change view to be 'cutting' (or commented) and slice with the [SVG printer configuration](https://github.com/loic-fejoz/icesl-svg-printer).
6. Go to your favorite FabLab.

Source
------

Download the [IceSL source](lampshade.lua?raw=true), or [fork on github](https://github.com/loic-fejoz/loic-fejoz-fabmoments/tree/master/lampshade).

See other of [my FabMoments](https://github.com/loic-fejoz/loic-fejoz-fabmoments/tree/master/).

License
-------

Photos are under the [Creative Commons Attribution 3.0 France](https://creativecommons.org/licenses/by/3.0/fr/) (CC BY 3.0 FR - Loïc Fejoz).

IceSL Model is under the [MIT License](http://opensource.org/licenses/MIT).

Gallery
-------

![A screenshot of the assembled lampshade with profil-01](shot0002.png?raw=true)
![A screenshot of the assembled lampshade with profil-00](shot0001.png?raw=true)
![A screenshot of the cutting parts for the lampshade with profil-00](shot0000.png?raw=true)
