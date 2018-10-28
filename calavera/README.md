Calavera -- Comment découper au laser un dessin fait main
=========================================================

Une [calavera](https://fr.wikipedia.org/wiki/Calavera_(Mexique)) est une tête de mort
pour la fête des morts dans la culture mexicaine. Une [petite recherche rapide](https://www.google.com/search?q=calavera) vous
montrera pleins de dessin de ces têtes.

Une fois n'est pas coutume, ce projet contient un tutoriel en Français en dernière section.
Voici d'abord le résultat final :

<img title="une calavera découpée au laser" src="20181028_161215.jpg?raw=true" width="300px" />
<img title="une autre calavera découpée au laser" src="20181028_161244.jpg?raw=true" width="300px" />

Source
------

Télécharger ou [forker on github](https://github.com/loic-fejoz/loic-fejoz-fabmoments/tree/master/calavera).

Voir aussi [mes autres FabMoments](https://github.com/loic-fejoz/loic-fejoz-fabmoments/tree/master/).

License
-------

SVG, PNG, JPG, and this document are under the [Creative Commons Attribution 3.0 France](https://creativecommons.org/licenses/by/3.0/fr/) (CC BY 3.0 FR - Loïc Fejoz).


Tutorial
--------

### Introduction

Le but de ce tutoriel n'est pas spécialement de créer des calavera mais bien de transformer rapidement et facilement un dessin fait à la main en papier ou carton découpé au laser.
Autrement dit, il s'agit de passer du dessin de gauche à l'objet de droite :

<img src="calavera-laurence.jpg?raw=true" height="150px" />
<img src="20181028_161215.jpg?raw=true" height="150px" />

### Numériser le dessin

On peut bien sûr utiliser un scanner mais, tout comme sur les téléphones portables, les webcams
sont maintenant de qualité suffisante pour numériser une image. Sous Linux, l'utilitaire ```cheese``` vous permettra de capturer une photo à partir de la webcam. Sous MS/Windows, ce sera ```Caméra```.

Ainsi nous obtenons la photo suivante :
![Original Photo capture with the webcam](calavera-laurence.jpg?raw=true)

### Convertir la photo en image noir et blanc

Nous ouvrons alors l'image avec [Gimp](https://www.gimp.org/fr/) avec lequel nous allons
convertir l'image en noir & blanc faire quelques améliorations.

![Menu Image > Mode > Niveaux de gris](gimp-mode.png?raw=true)
Tout d'abord, nous ne sommes intéressé que par les contrastes de l'image. Donc nous passons
l'image en mode niveaux de gris.

![Menu Image > Ajuster le canevas à la sélection](gimp-ajuster-canevas.png?raw=true)
Nous ajustons bien sûr le canevas au plus proche de notre dessin en utilisant d'abord l'outil ``sélection``.

![](gimp-seuil-menu.png?raw=true)
![](gimp-seuil-boite-dialogue.png?raw=true)
Enfin le coeur de cette étape, nous convertissons l'image en noir & blanc en utilisant
l'outil seuil. Déplacer les curseurs afin d'optimiser le résultat.

C'est aussi le moment d'utiliser le crayon ou le pinceau pour élargir certains traits un peu fin, ou pour relier des parties qui autrement se dissocieraient. A l'inverse, on utilisera la gomme pour supprimer ou réduire les éléments nuisibles.

![](gimp-flou-gaussien.jpg?raw=true)

Optionnellement, si l'image est bruitée ou bien si les aplats contiennent un peu de blanc, on peut appliquer un léger flou.

Au final, nous obtenons alors l'image suivante :
![Image after gimp transformation](calavera-laurence-nb.jpg?raw=true)


### Convertir l'image matricielle (bitmap) en dessin vectoriel

Nous utilisons [Inkscape](https://inkscape.org/fr/) pour cette étape préliminaire à la découpe.

![](inkscape-vectoriser.png?raw=true)

Après avoir ouvert l'image dans Inkscape, nous pouvons alors vectoriser celle-ci en lançant la commande ``Chemin > Vectoriser un objet matriciel``.

![](inkscape-vectorisation.png?raw=true)

Plus particulièrement, nous utilisons la vectorisation ``Seuil de luminosité``. Le seuil devra généralement se situer autour de 0,5.

![](inkscape-units.png?raw=true)

C'est le moment de vérifier quelques éléments comme la dimmension de votre dessin, changer la couleur des traits (chemin), mais aussi changer les unités du fichier, et enfin ajuster la page à votre dessin.

Nous obtenons alors le dessin vectoriel final :

![Vectorial image ready to be laser cut](calavera-laurence.svg?raw=true)

### Découpe à la laser

Normalement, le SVG final est utilisable directment avec tout bon logiciel de manipulation d'une découpeuse laser.

Personnellement, j'utilise [K40 Whisperer](http://www.scorchworks.com/K40whisperer/k40whisperer.html) pour ma petite découpeuse chinoise. La vitesse sur du carton léger était de 70mm/s pour une puissance régulée par 10mA.

![](20181028_161215.jpg?raw=true)
