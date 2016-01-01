#!/usr/bin/python
# from turtle import Turtle
# from turtle import done
from SVGTurtle import Turtle, done
import math

def triangle(t, l):
    for i in xrange(3):
        t.forward(l)
        t.right(120)

def sierpinski_inner(t, l, space):
    inner_length = l / 2 - 2 * math.cos(math.pi * 30.0 / 180.0) * space
    if inner_length < space:
        return
    t.penup()
    t.forward(l / 2)
    t.right(90)
    t.forward(space)
    t.left(30)
    t.pendown()
    triangle(t, inner_length)
    t.penup()
    t.left(150)
    t.forward(space)
    t.right(90)
    t.pendown()
    sierpinski_inner(t, l / 2, space)
    t.penup()
    t.left(180)
    t.forward(l/2)
    t.right(180)
    t.pendown()
    sierpinski_inner(t, l / 2, space)
    t.penup()
    t.right(60)
    t.forward(l/2)
    t.left(60)
    t.pendown()
    sierpinski_inner(t, l / 2, space)
    t.penup()
    t.left(120)
    t.forward(l / 2)
    t.right(120)
    t.pendown()

def sierpinski(t, l, space):
    t.left(60)
    triangle(t, l)
    sierpinski_inner(t, l, space)
    
t = Turtle()
sierpinski(t, 210, 1)


done()
