#!/usr/bin/python
import math
cote=3
radius=3
angle = 360 / cote # in degrees
angle_rad = math.radians(angle)
pi_2 = math.pi / 2.0
angle_pop_rad = math.pi - angle_rad
print """
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->

<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   width="210mm"
   height="297mm"
   viewBox="0 0 210 297"
   id="svg2"
   version="1.1"
   inkscape:version="0.91 r13725"
   sodipodi:docname="base.svg">
  <defs
      id="defs4" >
        <g id="bord">
        <path
           style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:but;stroke-linejoin:miter;stroke-opacity:1;stroke:blue"
           d="M 3,0 L 57.33,0"
           id="path4182"
           inkscape:connector-curvature="0"
           sodipodi:nodetypes="csc" />
        <path
           style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:but;stroke-linejoin:miter;stroke-opacity:1;stroke:blue"
           d="M 69.333,0 187,0 a 3,3 0 0 1 %s %s"
           id="path4183"
           inkscape:connector-curvature="0"
           sodipodi:nodetypes="csc" />	
        <path
	    transform="translate(63.333,0)rotate(180)"
            style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:round;stroke-linejoin:miter;stroke-opacity:1;stroke:red"
            d="M -4,-3 L -10,3 C -10,15 10,15 10,3 L 4,-3"
            id="tirette"
            inkscape:connector-curvature="0"
            sodipodi:nodetypes="csc" />
        <path
	    transform="translate(126.666,3)"
            style="fill:none;fill-rule:evenodd;stroke:#000000;stroke-width:1px;stroke-linecap:round;stroke-linejoin:miter;stroke-opacity:1;stroke:green"
            d="M -10,6 L -4,0 4,0 10,6"
            id="path4184"
            inkscape:connector-curvature="0"
            sodipodi:nodetypes="csc" />		
	</g>
""" % (radius * (1-math.cos(angle_pop_rad)), radius * (1-math.cos(angle_pop_rad)))
print('<g id="template-%d">' % (cote))
dx = 0
dy = 0
for i in xrange(cote):
    angle = i * 360 / cote # in degrees
    angle_rad = math.radians(angle)
    print('  <g transform="translate({0},{1})"><use x="0" y="0" xlink:href="#bord" transform="rotate({2})"/></g>'.format(dx, dy, angle))
    dx += 190 * math.cos(angle_rad)
    dy += 190 * math.sin(angle_rad)
print("</g>")
print "a 3,3 0 0 1 %s,%s " % (radius * (1-math.cos(angle_pop_rad)), radius * (1-math.cos(angle_pop_rad)))
print """ </defs>
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="1"
     inkscape:cx="210"
     inkscape:cy="297"
     inkscape:document-units="mm"
     inkscape:current-layer="layer1"
     showgrid="true"
     objecttolerance="20"
     guidetolerance="10000"
     gridtolerance="10000"
     inkscape:window-width="1920"
     inkscape:window-height="961"
     inkscape:window-x="0"
     inkscape:window-y="49"
     inkscape:window-maximized="1">
    <inkscape:grid
       type="xygrid"
       id="grid4148"
       units="mm"
       spacingx="1"
       spacingy="1"
       snapvisiblegridlinesonly="true"
       dotted="false" />
  </sodipodi:namedview>
  <metadata
     id="metadata7">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g
     inkscape:label="Calque 1"
     inkscape:groupmode="layer"
     id="layer1"
     >
    <g>
      <use x="0" y="0" xlink:href="#template-%s"/>
    </g>
  </g>
</svg>
""" % (cote)
