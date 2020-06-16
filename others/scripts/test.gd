#This is the simple gd script to create a simmple behaviour


"""
lets create the program to control the character
sdasdsada
"""
#v control direction of motion
var dir = {
    left = Vector2(-1,0),
    right = Vector2(1,0),
    up = Vector2(0,1),
    down = Vector2(0,-1)
}
var v = Vector2()
var speed = 1

func _ready():
    pass

func  _physics_process(dt):
    var left = Input.is_action_pressed("ui_left")
    var right = Input.is_action_pressed("ui_right")
    var up = Input.is_action_pressed("ui_up")
    var down = Input.is_action_pressed("ui_down")

    if left:
        v = dir.left*speed
    if right:
        v = dir.right*speed
    if up:
        v= dir.up*speed
    if down:
        v = dir.down*speed
