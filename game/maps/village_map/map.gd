#res://maps/village/map.gd
extends Node2D

#load the bird
var bird = preload("res://objects/bg_bird/bg_bird.tscn")



func _ready():
	#connect the timer and start it
	$bird_timer.connect("timeout",self,"_on_bird_timer_timeout")
	$bird_timer.start()
	
	#add a bird to the scene
	spawn_bird()

	
#add a bird on the sbackground
func spawn_bird():
	$background.add_child(bird.instance())

#when the bird timer starts spawn a bird in the scene
func _on_bird_timer_timeout():
	#spawn bird in the scene
	spawn_bird()