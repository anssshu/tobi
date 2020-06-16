extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = rand_range(10,200)
	position.x = rand_range(-50,-100)
	var s = rand_range(.2,.4)
	speed = rand_range(1,2)
	scale = Vector2(-s,s)
	$Sprite.modulate = Color(rand_range(.5,1.0),rand_range(.5,1.0),rand_range(.5,1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(1*speed,0)
	if position.x > 1030 :
		queue_free()