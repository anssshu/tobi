extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bird = preload("res://objects/bg_bird/bg_bird.tscn")
var timer
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	timer.connect("timeout",self,"_on_timeout")
	timer.start()
	add_child(bird.instance())
func _on_timeout():
	#print("time_out")
	add_child(bird.instance())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
