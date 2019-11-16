extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
var motion = Vector2()
func _ready():
	name = "Bird"
	motion.x =-2
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_collide(motion)

