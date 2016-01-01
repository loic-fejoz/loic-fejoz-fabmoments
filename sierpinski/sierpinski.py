#!/usr/bin/python
import turtle

def triangle(t, l):
    for i in xrange(3):
        t.forward(l)
        t.right(120)

def sierpinski_inner(t, l):
    if l < 20:
        return
    t.penup()
    t.forward(l/2)
    t.right(60)
    t.pendown()
    triangle(t, l / 2)
    t.left(60)
    sierpinski_inner(t, l / 2)
    t.left(180)
    t.forward(l/2)
    t.right(180)
    sierpinski_inner(t, l / 2)
    t.right(60)
    t.forward(l / 2)
    t.left(60)
    sierpinski_inner(t, l / 2)
    t.left(120)
    t.penup()
    t.forward(l / 2)
    t.right(120)
    t.pendown()

def sierpinski(t, l):
    t.left(60)
    triangle(t, l)
    sierpinski_inner(t, l)
    
t = turtle.Turtle()
sierpinski(t, 500)


turtle.done()
