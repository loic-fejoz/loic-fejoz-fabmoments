from turtle import Vec2D
import sys

_turtles = []

class Turtle(object):
    def __init__(self):
        self.position = Vec2D(0, 0)
        self.direction = Vec2D(1, 0)
        _turtles.append(self)
        self.paths = []
        self.pendown()

    def penup(self):
        self.isDrawing = False
        self.done()

    def pendown(self):
        self.isDrawing = True
        self.currentPath = [self.position]

    def right(self, angle):
        self.direction = self.direction.rotate(-angle)

    def left(self, angle):
        self.direction = self.direction.rotate(angle)

    def forward(self, distance):
        initialPosition = self.position
        self.position = self.position + self.direction * distance
        if self.isDrawing:
            self.currentPath.append(self.position)

    def done(self):
        if len(self.currentPath) > 1:
            self.paths.append(self.currentPath)
            self.currentPath = None        

def done():
    sys.stdout.write("""<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   version="1.1"
   x="0"
   y="0"
   width="210mm"
   height="297mm"
   viewBox="0 0 210 297"
   id="turtle-svg">
""")
    i = 0
    for turtle in _turtles:
        i += 1
        sys.stdout.write('<g id="turtle' + str(i)  + '" inkscape:groupmode="layer" inkscape:label="turtle' + str(i) + '" >\n')
        for path in turtle.paths:
            sys.stdout.write('  <path style="fill:none;stroke:#000000;stroke-width:0.2;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" \n')
            sys.stdout.write('        d="')
            cmd = 'M'
            for pt in path:
                sys.stdout.write(cmd + "%d,%d " % (pt[0], pt[1]))
                cmd = 'L'
            sys.stdout.write('" />\n')
        sys.stdout.write("</g>\n")
    sys.stdout.write("</svg>")
