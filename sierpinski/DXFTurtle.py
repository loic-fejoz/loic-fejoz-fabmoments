from turtle import Vec2D

class Turtle(object):
    def __init__(self):
        self.position = Vec2D(0, 0)
        self.direction = Vec2D(1, 0)
        self.isDrawing = True

    def penup(self):
        self.isDrawing = False

    def pendown(self):
        self.isDrawing = True

    def right(self, angle):
        self.direction.rotate(-angle)

    def left(self, angle):
        self.direction.rotate(angle)

    def forward(self, distance):
        initialPosition = self.position
        self.position += self.direction * distance
        if self.isDrawing:
            pass


def done():
    print """999
DXF create from Python DXFTurtle
0
SECTION
2
HEADER
9
$ACADVER
1
AC1006
9
$INSBASE
10
0.0
20
0.0
30
0.0
9
$EXTMIN
10
0.0
20
0.0
9
$EXTMAX
10
1000.0
20
1000.0
0
ENDSEC"""
